class District{
  int idDistrito;
  String distrito;

  District({
    required this.idDistrito,
    required this.distrito
  });

  factory District.fromJSON(Map<String, dynamic> json){
     return District(
      idDistrito: json['id'] ?? 0,
      distrito: json['distrito']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idDistrito,
      'distrito': distrito
    };
  }

  @override
  String toString() {
    return 'District{id: $idDistrito, distrito: $distrito}';
  }
}
