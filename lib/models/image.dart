class Imagen{
  int? id;
  String imagen;

  Imagen({
    this.id,
    required this.imagen
  });

  factory Imagen.fromJson(Map<String, dynamic> json){
    return Imagen(
      imagen: json['imagen']
    );
  }
}