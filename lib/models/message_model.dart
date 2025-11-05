class Message {
  final String id;
  final String text;
  final String fromId;
  final String toId;
  final int timestamp;
  final String? attachmentUrl;

  Message({
    required this.id,
    required this.text,
    required this.fromId,
    required this.toId,
    required this.timestamp,
    this.attachmentUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'fromId': fromId,
        'toId': toId,
        'timestamp': timestamp,
        'attachmentUrl': attachmentUrl,
      };

  factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
        id: json['id'] as String,
        text: json['text'] as String,
        fromId: json['fromId'] as String,
        toId: json['toId'] as String,
        timestamp: json['timestamp'] as int,
        attachmentUrl: json['attachmentUrl'] as String?,
      );
}
