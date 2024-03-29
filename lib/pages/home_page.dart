import 'package:flutter/material.dart';
import 'package:lista_tarefas_banco_local/models/tarefa.dart';
import 'package:lista_tarefas_banco_local/repositories/repositorio2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controlerTarefa = TextEditingController();

  Repositorio2 _repositorio = Repositorio2();
  List<Tarefa> tarefas = [];

  @override
  void initState() {
    super.initState();
    _repositorio.recuperarLista().then((dados) {
      setState(() {
        tarefas = dados;
      });
    });
  }

  void _adicionarTarefa() {
    setState(() {
      Tarefa tarefa =
          Tarefa(id: 0, titulo: controlerTarefa.text, realizado: false);
      tarefas.add(tarefa);
      controlerTarefa.text = '';
      _repositorio.salvarUltimaTarefa(tarefa);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text(
          "Lista de tarefas",
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 10.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  decoration: const InputDecoration(labelText: "Nova tarefa"),
                  controller: controlerTarefa,
                )),
                ElevatedButton(
                    onPressed: _adicionarTarefa, child: const Text("ADD"))
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: tarefas.length, itemBuilder: contruirListView))
        ],
      ),
    );
  }

  Widget contruirListView(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(tarefas[index].titulo),
        value: tarefas[index].realizado,
        secondary: CircleAvatar(
          child: Icon(tarefas[index].realizado ? Icons.check : Icons.error),
        ),
        onChanged: (checked) {
          setState(() {
            tarefas[index].realizado = checked!;
            _repositorio.atualizaTarefa(tarefas[index], tarefas[index].id);
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          Tarefa tarefaRemovida = tarefas[index];
          tarefas.removeAt(index);
          //_repositorio.salvarLista(tarefas);
          _repositorio.removerTarefa(tarefaRemovida.id);
          int indiceTarefaRemovida = index;

          final snack = SnackBar(
            content: Text("Tarefa ${tarefaRemovida.titulo} removida"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    tarefas.insert(indiceTarefaRemovida, tarefaRemovida);
                    _repositorio.salvarUltimaTarefa(tarefaRemovida);
                    //_repositorio.salvarLista(tarefas);
                  });
                }),
            duration: const Duration(seconds: 3),
          );

          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
  }
}
