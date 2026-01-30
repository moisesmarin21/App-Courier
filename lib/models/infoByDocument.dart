class InfoByDocument {
  int? id;
  String razonSocial;
  String nombreComercial;
  int? idPais;
  String direccion;
  String provincia;
  String distrito;
  String departamento;

  String? ruc;
  String? ubigeo;

  InfoByDocument({
    this.id,
    required this.razonSocial,
    required this.nombreComercial,
    this.idPais,
    required this.direccion,
    required this.provincia,
    required this.distrito,
    required this.departamento,

    this.ruc,
    this.ubigeo
  });

  factory InfoByDocument.fromJsonDni(Map<String, dynamic> json) {
    return InfoByDocument(
      razonSocial: json['razon_social'],
      nombreComercial: json['nombre_comercial'],
      idPais: json['id_pais'],
      direccion: json['direccion'],
      provincia: json['provincia'] ?? '',
      distrito: json['distrito'],
      departamento: json['departamento'],
    );
  }

  factory InfoByDocument.fromJsonRuc(Map<String, dynamic> json) {
    return InfoByDocument(
      razonSocial: json['razon_social'],
      nombreComercial: json['nombre_comercial'],
      direccion: json['direccion'],
      provincia: json['provincia'] ?? '',
      distrito: json['distrito'],
      departamento: json['departamento'],

      ruc: json['ruc'],
      ubigeo: json['ubigeo'],
    );
  }
}
