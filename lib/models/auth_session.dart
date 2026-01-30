class AuthSession {
  final String token;
  final int userTypeId;
  final String nombre;
  final int idSucursal;

  AuthSession({
    required this.token,
    required this.userTypeId,
    required this.nombre,
    required this.idSucursal,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'],
      userTypeId: json['id_tipo_usuario'],
      nombre: json['fullname'],
      idSucursal: json['id_sucursal'],
    );
  }
}
