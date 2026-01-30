class Province{
  int idProvincia;
  String provincia;

  Province({
    required this.idProvincia,
    required this.provincia
  });

  factory Province.fromJSON(Map<String, dynamic> json){
     return Province(
      idProvincia: json['id'],
      provincia: json['provincia']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idProvincia,
      'provincia': provincia
    };
  }

  @override
  String toString() {
    return 'Province{id: $idProvincia, provincia: $provincia}';
  }
}
