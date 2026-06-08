import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class FirestoreService {
  final CollectionReference _notesRef =
      FirebaseFirestore.instance.collection('notes');
// Users ka profile save karna
Future<void> saveUserProfile(String uid, String name, String email) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'name': name,
    'email': email,
    'createdAt': Timestamp.now(),
  });
}
  // CREATE
  Future<void> addNote({
    required String title,
    required String content,
    required String category,
    required int colorIndex,
  }) async {
    await _notesRef.add({
      'title': title,
      'content': content,
      'category': category,
      'colorIndex': colorIndex,
      'createdAt': Timestamp.now(),
    });
  }

  // READ — real-time stream
  Stream<List<NoteModel>> getNotes() {
    return _notesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                NoteModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // UPDATE
// Purana updateNote replace karo is se:

Future<void> updateNote(
  String id,
  String title,
  String content,
  String category,
  int colorIndex,
) async {
  await _notesRef.doc(id).update({
    'title': title,
    'content': content,
    'category': category,
    'colorIndex': colorIndex, // ← yeh missing tha
  });
}

  // DELETE
  Future<void> deleteNote(String id) async {
    await _notesRef.doc(id).delete();
  }

  // SEARCH by title
  Stream<List<NoteModel>> searchNotes(String query) {
    return getNotes().map((notes) => notes
        .where((n) =>
            n.title.toLowerCase().contains(query.toLowerCase()) ||
            n.category.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }
}