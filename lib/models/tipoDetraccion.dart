class TipoDetraccion {
  int idTipoDetraccion;
  String codigo;
  int codigoNubefact;
  String tipoDetraccion;
  String porcentaje;

  TipoDetraccion({
    required this.idTipoDetraccion,
    required this.codigo,
    required this.codigoNubefact,
    required this.tipoDetraccion,
    required this.porcentaje
  });

  factory TipoDetraccion.fromJSON(Map<String, dynamic> json){
    return TipoDetraccion(
      idTipoDetraccion: json['id'],
      codigo: json['codigo'],
      codigoNubefact: json['codigo_nubefact'],
      tipoDetraccion: json['nombre'],
      porcentaje: json['porcentaje'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': idTipoDetraccion,
      'codigo': codigo,
      'codigo_nubefact': codigoNubefact,
      'nombre': tipoDetraccion,
      'porcentaje': porcentaje,
    };
  }

  @override
  String toString() {
    return 'TiposDetraccion{idTipoDetraccion: $idTipoDetraccion, codigo: $codigo, codigo_nubefact: $codigoNubefact, nombre: $tipoDetraccion, porcentaje: $porcentaje';
  }  
}