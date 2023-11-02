import 'dart:convert';

import 'package:admin_dashboard/models/usuario.dart';

class UsersResponse {
    int total;
    List<Usuario> usuarios;

    UsersResponse({
        required this.total,
        required this.usuarios,
    });

    factory UsersResponse.fromRawJson(String str) => UsersResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        total: json["total"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}



enum Rol {
    USER_ROLE
}

final rolValues = EnumValues({
    "USER_ROLE": Rol.USER_ROLE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
