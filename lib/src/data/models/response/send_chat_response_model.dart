import 'package:konnek_native_core/src/domain/entities/send_chat_entity.dart';

class SendChatResponseModel {
  MetaSendChat? meta;
  DataSendChat? data;

  SendChatResponseModel({
    this.meta,
    this.data,
  });

  factory SendChatResponseModel.fromJson(Map<String, dynamic> json) => SendChatResponseModel(
        meta: json["meta"] == null ? null : MetaSendChat.fromJson(json["meta"]),
        data: json["data"] == null ? null : DataSendChat.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
      };

  SendChatEntity toEntity() {
    return SendChatEntity(
      expire: data?.expire,
      sessionId: data?.sessionId,
      tid: data?.tid,
      token: data?.token,
    );
  }
}

class DataSendChat {
  DateTime? expire;
  String? sessionId;
  String? tid;
  String? token;

  DataSendChat({
    this.expire,
    this.sessionId,
    this.tid,
    this.token,
  });

  factory DataSendChat.fromJson(Map<String, dynamic> json) => DataSendChat(
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

class MetaSendChat {
  bool? status;
  int? code;
  String? message;
  String? logId;
  dynamic errors;

  MetaSendChat({
    this.status,
    this.code,
    this.message,
    this.logId,
    this.errors,
  });

  factory MetaSendChat.fromJson(Map<String, dynamic> json) => MetaSendChat(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        logId: json["log_id"],
        errors: json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "log_id": logId,
        "errors": errors,
      };
}
