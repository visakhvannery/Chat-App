import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final Future<void> Function(String) onSend;
  const MessageInput({required this.onSend, super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _sending = false;

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    await widget.onSend(text);
    _controller.clear();
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.transparent,
        child: Row(children: [
          Expanded(
            child: TextField(controller: _controller, decoration: InputDecoration(hintText: 'Type a message', filled: true, fillColor: const Color(0xFF0F2133), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          ),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: _sending ? null : _send, child: const Icon(Icons.send)),
        ]),
      ),
    );
  }
}
