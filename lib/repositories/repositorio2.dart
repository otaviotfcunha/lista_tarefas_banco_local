import 'package:lista_tarefas_banco_local/repositories/sqflite.dart';
import 'package:lista_tarefas_banco_local/models/tarefa.dart';

class Repositorio2 {
  Repositorio2();

  Future<void> salvarLista(List<Tarefa> tarefas) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawQuery('DELETE from tarefas');
    for (Tarefa tarefa in tarefas){
      await db.rawInsert('INSERT INTO tarefas (titulo, realizado) VALUES (?,?)',[tarefa.titulo, tarefa.realizado]);
    }
  }

  Future<List<Tarefa>> recuperarLista() async {
    List<Tarefa> tarefas = [];
    var db = await SQLiteDataBase().obterDataBase();
    var result = await db.rawQuery('SELECT * FROM tarefas');
    for (var element in result) {
      tarefas.add(Tarefa(titulo:
      element["titulo"].toString(),
        realizado: int.parse(element["realizado"].toString()) == 1
            ? true
            : false,
      ));
    }
    return tarefas;
  }
}