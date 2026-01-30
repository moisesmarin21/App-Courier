class TipoEnvio{
  String tipoEnvio;

  TipoEnvio({
    required this.tipoEnvio
  });

  factory TipoEnvio.fromString(String value) {
    return TipoEnvio(tipoEnvio: value);
  }

  Map<String, dynamic> toJson(){
    return {
      'tipoEnvio': tipoEnvio
    };
  }
}