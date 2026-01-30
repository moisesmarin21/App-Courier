class Encomienda{
  String? id;
  String serieRemito;
  String agenciaOrigen;
  String agenciaDestino;
  
  String remitente;
  String remitenteDocumento;
  String remitenteDireccion;
  String? remitenteCelular;

  String destinatario;
  String destinatarioDocumento;
  String destinatarioDireccion;
  String? destinatarioCelular;

  String tipoPago;
  String tipoEntrega;
  String? costoTotal;
  String? kg;
  String fecha;
  String fechaEntrega;
  String cantidad;
  String medio;
  String observacion;
  String ultimoEstado;
  String colorEstado;
  String? motorizado;
  int cantidadTotal;
  
  Encomienda({
    this.id,
    required this.serieRemito,
    required this.agenciaOrigen,
    required this.agenciaDestino,

    required this.remitente,
    required this.remitenteDocumento,
    required this.remitenteDireccion,
    this.remitenteCelular,

    required this.destinatario,
    required this.destinatarioDocumento,
    required this.destinatarioDireccion,
    this.destinatarioCelular,

    required this.tipoPago,
    required this.tipoEntrega,
    this.costoTotal,
    this.kg,
    required this.fecha,
    required this.fechaEntrega,
    required this.cantidad,
    required this.medio,
    required this.observacion,
    required this.ultimoEstado,
    required this.colorEstado,
    this.motorizado,
    required this.cantidadTotal,

  });

  factory Encomienda.fromJson(Map<String, dynamic> json){
    return Encomienda(
      id: json['id'],
      serieRemito: json['serie_remito'],
      agenciaOrigen: json['agencia_origen'],
      agenciaDestino: json['agencia_destino'],

      remitente: json['remitente_nombre'],
      remitenteDocumento: json['remitente_documento'],
      remitenteDireccion: json['remitente_direccion'],
      remitenteCelular: json['celularremitente'],

      destinatario: json['destinatario_nombre'],
      destinatarioDocumento: json['destinatario_documento'],
      destinatarioDireccion: json['destinatario_direccion'],
      destinatarioCelular: json['celulardestino'],

      tipoPago: json['tipo_pago'],
      tipoEntrega: json['tipo_entrega'],
      costoTotal: json['costo_total'],
      kg: json['kg'],
      fecha: json['fecha'],
      fechaEntrega: json['fecha_entrega'],
      cantidad: json['cantidad'],
      medio: json['medio'],
      observacion: json['observacion'],
      ultimoEstado: json['ultimo_estado'],
      colorEstado: json['color_estado'],
      motorizado: json['motorizado'],
      cantidadTotal: json['cantidad_total'],
    );
  }

  @override
  String toString() {
    return 'Encomiendas{id: $id, agencia_origen: $agenciaOrigen, agencia_destino: $agenciaDestino, remitente:$remitente, destinatario: $destinatario}';
  }
}