class TipoPago{
  String tipoPago;

  TipoPago({
    required this.tipoPago
  });

  factory TipoPago.fromString(String value) {
    return TipoPago(tipoPago: value);
  }

  Map<String, dynamic> toJson(){
    return {
      'tipoPago': tipoPago
    };
  }
}