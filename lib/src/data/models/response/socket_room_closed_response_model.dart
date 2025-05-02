class SocketRoomClosedResponseModel {
  String? id;
  List<String>? to;
  String? event;
  DateTime? date;
  int? ttl;
  DataSocketRoomClosed? data;
  int? priorityTypes;
  dynamic retry;

  SocketRoomClosedResponseModel({
    this.id,
    this.to,
    this.event,
    this.date,
    this.ttl,
    this.data,
    this.priorityTypes,
    this.retry,
  });

  factory SocketRoomClosedResponseModel.fromJson(Map<String, dynamic> json) => SocketRoomClosedResponseModel(
        id: json["id"],
        to: json["to"] == null ? [] : List<String>.from(json["to"]!.map((x) => x)),
        event: json["event"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        ttl: json["ttl"],
        data: json["data"] == null ? null : DataSocketRoomClosed.fromJson(json["data"]),
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

class DataSocketRoomClosed {
  String? providerMessageId;
  String? messageId;
  String? replyId;
  String? companyId;
  String? channelCode;
  String? replyToken;
  PrevSessionSocketRoomClosed? prevSession;
  CompanySocketRoomClosed? company;
  SessionSocketRoomClosed? session;
  MessageSocketRoomClosed? message;
  AgentSocketRoomClosed? from;
  AgentSocketRoomClosed? customer;
  AgentSocketRoomClosed? agent;
  dynamic csat;
  dynamic lastCustomerMessageTime;
  bool? sendOutboundFlag;
  String? windowMessaging;
  int? republish;
  dynamic error;

  DataSocketRoomClosed({
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
    this.lastCustomerMessageTime,
    this.sendOutboundFlag,
    this.windowMessaging,
    this.republish,
    this.error,
  });

  factory DataSocketRoomClosed.fromJson(Map<String, dynamic> json) => DataSocketRoomClosed(
        providerMessageId: json["provider_message_id"],
        messageId: json["message_id"],
        replyId: json["reply_id"],
        companyId: json["company_id"],
        channelCode: json["channel_code"],
        replyToken: json["reply_token"],
        prevSession: json["prev_session"] == null ? null : PrevSessionSocketRoomClosed.fromJson(json["prev_session"]),
        company: json["company"] == null ? null : CompanySocketRoomClosed.fromJson(json["company"]),
        session: json["session"] == null ? null : SessionSocketRoomClosed.fromJson(json["session"]),
        message: json["message"] == null ? null : MessageSocketRoomClosed.fromJson(json["message"]),
        from: json["from"] == null ? null : AgentSocketRoomClosed.fromJson(json["from"]),
        customer: json["customer"] == null ? null : AgentSocketRoomClosed.fromJson(json["customer"]),
        agent: json["agent"] == null ? null : AgentSocketRoomClosed.fromJson(json["agent"]),
        csat: json["csat"],
        lastCustomerMessageTime: json["last_customer_message_time"],
        sendOutboundFlag: json["send_outbound_flag"],
        windowMessaging: json["window_messaging"],
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
        "last_customer_message_time": lastCustomerMessageTime,
        "send_outbound_flag": sendOutboundFlag,
        "window_messaging": windowMessaging,
        "republish": republish,
        "error": error,
      };
}

class AgentSocketRoomClosed {
  String? userId;
  String? username;
  String? name;
  String? avatar;
  String? description;
  String? priorityLevelId;
  String? priorityLevelName;
  String? contactId;

  AgentSocketRoomClosed({
    this.userId,
    this.username,
    this.name,
    this.avatar,
    this.description,
    this.priorityLevelId,
    this.priorityLevelName,
    this.contactId,
  });

  factory AgentSocketRoomClosed.fromJson(Map<String, dynamic> json) => AgentSocketRoomClosed(
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

class CompanySocketRoomClosed {
  String? name;
  bool? status;
  String? code;

  CompanySocketRoomClosed({
    this.name,
    this.status,
    this.code,
  });

  factory CompanySocketRoomClosed.fromJson(Map<String, dynamic> json) => CompanySocketRoomClosed(
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

class MessageSocketRoomClosed {
  String? id;
  String? fromType;
  DateTime? time;
  int? unixMsgTime;
  DateTime? receivedAt;
  dynamic processedAt;
  String? type;
  String? text;
  String? payload;
  MediaSocketRoomClosed? media;
  LocationSocketRoomClosed? location;
  PostbackSocketRoomClosed? postback;
  dynamic interactive;
  dynamic header;
  dynamic footer;
  int? retrySending;
  dynamic retryTime;
  String? templateId;
  dynamic template;

  MessageSocketRoomClosed({
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

  factory MessageSocketRoomClosed.fromJson(Map<String, dynamic> json) => MessageSocketRoomClosed(
        id: json["id"],
        fromType: json["from_type"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        unixMsgTime: json["unix_msg_time"],
        receivedAt: json["received_at"] == null ? null : DateTime.parse(json["received_at"]),
        processedAt: json["processed_at"],
        type: json["type"],
        text: json["text"],
        payload: json["payload"],
        media: json["media"] == null ? null : MediaSocketRoomClosed.fromJson(json["media"]),
        location: json["location"] == null ? null : LocationSocketRoomClosed.fromJson(json["location"]),
        postback: json["postback"] == null ? null : PostbackSocketRoomClosed.fromJson(json["postback"]),
        interactive: json["interactive"],
        header: json["header"],
        footer: json["footer"],
        retrySending: json["retry_sending"],
        retryTime: json["retry_time"],
        templateId: json["template_id"],
        template: json["template"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_type": fromType,
        "time": time?.toIso8601String(),
        "unix_msg_time": unixMsgTime,
        "received_at": receivedAt?.toIso8601String(),
        "processed_at": processedAt,
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
        "retry_time": retryTime,
        "template_id": templateId,
        "template": template,
      };
}

class LocationSocketRoomClosed {
  int? latitude;
  int? longitude;
  String? address;
  String? name;
  int? livePeriod;

  LocationSocketRoomClosed({
    this.latitude,
    this.longitude,
    this.address,
    this.name,
    this.livePeriod,
  });

  factory LocationSocketRoomClosed.fromJson(Map<String, dynamic> json) => LocationSocketRoomClosed(
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

class MediaSocketRoomClosed {
  String? id;
  String? url;
  String? name;
  int? size;

  MediaSocketRoomClosed({
    this.id,
    this.url,
    this.name,
    this.size,
  });

  factory MediaSocketRoomClosed.fromJson(Map<String, dynamic> json) => MediaSocketRoomClosed(
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

class PostbackSocketRoomClosed {
  String? type;
  String? title;
  String? key;
  String? value;

  PostbackSocketRoomClosed({
    this.type,
    this.title,
    this.key,
    this.value,
  });

  factory PostbackSocketRoomClosed.fromJson(Map<String, dynamic> json) => PostbackSocketRoomClosed(
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

class PrevSessionSocketRoomClosed {
  String? id;
  dynamic openTime;
  int? unixOpenTime;

  PrevSessionSocketRoomClosed({
    this.id,
    this.openTime,
    this.unixOpenTime,
  });

  factory PrevSessionSocketRoomClosed.fromJson(Map<String, dynamic> json) => PrevSessionSocketRoomClosed(
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

class SessionSocketRoomClosed {
  String? id;
  String? roomId;
  String? divisionId;
  bool? botStatus;
  int? status;
  String? categories;
  String? openBy;
  String? handoverBy;
  String? closeBy;
  dynamic openTime;
  int? unixOpenTime;
  dynamic queueTime;
  int? unixQueTime;
  dynamic assignTime;
  int? unixAssignTime;
  dynamic firstResponseTime;
  dynamic lastAgentChatTime;
  dynamic lastCustomerMessageTime;
  DateTime? closeTime;
  String? sessionPriorityLevelId;
  String? slaFrom;
  String? slaTo;
  int? slaThreshold;
  int? slaDurations;
  String? slaStatus;
  bool? isNew;

  SessionSocketRoomClosed({
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

  factory SessionSocketRoomClosed.fromJson(Map<String, dynamic> json) => SessionSocketRoomClosed(
        id: json["id"],
        roomId: json["room_id"],
        divisionId: json["division_id"],
        botStatus: json["bot_status"],
        status: json["status"],
        categories: json["categories"],
        openBy: json["open_by"],
        handoverBy: json["handover_by"],
        closeBy: json["close_by"],
        openTime: json["open_time"],
        unixOpenTime: json["unix_open_time"],
        queueTime: json["queue_time"],
        unixQueTime: json["unix_que_time"],
        assignTime: json["assign_time"],
        unixAssignTime: json["unix_assign_time"],
        firstResponseTime: json["first_response_time"],
        lastAgentChatTime: json["last_agent_chat_time"],
        lastCustomerMessageTime: json["last_customer_message_time"],
        closeTime: json["close_time"] == null ? null : DateTime.parse(json["close_time"]),
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
        "open_time": openTime,
        "unix_open_time": unixOpenTime,
        "queue_time": queueTime,
        "unix_que_time": unixQueTime,
        "assign_time": assignTime,
        "unix_assign_time": unixAssignTime,
        "first_response_time": firstResponseTime,
        "last_agent_chat_time": lastAgentChatTime,
        "last_customer_message_time": lastCustomerMessageTime,
        "close_time": closeTime?.toIso8601String(),
        "session_priority_level_id": sessionPriorityLevelId,
        "sla_from": slaFrom,
        "sla_to": slaTo,
        "sla_threshold": slaThreshold,
        "sla_durations": slaDurations,
        "sla_status": slaStatus,
        "is_new": isNew,
      };
}
