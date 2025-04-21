class SendChatEntity {
  DateTime? expire;
  String? sessionId;
  String? tid;
  String? token;

  SendChatEntity({
    this.expire,
    this.sessionId,
    this.tid,
    this.token,
  });

  factory SendChatEntity.fromJson(Map<String, dynamic> json) => SendChatEntity(
        expire: DateTime.parse(json["expire"]),
        sessionId: json["session_id"],
        tid: json["tid"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "expire": expire?.toIso8601String(),
        "session_id": sessionId,
        "tid": tid,
        "token": token,
      };
}
