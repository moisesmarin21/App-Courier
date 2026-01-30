class HistorialEstado {
  int? id;
  int idEstado;
  String nombre;
  String fecha;
  String hora;
  String comentario;
  int idPersonal;
  String nombrePersonal;
  String nombreAgencia;

  HistorialEstado({
    this.id,
    required this.idEstado,
    required this.nombre,
    required this.fecha,
    required this.hora,
    required this.comentario,
    required this.idPersonal,
    required this.nombrePersonal,
    required this.nombreAgencia
  });

  factory HistorialEstado.fromJson(Map<String, dynamic> json) {
    return HistorialEstado(
      id: json['id'],
      idEstado: json['id_estado'], 
      nombre: json['nombre'], 
      fecha: json['fecha'], 
      hora: json['hora'], 
      comentario: json['comentario'], 
      idPersonal: json['id_personal'], 
      nombrePersonal: json['nombre_personal'], 
      nombreAgencia: json['nombre_agencia']
    ); 
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'id_estado': idEstado,
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
      'comentario': comentario,
      'id_personal': idPersonal,
      'nombre_personal': nombrePersonal,
      'nombre_agencia': nombreAgencia
    };
  }

  @override
  String toString() {
    return 'historialEstados{id: $id, id_Estado: $idEstado, nombre: $nombre, fecha: $fecha, hora: $hora, comentario: $comentario, id_personal: $idPersonal, nombre_personal: $nombrePersonal, nombre_agencia: $nombreAgencia}';
  }

}