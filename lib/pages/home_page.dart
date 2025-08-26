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




  void openNoteBox(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
      ),
        actions: [
          ElevatedButton(onPressed: () {
            firestoreService.addNote(textController.text);


            textController.clear();

            Navigator.pop(context);
          },
           child: Text("Add")
          )
        ],

    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD em Flutter")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}