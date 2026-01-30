class PrecioCalculo {
  double precio;
  double servicioAdicional;
  double servicioMovilidad;
  double pesoMinimo;
  double precioMinimo;
  bool existePrecio;

  PrecioCalculo({
    required this.precio,
    required this.servicioAdicional,
    required this.servicioMovilidad,
    required this.pesoMinimo,
    required this.precioMinimo,
    required this.existePrecio,
  });

  factory PrecioCalculo.fromJson(Map<String, dynamic> json) {
    return PrecioCalculo(
      precio: (json['precio'] ?? 0).toDouble(),
      servicioAdicional: (json['servicio_adicional'] ?? 0).toDouble(),
      servicioMovilidad: (json['servicio_movilidad'] ?? 0).toDouble(),
      pesoMinimo: (json['peso_minimo'] ?? 0).toDouble(),
      precioMinimo: (json['precio_minimo'] ?? 0).toDouble(),
      existePrecio: json['existe_precio'] ?? false,
    );
  }
}
