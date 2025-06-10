class SocketChatStatusResponseModel {
  String? id;
  List<String>? to;
  String? event;
  DateTime? date;
  int? ttl;
  Data? data;
  int? priorityTypes;
  dynamic retry;

  SocketChatStatusResponseModel({
    this.id,
    this.to,
    this.event,
    this.date,
    this.ttl,
    this.data,
    this.priorityTypes,
    this.retry,
  });

  factory SocketChatStatusResponseModel.fromJson(Map<String, dynamic> json) => SocketChatStatusResponseModel(
        id: json["id"],
        to: json["to"] == null ? [] : List<String>.from(json["to"]!.map((x) => x)),
        event: json["event"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        ttl: json["ttl"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        priorityTypes: json["priority_types"],
        retry: json["retry"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "to": to == null ? [] : List<dynamic>.from(to!.map((x) => x)),
        "event": event,
        "date": date?.toIso8601String(),
        "ttl": ttl,
        "data": data?.toJson(),
        "priority_types": priorityTypes,
        "retry": retry,
      };
}

class Data {
  String? messageId;
  String? roomId;
  String? sessionId;
  int? status;
  int? times;
  DateTime? timestampt;

  Data({
    this.messageId,
    this.roomId,
    this.sessionId,
    this.status,
    this.times,
    this.timestampt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        messageId: json["message_id"],
        roomId: json["room_id"],
        sessionId: json["session_id"],
        status: json["status"],
        times: json["times"],
        timestampt: json["timestampt"] == null ? null : DateTime.parse(json["timestampt"]),
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "room_id": roomId,
        "session_id": sessionId,
        "status": status,
        "times": times,
        "timestampt": timestampt?.toIso8601String(),
      };
}
