import 'package:lista_tarefas_banco_local/repositories/sqflite.dart';
import 'package:lista_tarefas_banco_local/models/tarefa.dart';

class Repositorio2 {
  Repositorio2();

  Future<void> salvarUltimaTarefa(Tarefa tarefa) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawInsert('INSERT INTO tarefas (titulo, realizado) VALUES (?,?)',
        [tarefa.titulo, tarefa.realizado ? 1 : 0]);
  }

  Future<void> removerTarefa(int id) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawDelete('DELETE FROM tarefas WHERE id=?', [id]);
  }

  Future<void> atualizaTarefa(Tarefa tarefa, int id) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawUpdate('UPDATE tarefas set titulo=?, realizado=? WHERE id=?',
        [tarefa.titulo, tarefa.realizado, id]);
  }

  Future<List<Tarefa>> recuperarLista() async {
    List<Tarefa> tarefas = [];
    var db = await SQLiteDataBase().obterDataBase();
    var result = await db.rawQuery('SELECT * FROM tarefas');
    for (var element in result) {
      tarefas.add(Tarefa(
        id: int.parse(element["id"].toString()),
        titulo: element["titulo"].toString(),
        realizado:
            int.parse(element["realizado"].toString()) == 1 ? true : false,
      ));
    }
    return tarefas;
  }
}
