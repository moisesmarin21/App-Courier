class Sucursal{
  int id;
  String nombre;
  String direccion;
  String telefono;
  
  String? serieRemito;
  int? tipo;
  int? idDistrito;
  String? celular;
  String? serieBoleta;
  String? serieFactura;
  String? serieNcFactura;
  String? serieNcBoleta;
  String? serieCaja;
  String? serieTransportista;
  int? idPlan;
  String? distritoNombre;
  String? planNombre;

  Sucursal({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,

    this.serieRemito,
    this.tipo,
    this.idDistrito,
    this.celular,
    this.serieBoleta,
    this.serieFactura,
    this.serieNcFactura,
    this.serieNcBoleta,
    this.serieCaja,
    this.serieTransportista,
    this.idPlan,
    this.distritoNombre,
    this.planNombre
  });

  factory Sucursal.fromJson(Map<String, dynamic> json){
    return Sucursal(
      id: json['id'], 
      nombre: json['nombre'], 
      direccion: json['direccion'], 
      telefono: json['telefono'],

      serieRemito: json['serie_remito'],
      tipo: json['tipo'],
      idDistrito: json['id_distrito'],
      celular: json['celular'],
      serieBoleta: json['serie_boleta'],
      serieFactura: json['serie_factura'],
      serieNcFactura: json['serie_nc_factura'],
      serieNcBoleta: json['serie_nc_boleta'],
      serieCaja: json['serie_caja'],
      serieTransportista: json['serie_transportista'],
      idPlan: json['id_plan'],
      distritoNombre: json['distrito_nombre'],
      planNombre: json['plan_nombre']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,

      'serie_remito': serieRemito,
      'tipo': tipo,
      'id_distrito': idDistrito,
      'celular': celular,
      'serie_boleta': serieBoleta,
      'serie_factura': serieFactura,
      'serie_nc_factura': serieNcFactura,
      'serie_nc_boleta': serieNcBoleta,
      'serie_caja': serieCaja,
      'serie_transportista': serieTransportista,
      'id_plan': idPlan,
      'distrito_nombre': distritoNombre,
      'plan_nombre': planNombre
    };
  }

  @override
  String toString() {
    return 'Sucursales{id: $id, nombre: $nombre, direccion: $direccion, telefono: $telefono}';
  }

}