import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';

class ChatService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final _uuid = const Uuid();

  String chatPath(String chatId) => 'messages/$chatId';

  Future<void> sendMessage({required String chatId, required String fromId, required String toId, required String text}) async {
    final id = _uuid.v4();
    final msg = Message(id: id, text: text, fromId: fromId, toId: toId, timestamp: DateTime.now().millisecondsSinceEpoch);
    await _db.child(chatPath(chatId)).child(id).set(msg.toJson());
  }

  Query messagesQuery(String chatId) => _db.child(chatPath(chatId)).orderByChild('timestamp');
}
