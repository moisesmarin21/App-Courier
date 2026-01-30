class Department{
  int idDepartamento;
  String departamento;

  Department({
    required this.idDepartamento,
    required this.departamento
  });

  factory Department.fromJSON(Map<String, dynamic> json){
     return Department(
      idDepartamento: json['id'],
      departamento: json['departamento']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idDepartamento,
      'departamento': departamento
    };
  }

  @override
  String toString() {
    return 'Department{id: $idDepartamento, departamento: $departamento}';
  }
}
