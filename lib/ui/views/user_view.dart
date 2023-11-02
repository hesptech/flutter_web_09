import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:admin_dashboard/models/usuario.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:admin_dashboard/providers/user_form_provider.dart';
import 'package:admin_dashboard/providers/user_provider.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:email_validator/email_validator.dart';

class UserView extends StatefulWidget {
  
  final String uid;
  
  const UserView({
    Key? key, 
    required this.uid}
  ) :super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  Usuario? user;

  @override
  void initState() {
    super.initState();

    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final userFormProvider = Provider.of<UserFormProvider>(context, listen: false);
    
    usersProvider.getUserById(widget.uid)
      .then((userDB) {

        if ( userDB != null ) {
          userFormProvider.user = userDB;
          userFormProvider.formKey = new GlobalKey<FormState>();
          setState(() { this.user = userDB; });
        } else {
          NavigationService.replaceTo('/dashboard/users');
        }
      }
    );
  }

  @override
  void dispose() {
    this.user = null;
    Provider.of<UserFormProvider>(context, listen: false).user = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(user == null) {
      return WhiteCard(
        child: Container(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    }

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('User View', style: CustomLabels.h1 ),

          SizedBox( height: 10 ),

          if(user == null) 
            WhiteCard(
              child: Container(
                alignment: Alignment.center,
                height: 300,
                child: CircularProgressIndicator(),
              )
            ),
          
          if(user != null)
          _UserViewBody()
        ],
      ),
    );
  }
}

class _UserViewBody extends StatelessWidget {
  const _UserViewBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(250)
        },

        children: [
          TableRow(
            children: [
              _AvatarContainer(),

              _UserViewForm()
            ]
          )
        ],
      ),
    );
  }
}

class _UserViewForm extends StatelessWidget {
  const _UserViewForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user!;
    
    return WhiteCard(
      title: 'Informacion general',
      child: Form(
        key: userFormProvider.formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              initialValue: user.nombre,
              decoration: CustomInputs.formInputDecoration(
                hint: 'nombre Usuario', 
                label: 'Nombre', 
                icon: Icons.supervised_user_circle_outlined,
              ),
              /* onChanged: ( value ) { 
                user.nombre = value;
                userFormProvider.updateListener(); 
              }, */
              onChanged: (value) => userFormProvider.copyUserWith( nombre: value ),
              validator: ( value ) {
                if (value == null || value.isEmpty) return 'Enter name.';
                if (value.length < 2) return 'name must have 2 letters min.';
                return null;
              },
            ),

            SizedBox(height: 20.0),

            TextFormField(
              initialValue: user.correo,
              decoration: CustomInputs.formInputDecoration(
                hint: 'E-mail Usuario', 
                label: 'e-mail', 
                icon: Icons.mark_email_read_outlined,
              ),
              onChanged: ( value ) => user.correo = value,
              validator: ( value ) {
                if( !EmailValidator.validate(value ?? '') ) return 'Email no válido';

                return null;
              },
            ),

            SizedBox(height: 20.0,),

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: ElevatedButton(
                onPressed: () async {
                  final saved = await userFormProvider.updateUser();
                  if (saved) {
                    NotificationsService.showSnackBar('user updated');
                    Provider.of<UsersProvider>(context, listen: false).refreshUser(user);
                  }else {
                    NotificationsService.showSnackBar('user NOT updated');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Row(
                  children: [
                    Icon(Icons.save_outlined, size: 20.0),
                    Text(' SAVE')
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class _AvatarContainer extends StatelessWidget {
  const _AvatarContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user!; 

    final image = ( user.img == null)
      ? Image(image: AssetImage('noimage.jpg'))
      : FadeInImage.assetNetwork(placeholder: 'loader.gif', image: user.img!);
    
    return WhiteCard(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile', style: CustomLabels.h2,),
            SizedBox(height: 20.0,),

            Container(
              width: 150,
              height: 160,
              child: Stack(
                children: [
                  ClipOval(
                    child: image,
                  ),

                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      height: 45.0,
                      width: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white, width: 3.0),
                        //color: Colors.red
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Colors.indigo,
                        elevation: 0,
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                             type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                            allowMultiple: false,
                          );

                          if (result != null) {

                            //print(file.name);
                            //print(file.bytes);
                            //print(file.size);
                            //print(file.extension);
                            //print(file.path);

                            NotificationsService.showBusyIndicator( context );
                            final newUser = await userFormProvider.uploadImage('/uploads/usuarios/${ user.uid }', result.files.first.bytes!);
                            //print(resp.img);
                            Navigator.of(context).pop();



                            Provider.of<UsersProvider>(context, listen: false).refreshUser(newUser);


                          } else {
                            // User canceled the picker
                          }

                        },
                        child: Icon(Icons.camera_alt_outlined, size: 20.0,),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20.0,),
            Text(
              user.nombre, 
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ));
  }
}