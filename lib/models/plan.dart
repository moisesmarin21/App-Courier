class Plan{
  int idPlan;
  String plan;
  String tarifaBase;
  int pesoBase;
  String precioExceso;
  String precioSobre;
  int estado;
  String fecha;
  int? idUbicacion;

  Plan({
    required this.idPlan,
    required this.plan,
    required this.tarifaBase,
    required this.pesoBase,
    required this.precioExceso,
    required this.precioSobre,
    required this.estado,
    required this.fecha,
    this.idUbicacion
  });

  factory Plan.fromJson(Map<String, dynamic> json){
    return Plan(
      idPlan: json['id'],
      plan: json['nombre'],
      tarifaBase: json['tarifa_base'],
      pesoBase: json['peso_base'],
      precioExceso: json['precio_exceso'],
      precioSobre: json['precio_sobre'],
      estado: json['estado'],
      fecha: json['fecha'],
      idUbicacion: json['id_ubicacion']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': idPlan,
      'nombre': plan,
      'tarifa_base': tarifaBase,
      'peso_base': pesoBase,
      'precio_exceso': precioExceso,
      'precio_sobre': precioSobre,
      'estado': estado,
      'fecha': fecha,
      'id_ubicacion': idUbicacion
    };
  }

  @override
  String toString() {
    return 'Plan{id: $idPlan, nombre: $plan, tarifa_base: $tarifaBase, peso_base: $pesoBase, precio_exceso: $precioExceso, precio_sobre: $precioSobre, estado: $estado, fecha: $fecha, id_ubicacion: $idUbicacion}';
  }
}