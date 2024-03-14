class Tarefa {
  Tarefa({required this.titulo, required this.realizado});

  String titulo;
  bool realizado;

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "realizado": realizado,
    };
  }
}