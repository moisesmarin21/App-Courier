class Encomienda{
  String? id;
  String? serieRemito;
  String? agenciaOrigen;
  String? agenciaDestino;
  int? idAgenciaDestino;
  
  int? idRemitente;
  String? remitente;
  String? remitenteDocumento;
  String? remitenteDireccion;
  String? remitenteContacto;
  String? remitenteCelular;
  int? remitenteIdDistritoDomicilio;

  int? idDestinatario;
  String? destinatario;
  String? destinatarioDocumento;
  String? destinatarioDireccion;
  String? destinatarioContacto;
  String? destinatarioCelular;
  int? destinatarioIdDistritoDomicilio;

  String? tipoPago;
  String? tipoEntrega;
  String? costoTotal;
  String? kg;
  String? fecha;
  String? fechaEntrega;
  String? cantidad;
  String? medio;
  String? observacion;
  String? guiaRemitente;
  String? ultimoEstado;
  String? colorEstado;
  String? motorizado;
  int? cantidadTotal;

  String? banco;
  String? nroOperacion;

  String? tipoEnvio;
  
  Encomienda({
    this.id,
    this.serieRemito,
    this.agenciaOrigen,
    this.agenciaDestino,
    this.idAgenciaDestino,

    this.idRemitente,
    this.remitente,
    this.remitenteDocumento,
    this.remitenteDireccion,
    this.remitenteContacto,
    this.remitenteCelular,
    this.remitenteIdDistritoDomicilio,

    this.idDestinatario,
    this.destinatario,
    this.destinatarioDocumento,
    this.destinatarioDireccion,
    this.destinatarioContacto,
    this.destinatarioCelular,
    this.destinatarioIdDistritoDomicilio,

    this.tipoPago,
    this.tipoEntrega,
    this.tipoEnvio,
    this.costoTotal,
    this.kg,
    this.fecha,
    this.fechaEntrega,
    this.cantidad,
    this.medio,
    this.observacion,
    this.guiaRemitente,
    this.ultimoEstado,
    this.colorEstado,
    this.motorizado,
    this.cantidadTotal,

    this.banco,
    this.nroOperacion,
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

  Map<String, dynamic> toJson(){
    return{
      "tipo_entrega": tipoEntrega,
      "tipo_envio": tipoEnvio,
      "id_agencia_destino": idAgenciaDestino,
      "remitente_id": idRemitente,
      "remitente_documento": remitenteDocumento, 
      "remitente_direccion": remitenteDireccion,
      "remitente_contacto_nombre": remitenteContacto,
      "remitente_contacto_celular": remitenteCelular,
      "remitente_id_distrito_a_domicilio": remitenteIdDistritoDomicilio,//si el origen es domicilio (tipo entrega)
      "destinatario_id": idDestinatario,
      "destinatario_documento": destinatarioDocumento,
      "destinatario_contacto_nombre": destinatarioContacto,
      "destinatario_contacto_celular": destinatarioCelular,
      "destinatario_direccion": destinatarioDireccion,
      "destinatario_id_distrito_a_domicilio": destinatarioIdDistritoDomicilio,//si el destino es domicilio (tipo entrega)
      "fecha_entrega": fechaEntrega,
      "costo_total": costoTotal,
      "cantidad": cantidad,  
      "kilos": kg,
      "observacion": observacion,
      "tipo_pago": tipoPago,
      "guia_remitente": guiaRemitente,
      "banco": banco, //condicional tipo pago deposito
      "nro_operacion": nroOperacion //condicional tipo pago deposito
    };
  }

  @override
  String toString() {
    return 'Encomiendas{id: $id, agencia_origen: $agenciaOrigen, agencia_destino: $agenciaDestino, remitente:$remitente, destinatario: $destinatario}';
  }
}