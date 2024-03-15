class Tarefa {
  Tarefa({required this.id, required this.titulo, required this.realizado});

  int id;
  String titulo;
  bool realizado;

  Map<String, dynamic> toJson() {
    return {
      "int": id,
      "titulo": titulo,
      "realizado": realizado,
    };
  }
}
