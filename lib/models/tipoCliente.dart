class TipoCliente {
  final String tipoCliente;

  TipoCliente({required this.tipoCliente});

  factory TipoCliente.fromString(String value) {
    return TipoCliente(tipoCliente: value);
  }

  @override
  String toString() {
    return 'TiposCliente{tipoCliente: $tipoCliente}';
  }
}