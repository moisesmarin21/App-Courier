class TipoEntrega{
  String tipoEntrega;

  TipoEntrega({
    required this.tipoEntrega
  });

  factory TipoEntrega.fromString(String value) {
    return TipoEntrega(tipoEntrega: value);
  }

  Map<String, dynamic> toJson(){
    return {
      'tipoEntrega': tipoEntrega
    };
  }
}