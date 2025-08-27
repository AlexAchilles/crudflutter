import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  // Create
  Future<void> addNote(String note) async {
    try {
      await notes.add({'note': note, 'timestamp': Timestamp.now()});
      print('Nota adicionada com sucesso!');
    } catch (e) {
      print('Erro ao adicionar nota: $e');
    }
  }

  // Read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes
        .orderBy('timestamp', descending: true)
        .snapshots();

    return notesStream;
  }

  // Update
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }
}
