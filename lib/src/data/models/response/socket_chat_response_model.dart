class SocketChatResponseModel {
  String? providerMessageId;
  String? messageId;
  String? replyId;
  String? companyId;
  String? channelCode;
  String? replyToken;
  PrevSessionSocketChat? prevSession;
  CompanySocketChat? company;
  SessionSocketChat? session;
  MessageSocketChat? message;
  AgentSocketChat? from;
  AgentSocketChat? customer;
  AgentSocketChat? agent;
  dynamic csat;
  int? republish;
  dynamic error;

  SocketChatResponseModel({
    this.providerMessageId,
    this.messageId,
    this.replyId,
    this.companyId,
    this.channelCode,
    this.replyToken,
    this.prevSession,
    this.company,
    this.session,
    this.message,
    this.from,
    this.customer,
    this.agent,
    this.csat,
    this.republish,
    this.error,
  });

  factory SocketChatResponseModel.fromJson(Map<String, dynamic> json) => SocketChatResponseModel(
        providerMessageId: json["provider_message_id"],
        messageId: json["message_id"],
        replyId: json["reply_id"],
        companyId: json["company_id"],
        channelCode: json["channel_code"],
        replyToken: json["reply_token"],
        prevSession: json["prev_session"] == null ? null : PrevSessionSocketChat.fromJson(json["prev_session"]),
        company: json["company"] == null ? null : CompanySocketChat.fromJson(json["company"]),
        session: json["session"] == null ? null : SessionSocketChat.fromJson(json["session"]),
        message: json["message"] == null ? null : MessageSocketChat.fromJson(json["message"]),
        from: json["from"] == null ? null : AgentSocketChat.fromJson(json["from"]),
        customer: json["customer"] == null ? null : AgentSocketChat.fromJson(json["customer"]),
        agent: json["agent"] == null ? null : AgentSocketChat.fromJson(json["agent"]),
        csat: json["csat"],
        republish: json["republish"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "provider_message_id": providerMessageId,
        "message_id": messageId,
        "reply_id": replyId,
        "company_id": companyId,
        "channel_code": channelCode,
        "reply_token": replyToken,
        "prev_session": prevSession?.toJson(),
        "company": company?.toJson(),
        "session": session?.toJson(),
        "message": message?.toJson(),
        "from": from?.toJson(),
        "customer": customer?.toJson(),
        "agent": agent?.toJson(),
        "csat": csat,
        "republish": republish,
        "error": error,
      };
}

class AgentSocketChat {
  String? userId;
  String? username;
  String? name;
  String? avatar;
  String? description;
  String? priorityLevelId;
  String? priorityLevelName;
  String? contactId;

  AgentSocketChat({
    this.userId,
    this.username,
    this.name,
    this.avatar,
    this.description,
    this.priorityLevelId,
    this.priorityLevelName,
    this.contactId,
  });

  factory AgentSocketChat.fromJson(Map<String, dynamic> json) => AgentSocketChat(
        userId: json["user_id"],
        username: json["username"],
        name: json["name"],
        avatar: json["avatar"],
        description: json["description"],
        priorityLevelId: json["priority_level_id"],
        priorityLevelName: json["priority_level_name"],
        contactId: json["contact_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "name": name,
        "avatar": avatar,
        "description": description,
        "priority_level_id": priorityLevelId,
        "priority_level_name": priorityLevelName,
        "contact_id": contactId,
      };
}

class CompanySocketChat {
  String? name;
  bool? status;
  String? code;

  CompanySocketChat({
    this.name,
    this.status,
    this.code,
  });

  factory CompanySocketChat.fromJson(Map<String, dynamic> json) => CompanySocketChat(
        name: json["name"],
        status: json["status"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "status": status,
        "code": code,
      };
}

class MessageSocketChat {
  String? id;
  String? fromType;
  DateTime? time;
  int? unixMsgTime;
  DateTime? receivedAt;
  DateTime? processedAt;
  String? type;
  String? text;
  String? payload;
  MediaSocketChat? media;
  LocationSocketChat? location;
  PostbackSocketChat? postback;
  dynamic interactive;
  dynamic header;
  dynamic footer;
  int? retrySending;
  DateTime? retryTime;
  String? templateId;
  dynamic template;

  MessageSocketChat({
    this.id,
    this.fromType,
    this.time,
    this.unixMsgTime,
    this.receivedAt,
    this.processedAt,
    this.type,
    this.text,
    this.payload,
    this.media,
    this.location,
    this.postback,
    this.interactive,
    this.header,
    this.footer,
    this.retrySending,
    this.retryTime,
    this.templateId,
    this.template,
  });

  factory MessageSocketChat.fromJson(Map<String, dynamic> json) => MessageSocketChat(
        id: json["id"],
        fromType: json["from_type"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        unixMsgTime: json["unix_msg_time"],
        receivedAt: json["received_at"] == null ? null : DateTime.parse(json["received_at"]),
        processedAt: json["processed_at"] == null ? null : DateTime.parse(json["processed_at"]),
        type: json["type"],
        text: json["text"],
        payload: json["payload"],
        media: json["media"] == null ? null : MediaSocketChat.fromJson(json["media"]),
        location: json["location"] == null ? null : LocationSocketChat.fromJson(json["location"]),
        postback: json["postback"] == null ? null : PostbackSocketChat.fromJson(json["postback"]),
        interactive: json["interactive"],
        header: json["header"],
        footer: json["footer"],
        retrySending: json["retry_sending"],
        retryTime: json["retry_time"] == null ? null : DateTime.parse(json["retry_time"]),
        templateId: json["template_id"],
        template: json["template"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_type": fromType,
        "time": time?.toIso8601String(),
        "unix_msg_time": unixMsgTime,
        "received_at": receivedAt?.toIso8601String(),
        "processed_at": processedAt?.toIso8601String(),
        "type": type,
        "text": text,
        "payload": payload,
        "media": media?.toJson(),
        "location": location?.toJson(),
        "postback": postback?.toJson(),
        "interactive": interactive,
        "header": header,
        "footer": footer,
        "retry_sending": retrySending,
        "retry_time": retryTime?.toIso8601String(),
        "template_id": templateId,
        "template": template,
      };
}

class LocationSocketChat {
  int? latitude;
  int? longitude;
  String? address;
  String? name;
  int? livePeriod;

  LocationSocketChat({
    this.latitude,
    this.longitude,
    this.address,
    this.name,
    this.livePeriod,
  });

  factory LocationSocketChat.fromJson(Map<String, dynamic> json) => LocationSocketChat(
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        name: json["name"],
        livePeriod: json["live_period"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "name": name,
        "live_period": livePeriod,
      };
}

class MediaSocketChat {
  String? id;
  String? url;
  String? name;
  int? size;

  MediaSocketChat({
    this.id,
    this.url,
    this.name,
    this.size,
  });

  factory MediaSocketChat.fromJson(Map<String, dynamic> json) => MediaSocketChat(
        id: json["id"],
        url: json["url"],
        name: json["name"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "name": name,
        "size": size,
      };
}

class PostbackSocketChat {
  String? type;
  String? title;
  String? key;
  String? value;

  PostbackSocketChat({
    this.type,
    this.title,
    this.key,
    this.value,
  });

  factory PostbackSocketChat.fromJson(Map<String, dynamic> json) => PostbackSocketChat(
        type: json["type"],
        title: json["title"],
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "key": key,
        "value": value,
      };
}

class PrevSessionSocketChat {
  String? id;
  dynamic openTime;
  int? unixOpenTime;

  PrevSessionSocketChat({
    this.id,
    this.openTime,
    this.unixOpenTime,
  });

  factory PrevSessionSocketChat.fromJson(Map<String, dynamic> json) => PrevSessionSocketChat(
        id: json["id"],
        openTime: json["open_time"],
        unixOpenTime: json["unix_open_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "open_time": openTime,
        "unix_open_time": unixOpenTime,
      };
}

class SessionSocketChat {
  String? id;
  String? roomId;
  String? divisionId;
  bool? botStatus;
  int? status;
  String? categories;
  String? openBy;
  String? handoverBy;
  String? closeBy;
  DateTime? openTime;
  int? unixOpenTime;
  DateTime? queueTime;
  int? unixQueTime;
  dynamic assignTime;
  int? unixAssignTime;
  dynamic firstResponseTime;
  dynamic lastAgentChatTime;
  dynamic lastCustomerMessageTime;
  dynamic closeTime;
  String? sessionPriorityLevelId;
  String? slaFrom;
  String? slaTo;
  int? slaThreshold;
  int? slaDurations;
  String? slaStatus;
  bool? isNew;

  SessionSocketChat({
    this.id,
    this.roomId,
    this.divisionId,
    this.botStatus,
    this.status,
    this.categories,
    this.openBy,
    this.handoverBy,
    this.closeBy,
    this.openTime,
    this.unixOpenTime,
    this.queueTime,
    this.unixQueTime,
    this.assignTime,
    this.unixAssignTime,
    this.firstResponseTime,
    this.lastAgentChatTime,
    this.lastCustomerMessageTime,
    this.closeTime,
    this.sessionPriorityLevelId,
    this.slaFrom,
    this.slaTo,
    this.slaThreshold,
    this.slaDurations,
    this.slaStatus,
    this.isNew,
  });

  factory SessionSocketChat.fromJson(Map<String, dynamic> json) => SessionSocketChat(
        id: json["id"],
        roomId: json["room_id"],
        divisionId: json["division_id"],
        botStatus: json["bot_status"],
        status: json["status"],
        categories: json["categories"],
        openBy: json["open_by"],
        handoverBy: json["handover_by"],
        closeBy: json["close_by"],
        openTime: json["open_time"] == null ? null : DateTime.parse(json["open_time"]),
        unixOpenTime: json["unix_open_time"],
        queueTime: json["queue_time"] == null ? null : DateTime.parse(json["queue_time"]),
        unixQueTime: json["unix_que_time"],
        assignTime: json["assign_time"],
        unixAssignTime: json["unix_assign_time"],
        firstResponseTime: json["first_response_time"],
        lastAgentChatTime: json["last_agent_chat_time"],
        lastCustomerMessageTime: json["last_customer_message_time"],
        closeTime: json["close_time"],
        sessionPriorityLevelId: json["session_priority_level_id"],
        slaFrom: json["sla_from"],
        slaTo: json["sla_to"],
        slaThreshold: json["sla_threshold"],
        slaDurations: json["sla_durations"],
        slaStatus: json["sla_status"],
        isNew: json["is_new"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "division_id": divisionId,
        "bot_status": botStatus,
        "status": status,
        "categories": categories,
        "open_by": openBy,
        "handover_by": handoverBy,
        "close_by": closeBy,
        "open_time": openTime?.toIso8601String(),
        "unix_open_time": unixOpenTime,
        "queue_time": queueTime?.toIso8601String(),
        "unix_que_time": unixQueTime,
        "assign_time": assignTime,
        "unix_assign_time": unixAssignTime,
        "first_response_time": firstResponseTime,
        "last_agent_chat_time": lastAgentChatTime,
        "last_customer_message_time": lastCustomerMessageTime,
        "close_time": closeTime,
        "session_priority_level_id": sessionPriorityLevelId,
        "sla_from": slaFrom,
        "sla_to": slaTo,
        "sla_threshold": slaThreshold,
        "sla_durations": slaDurations,
        "sla_status": slaStatus,
        "is_new": isNew,
      };
}
