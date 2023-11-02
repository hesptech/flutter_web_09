import 'dart:convert';

import 'package:admin_dashboard/models/usuario.dart';

class AuthResponse {
    Usuario usuario;
    String token;

    AuthResponse({
        required this.usuario,
        required this.token,
    });

    factory AuthResponse.fromRawJson(String str) => AuthResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "usuario": usuario.toJson(),
        "token": token,
    };
}
