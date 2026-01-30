import 'package:courier/models/direccion.dart';

class Customer {
  int? id;
  String? nombres;
  String nroDocumento;
  String? razonSocial;
  String? celular;
  int? idDepartamento;
  int? idProvincia;
  int? idDistrito;
  List<Direccion> direcciones;
  String? tipoCliente;
  String? tipoPago;
  int? igv;
  int? idTipoDetraccion;
  int? idPlan;
  int? extraDomDom;
  int? extraAgeDom;
  int? extraDomAge;
  
  String? lat;
  String? lon;
  String? distritoNombre;
  String? planNombre;

  String? provinciaNombre;
  String? departamentoNombre;
  int? idListaPrecio;

  Customer({
    this.id,
    this.nombres,
    required this.nroDocumento,
    this.razonSocial,
    this.celular,
    this.idDepartamento,
    this.idProvincia,
    this.idDistrito,
    this.direcciones = const [],
    this.tipoCliente,
    this.tipoPago,
    this.igv,
    this.idTipoDetraccion,
    this.idPlan,
    this.extraDomDom,
    this.extraDomAge,
    this.extraAgeDom,

    this.lat,
    this.lon,
    this.distritoNombre,
    this.planNombre,

    //CAMPOS ADICIONALES PARA LLAMAR CLIENTE POR ID
    this.provinciaNombre,
    this.departamentoNombre,
    this.idListaPrecio,
  });

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json['id'],
      idDistrito: json['id_distrito'],
      nroDocumento: json['numero_documento'],
      nombres: json['nombre'],
      lat: json['lat'],
      lon: json['lon'],
      distritoNombre: json['distrito_nombre'],
      planNombre: json['plan_nombre'],
      celular: json['celular'],
      extraDomDom: json['extra_domdom'],
      extraDomAge: json['extra_domage'],
      extraAgeDom: json['extra_agedom'],
      tipoCliente: json['tipo_cliente'],
      igv: json['incluye_igv'],
      tipoPago: json['tipo_pago'],      
    );
  }

  factory Customer.fromCustomerByIdJson(Map<String, dynamic> json){
    return Customer(
      id: json['id'],
      idDistrito: json['id_distrito'],
      nroDocumento: json['numero_documento'],
      nombres: json['nombre'],
      lat: json['lat'],
      lon: json['lon'],
      idTipoDetraccion: json['id_tipo_detraccion'],
      idListaPrecio: json['id_lista_precio'],
      distritoNombre: json['distrito_nombre'],
      provinciaNombre: json['provincia_nombre'],
      departamentoNombre: json['departamento_nombre'],
      planNombre: json['plan_nombre'],
      celular: json['celular'],
      extraDomDom: json['extra_domdom'],
      extraDomAge: json['extra_domage'],
      extraAgeDom: json['extra_agedom'],
      tipoCliente: json['tipo_cliente'],
      igv: json['incluye_igv'],
      tipoPago: json['tipo_pago'],
      direcciones: (json['direcciones'] as List<dynamic>?)
          ?.map((e) => Direccion.fromJson(e))
          .toList() ??
          [],      
    );
  }

  factory Customer.fromSearchJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      nombres: json['nombre'] ?? json['nombres'],
      nroDocumento: json['numero_documento'],
    );
  }

  Map <String, dynamic> toJson() {
    return {
      "numero_documento": nroDocumento,
      "nombres": nombres,
      "id_lista_precio": idPlan,
      "id_distrito": idDistrito,
      "celular": celular ?? '',
      "tipo_cliente": tipoCliente, ///EDITAR LLAMAR NOMBRE
      "tipo_pago": tipoPago, ///EDITAR LLAMAR NOMBRE
      "incluye_igv": igv,
      "extra_domicilio_a_domicilio": extraDomDom,
      "extra_domicilio_a_agencia": extraDomAge,
      "extra_agencia_a_domicilio": extraAgeDom,
      "id_tipo_detraccion": idTipoDetraccion,
      "direcciones": direcciones.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Customer{id: $id, nombres: $nombres, nroDocumento: $nroDocumento, razonSocial: $razonSocial, celular: $celular, idDepartamento: $idDepartamento, idProvincia: $idProvincia, idDistrito: $idDistrito, direcciones: $direcciones, tipoCliente: $tipoCliente, tipoPago: $tipoPago, igv: $igv, idTipoDetraccion: $idTipoDetraccion, idPlan: $idPlan, extraDomDom: $extraDomDom, extraAgeDom: $extraAgeDom, extraDomAge: $extraDomAge, lat: $lat, lon: $lon, distritoNombre: $distritoNombre, planNombre: $planNombre, provinciaNombre: $provinciaNombre, departamentoNombre: $departamentoNombre, idListaPrecio: $idListaPrecio}';
  }
}
