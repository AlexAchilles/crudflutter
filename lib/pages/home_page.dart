import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudflutter/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  /// Abre a caixa de diálogo
  /// - Se [docID] == null → adiciona nova nota
  /// - Se [docID] != null → edita nota existente
  void openNoteBox({String? docID, String? currentText}) {
    if (currentText != null) {
      textController.text = currentText;
    } else {
      textController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? "Nova Nota" : "Editar Nota"),
        content: TextField(controller: textController),
        actions: [
          TextButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                // Criar nova nota
                firestoreService.addNote(textController.text);
              } else {
                // Atualizar nota existente
                firestoreService.updateNote(docID, textController.text);
              }

              textController.clear();
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Adicionar" : "Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD em Flutter")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                  trailing: IconButton(
                    onPressed: () =>
                        openNoteBox(docID: docID, currentText: noteText),
                    icon: const Icon(Icons.settings),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Sem notas, mermão!"));
          }
        },
      ),
    );
  }
}
