import 'package:konnek_native_core/src/presentation/controller/chat_controller.dart';

class GetConversationResponseModel {
  MetaGetConversation? meta;
  DataGetConversation? data;

  GetConversationResponseModel({
    this.meta,
    this.data,
  });

  factory GetConversationResponseModel.fromJson(Map<String, dynamic> json) => GetConversationResponseModel(
        meta: json["meta"] == null ? null : MetaGetConversation.fromJson(json["meta"]),
        data: json["data"] == null ? null : DataGetConversation.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
      };
}

class DataGetConversation {
  List<ConversationList>? conversations;
  DateTime? expire;
  RoomGetConversation? room;
  String? token;

  DataGetConversation({
    this.conversations,
    this.expire,
    this.room,
    this.token,
  });

  factory DataGetConversation.fromJson(Map<String, dynamic> json) => DataGetConversation(
        conversations: json["conversations"] == null ? [] : List<ConversationList>.from(json["conversations"].map((x) => ConversationList.fromJson(x))),
        expire: json["expire"] == null ? null : DateTime.parse(json["expire"]),
        room: json["room"] == null ? null : RoomGetConversation.fromJson(json["room"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "conversations": List<dynamic>.from(conversations!.map((x) => x.toJson())),
        "expire": expire?.toIso8601String(),
        "room": room?.toJson(),
        "token": token,
      };
}

class ConversationList extends ChatItem {
  int? seqId;
  String? roomId;
  String? sessionId;
  String? id;
  String? userId;
  String? messageId;
  String? replyId;
  String? fromType;
  String? type;
  String? text;
  String? payload;
  int? status;
  DateTime? messageTime;
  DateTime? createdAt;
  String? createdBy;
  SessionGetConversation? session;
  UserGetConversation? user;
  int? unixMsgTime;

  ConversationList({
    this.seqId,
    this.roomId,
    this.sessionId,
    this.id,
    this.userId,
    this.messageId,
    this.replyId,
    this.fromType,
    this.type,
    this.text,
    this.payload,
    this.status,
    this.messageTime,
    this.createdAt,
    this.createdBy,
    this.session,
    this.user,
    this.unixMsgTime,
  });

  factory ConversationList.fromJson(Map<String, dynamic> json) => ConversationList(
        seqId: json["seq_id"],
        roomId: json["room_id"],
        sessionId: json["session_id"],
        id: json["id"],
        userId: json["user_id"],
        messageId: json["message_id"],
        replyId: json["reply_id"],
        fromType: json["from_type"],
        type: json["type"],
        text: json["text"],
        payload: json["payload"],
        status: json["status"],
        messageTime: json["message_time"] == null ? null : DateTime.parse(json["message_time"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        session: json["session"] == null ? null : SessionGetConversation.fromJson(json["session"]),
        user: json["user"] == null ? null : UserGetConversation.fromJson(json["user"]),
        unixMsgTime: json["unix_msg_time"],
      );

  Map<String, dynamic> toJson() => {
        "seq_id": seqId,
        "room_id": roomId,
        "session_id": sessionId,
        "id": id,
        "user_id": userId,
        "message_id": messageId,
        "reply_id": replyId,
        "from_type": fromType,
        "type": type,
        "text": text,
        "payload": payload,
        "status": status,
        "message_time": messageTime?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "session": session?.toJson(),
        "user": user?.toJson(),
        "unix_msg_time": unixMsgTime,
      };
}

class SessionGetConversation {
  String? id;
  String? roomId;
  String? divisionId;
  String? agentUserId;
  UserGetConversation? agent;
  String? categories;
  bool? botStatus;
  int? status;
  String? openBy;
  String? handoverBy;
  String? closeBy;
  UserGetConversation? closeUser;
  DateTime? openTime;
  DateTime? queueTime;
  DateTime? assignTime;
  dynamic firstResponseTime;
  dynamic lastAgentChatTime;
  DateTime? closeTime;
  String? sessionPriorityLevelId;

  SessionGetConversation({
    this.id,
    this.roomId,
    this.divisionId,
    this.agentUserId,
    this.agent,
    this.categories,
    this.botStatus,
    this.status,
    this.openBy,
    this.handoverBy,
    this.closeBy,
    this.closeUser,
    this.openTime,
    this.queueTime,
    this.assignTime,
    this.firstResponseTime,
    this.lastAgentChatTime,
    this.closeTime,
    this.sessionPriorityLevelId,
  });

  factory SessionGetConversation.fromJson(Map<String, dynamic> json) => SessionGetConversation(
        id: json["id"],
        roomId: json["room_id"],
        divisionId: json["division_id"],
        agentUserId: json["agent_user_id"],
        agent: json["agent"] == null ? null : UserGetConversation.fromJson(json["agent"]),
        categories: json["categories"],
        botStatus: json["bot_status"],
        status: json["status"],
        openBy: json["open_by"],
        handoverBy: json["handover_by"],
        closeBy: json["close_by"],
        closeUser: json["close_user"] == null ? null : UserGetConversation.fromJson(json["close_user"]),
        openTime: json["open_time"] == null ? null : DateTime.parse(json["open_time"]),
        queueTime: json["queue_time"] == null ? null : DateTime.parse(json["queue_time"]),
        assignTime: json["assign_time"] == null ? null : DateTime.parse(json["assign_time"]),
        firstResponseTime: json["first_response_time"],
        lastAgentChatTime: json["last_agent_chat_time"],
        closeTime: json["close_time"] == null ? null : DateTime.parse(json["close_time"]),
        sessionPriorityLevelId: json["session_priority_level_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "division_id": divisionId,
        "agent_user_id": agentUserId,
        "agent": agent?.toJson(),
        "categories": categories,
        "bot_status": botStatus,
        "status": status,
        "open_by": openBy,
        "handover_by": handoverBy,
        "close_by": closeBy,
        "close_user": closeUser?.toJson(),
        "open_time": openTime?.toIso8601String(),
        "queue_time": queueTime?.toIso8601String(),
        "assign_time": assignTime?.toIso8601String(),
        "first_response_time": firstResponseTime,
        "last_agent_chat_time": lastAgentChatTime,
        "close_time": closeTime?.toIso8601String(),
        "session_priority_level_id": sessionPriorityLevelId,
      };
}

class UserGetConversation {
  String? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? avatar;
  String? description;
  String? tags;
  String? customerChannel;
  int? status;
  int? onlineStatus;
  String? divisionId;
  bool? isBlocked;

  UserGetConversation({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.avatar,
    this.description,
    this.tags,
    this.customerChannel,
    this.status,
    this.onlineStatus,
    this.divisionId,
    this.isBlocked,
  });

  factory UserGetConversation.fromJson(Map<String, dynamic> json) => UserGetConversation(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
        description: json["description"],
        tags: json["tags"],
        customerChannel: json["customer_channel"],
        status: json["status"],
        onlineStatus: json["online_status"],
        divisionId: json["division_id"],
        isBlocked: json["is_blocked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "avatar": avatar,
        "description": description,
        "tags": tags,
        "customer_channel": customerChannel,
        "status": status,
        "online_status": onlineStatus,
        "division_id": divisionId,
        "is_blocked": isBlocked,
      };
}

class RoomGetConversation {
  String? agentUserId;
  dynamic assignTime;
  bool? botStatus;
  String? categories;
  String? channelCode;
  String? closeBy;
  dynamic closeTime;
  String? companyId;
  String? customerAvatar;
  String? customerDescription;
  String? customerEmail;
  String? customerId;
  String? customerName;
  String? customerUsername;
  String? divisionId;
  dynamic firstResponseTime;
  String? handoverBy;
  String? id;
  dynamic lastAgentChatTime;
  DateTime? lastCustomerMessageTime;
  String? openBy;
  DateTime? openTime;
  DateTime? queueTime;
  bool? sendOutboundFlag;
  String? sessionId;
  int? status;
  String? windowMessaging;

  RoomGetConversation({
    this.agentUserId,
    this.assignTime,
    this.botStatus,
    this.categories,
    this.channelCode,
    this.closeBy,
    this.closeTime,
    this.companyId,
    this.customerAvatar,
    this.customerDescription,
    this.customerEmail,
    this.customerId,
    this.customerName,
    this.customerUsername,
    this.divisionId,
    this.firstResponseTime,
    this.handoverBy,
    this.id,
    this.lastAgentChatTime,
    this.lastCustomerMessageTime,
    this.openBy,
    this.openTime,
    this.queueTime,
    this.sendOutboundFlag,
    this.sessionId,
    this.status,
    this.windowMessaging,
  });

  factory RoomGetConversation.fromJson(Map<String, dynamic> json) => RoomGetConversation(
        agentUserId: json["agent_user_id"],
        assignTime: json["assign_time"],
        botStatus: json["bot_status"],
        categories: json["categories"],
        channelCode: json["channel_code"],
        closeBy: json["close_by"],
        closeTime: json["close_time"],
        companyId: json["company_id"],
        customerAvatar: json["customer_avatar"],
        customerDescription: json["customer_description"],
        customerEmail: json["customer_email"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerUsername: json["customer_username"],
        divisionId: json["division_id"],
        firstResponseTime: json["first_response_time"],
        handoverBy: json["handover_by"],
        id: json["id"],
        lastAgentChatTime: json["last_agent_chat_time"],
        lastCustomerMessageTime: json["last_customer_message_time"] == null ? null : DateTime.parse(json["last_customer_message_time"]),
        openBy: json["open_by"],
        openTime: json["open_time"] == null ? null : DateTime.parse(json["open_time"]),
        queueTime: json["queue_time"] == null ? null : DateTime.parse(json["queue_time"]),
        sendOutboundFlag: json["send_outbound_flag"],
        sessionId: json["session_id"],
        status: json["status"],
        windowMessaging: json["window_messaging"],
      );

  Map<String, dynamic> toJson() => {
        "agent_user_id": agentUserId,
        "assign_time": assignTime,
        "bot_status": botStatus,
        "categories": categories,
        "channel_code": channelCode,
        "close_by": closeBy,
        "close_time": closeTime,
        "company_id": companyId,
        "customer_avatar": customerAvatar,
        "customer_description": customerDescription,
        "customer_email": customerEmail,
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_username": customerUsername,
        "division_id": divisionId,
        "first_response_time": firstResponseTime,
        "handover_by": handoverBy,
        "id": id,
        "last_agent_chat_time": lastAgentChatTime,
        "last_customer_message_time": lastCustomerMessageTime?.toIso8601String(),
        "open_by": openBy,
        "open_time": openTime?.toIso8601String(),
        "queue_time": queueTime?.toIso8601String(),
        "send_outbound_flag": sendOutboundFlag,
        "session_id": sessionId,
        "status": status,
        "window_messaging": windowMessaging,
      };
}

class MetaGetConversation {
  bool? status;
  int? code;
  String? message;
  String? logId;
  dynamic errors;
  int? currentPage;
  bool? nextPage;
  bool? prevPage;
  int? perPage;
  int? pageCount;
  int? totalCount;

  MetaGetConversation({
    this.status,
    this.code,
    this.message,
    this.logId,
    this.errors,
    this.currentPage,
    this.nextPage,
    this.prevPage,
    this.perPage,
    this.pageCount,
    this.totalCount,
  });

  factory MetaGetConversation.fromJson(Map<String, dynamic> json) => MetaGetConversation(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        logId: json["log_id"],
        errors: json["errors"],
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        perPage: json["per_page"],
        pageCount: json["page_count"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "log_id": logId,
        "errors": errors,
        "current_page": currentPage,
        "next_page": nextPage,
        "prev_page": prevPage,
        "per_page": perPage,
        "page_count": pageCount,
        "total_count": totalCount,
      };
}
