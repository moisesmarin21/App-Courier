class Motorizado{
  int id;
  String nombres;
  String email;
  int idTipoUsuario;
  String dinero;
  String updatedBy;
  int idUbicacion;

  Motorizado({
    required this.id,
    required this.nombres,
    required this.email,
    required this.idTipoUsuario,
    required this.dinero,
    required this.updatedBy,
    required this.idUbicacion
  });

  factory Motorizado.fromJson(Map<String, dynamic> json){
    return Motorizado(
      id: json['id_user'],
      nombres: json['fullname'],
      email: json['email'],
      idTipoUsuario: json['id_tipo_usuario'],
      dinero: json['dinero'],
      updatedBy: json['updated_by'],
      idUbicacion: json['id_ubicacion']
    );
  }
}