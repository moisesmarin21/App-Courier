class Estado{
  int? id;
  String nombre;

  Estado({
    this.id,
    required this.nombre
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      id: json['id'],
      nombre: json['nombre']
    );
  }
}