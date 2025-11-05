import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<Message> messages = [];

  void bindChat(String chatId) {
    messages.clear();
    final q = _chatService.messagesQuery(chatId);
    q.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final msg = Message.fromJson(data);
      messages.add(msg);
      notifyListeners();
    });
  }

  Future<void> send(String chatId, String fromId, String toId, String text) async {
    await _chatService.sendMessage(chatId: chatId, fromId: fromId, toId: toId, text: text);
  }
}
