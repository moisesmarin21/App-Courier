class Direccion {
  final int? id;
  final String direccion;
  final String? referencia;

  Direccion({
    this.id,
    required this.direccion,
    this.referencia,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      id: json['id'],
      direccion: json['direccion'],
      referencia: json['referencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direccion': direccion,
      'referencia': referencia,
    };
  }

  @override
  String toString() {
    return 'Direccion{id: $id, direccion: $direccion, referencia: $referencia}';
  }
}