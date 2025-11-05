import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  Stream<List<Map<String, dynamic>>> getAllUsers() {
    final currentUser = _auth.currentUser!;
    final ref = _db.child('users');

    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .where((entry) => entry.key != currentUser.uid)
          .map((entry) => {
        'uid': entry.key,
        'name': entry.value['name'],
        'photoUrl': entry.value['photoUrl'],
      })
          .toList();
    });
  }

  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '${uid1}_$uid2' : '${uid2}_$uid1';
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    final ref = _db.child('chats/$chatId/messages');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final messages = data.entries.map((e) {
        final m = e.value as Map;
        return {
          'senderId': m['senderId'],
          'text': m['text'],
          'timestamp': m['timestamp'],
        };
      }).toList();
      messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
      return messages;
    });
  }

  Future<void> sendMessage(String peerId, String text) async {
    final user = _auth.currentUser!;
    final chatId = getChatId(user.uid, peerId);
    final ref = _db.child('chats/$chatId/messages').push();

    await ref.set({
      'senderId': user.uid,
      'text': text,
      'timestamp': ServerValue.timestamp,
    });
  }
}
