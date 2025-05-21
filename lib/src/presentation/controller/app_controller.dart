import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:konnek_native_core/inter_module.dart';
import 'package:konnek_native_core/src/data/models/request/send_chat_request_model.dart';
import 'package:konnek_native_core/src/data/models/response/bot_payload_data_model.dart';
import 'package:konnek_native_core/src/data/models/response/carousel_payload_data_model.dart';
import 'package:konnek_native_core/src/data/models/response/csat_payload_data_model.dart';
import 'package:konnek_native_core/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/get_conversation_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/send_chat_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/socket_chat_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/socket_chat_status_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/socket_room_closed_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/socket_room_handover_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/upload_media_response_model.dart';
import 'package:konnek_native_core/src/data/repositories/chat_repository_impl.dart';
import 'package:konnek_native_core/src/data/source/local/chat_local_source.dart';
import 'package:konnek_native_core/src/support/app_socketio_service.dart';
import 'package:konnek_native_core/src/support/jwt_converter.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

enum RoomCloseState {
  close,
  closeWaiting,
  open,
}

enum FetchingState {
  loading,
  failed,
  success,
  empty,
}

class AppController {
  static bool isLoading = false;

  static bool socketReady = false;

  static void clear() {
    nameUser = "";
    usernameUser = "";
    currentPage = 1;
    limit = 20;
    conversationData = null;
    conversationList = [];
    conversationDataFirstChat = null;
    conversationListFirstChat = [];
    InterModule.accessToken = "";
  }

  static void clearRoomClosed() {
    currentPage = 1;
    limit = 20;
    InterModule.accessToken = "";
  }

  Future<void> startWebSocketIO({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      AppLoggerCS.debugLog("[AppController][startWebSocketIO] called");
      io.Socket? data = ChatRepositoryImpl().startWebSocketIO();
      onSuccess?.call();
    } catch (e) {
      AppLoggerCS.debugLog('[startWebSocketIO] e: $e');
      onFailed?.call(e.toString());
    }
  }

  void listenToMessages(String eventName, Function(dynamic) onMessage) {
    AppSocketioService.socket.on(
      // 'new_message',
      eventName,
      (data) {
        onMessage(data); // callback
      },
    );
  }

  void sendMessage(String eventName, Map<String, dynamic> message) {
    AppSocketioService.socket.emit(
      // 'send_message',
      eventName,
      message,
    );
  }

  static void disconnectSocket() async {
    try {
      AppController.socketReady = false;
      await ChatLocalSource().setSocketReady(false);
      AppSocketioService.socket.disconnect();
      AppSocketioService.socket.onDisconnect((_) {
        AppLoggerCS.debugLog("disconnected");
        AppLoggerCS.debugLog("disconnected id: ${AppSocketioService.socket.id}");
      });
    } catch (e) {
      AppController.socketReady = false;
      await ChatLocalSource().setSocketReady(false);
    }
  }

  static Future<void> launchUrlChat(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      AppLoggerCS.debugLog('Could not launch $url');
    }
  }

  static void Function() onSocketChatCalled = () {};
  static void Function() onSocketChatStatusCalled = () {};
  static void Function() onSocketCSATCalled = () {};
  static void Function() onSocketCSATCloseCalled = () {};
  static void Function() onSocketRoomHandoverCalled = () {};
  static void Function() onSocketRoomClosedCalled = () {};
  static void Function() onSocketCustomerIsBlockedCalled = () {};
  static void Function() onSocketDisconnectCalled = () {};

  static bool isCustomerBlocked = false;
  static bool isCSATOpen = false;
  // static bool isRoomClosed = false;
  static RoomCloseState isRoomClosed = RoomCloseState.open;

  Future<void> handleWebSocketIO({
    // void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      // AppSocketioService.socket.onConnect((_) {
      //   AppLoggerCS.debugLog("onConnect: ${AppSocketioService.socket.toString()}");
      // });

      AppSocketioService.socket.on("chat", (output) async {
        AppLoggerCS.debugLog("[socket][chat] output: ${jsonEncode(output)}");
        SocketChatResponseModel socket = SocketChatResponseModel.fromJson(output);

        sessionId = socket.session!.id!;
        roomId = socket.session!.roomId!;

        ConversationList? chatModel;
        chatModel = null;

        chatModel = ConversationList(
          session: SessionGetConversation(
            botStatus: socket.session?.botStatus,
            agent: UserGetConversation(
              id: socket.agent?.userId,
              name: socket.agent?.name,
              username: socket.agent?.username,
            ),
          ),
          fromType: socket.message?.fromType,
          text: socket.message?.text,
          messageId: socket.messageId,
          user: UserGetConversation(
            id: socket.customer?.userId,
            username: socket.customer?.username,
            name: socket.customer?.name,
          ),
          messageTime: socket.message?.time,
          sessionId: socket.session?.id,
          roomId: socket.session?.roomId,
          replyId: socket.replyId,
          payload: socket.message?.payload,
          type: socket.message?.type,
        );
        conversationList.add(chatModel);
        // onSocketChatCalled.call();

        DateTime currentDateTime = DateTime.now();
        AppSocketioService.socket.emit(
          "chat.status",
          {
            "data": {
              "message_id": conversationList.last.messageId,
              "room_id": conversationList.last.roomId,
              "session_id": conversationList.last.sessionId,
              "status": 2,
              "times": (currentDateTime.millisecondsSinceEpoch / 1000).floor(),
              "timestamp": getDateTimeFormatted(value: currentDateTime),
            },
          },
        );

        _getConversation(
          roomId: socket.session!.roomId!,
          onSuccess: () {
            onSocketChatCalled.call();
          },
          onFailed: (errorMessage) {
            onFailed?.call(errorMessage);
          },
        );
        // onSocketChatCalled.call();
      });

      AppSocketioService.socket.on("chat.status", (output) async {
        AppLoggerCS.debugLog("[socket][chat.status] output: ${jsonEncode(output)}");
        SocketChatStatusResponseModel socket = SocketChatStatusResponseModel.fromJson(output);
        sessionId = socket.data!.sessionId!;
        roomId = socket.data!.roomId!;

        conversationList.map((element) {
          if (element.messageId == socket.data?.messageId) {
            element.status = socket.data?.status;
            return element;
          } else {
            return element;
          }
        }).toList();
        conversationList = removeDuplicatesById(conversationList);
        onSocketChatStatusCalled.call();
      });

      AppSocketioService.socket.on("room.handover", (output) async {
        AppLoggerCS.debugLog("[socket][room.handover] output: ${jsonEncode(output)}");
        SocketRoomHandoverResponseModel socket = SocketRoomHandoverResponseModel.fromJson(output);
        sessionId = socket.data!.session!.id!;
        roomId = socket.data!.session!.roomId!;
        onSocketRoomHandoverCalled.call();
      });

      AppSocketioService.socket.on("room.closed", (output) async {
        AppLoggerCS.debugLog("[socket][room.closed] output: ${jsonEncode(output)}");
        SocketRoomClosedResponseModel socket = SocketRoomClosedResponseModel.fromJson(output);
        // isWebSocketStart = false;
        if (socket.data?.csat != null) {
          // isRoomClosed = false;
          isRoomClosed = RoomCloseState.open;
        } else {
          isRoomClosed = RoomCloseState.closeWaiting;
        }
        onSocketRoomClosedCalled.call();
      });

      AppSocketioService.socket.on("csat", (output) async {
        AppLoggerCS.debugLog("[socket][csat] output: ${jsonEncode(output)}");
        SocketChatResponseModel socket = SocketChatResponseModel.fromJson(output);

        sessionId = socket.session!.id!;
        roomId = socket.session!.roomId!;

        ConversationList? chatModel;
        chatModel = null;

        chatModel = ConversationList(
          session: SessionGetConversation(
            botStatus: socket.session?.botStatus,
            agent: UserGetConversation(
              id: socket.agent?.userId,
              name: socket.agent?.name,
              username: socket.agent?.username,
            ),
          ),
          fromType: socket.message?.fromType,
          text: socket.message?.text,
          messageId: socket.messageId,
          user: UserGetConversation(
            id: socket.customer?.userId,
            username: socket.customer?.username,
            name: socket.customer?.name,
          ),
          messageTime: socket.message?.time,
          sessionId: socket.session?.id,
          roomId: socket.session?.roomId,
          replyId: socket.replyId,
          payload: socket.message?.payload,
          type: socket.message?.type,
        );
        conversationList.add(chatModel);

        onSocketCSATCalled.call();
      });

      AppSocketioService.socket.on("csat.close", (output) async {
        AppLoggerCS.debugLog("[socket][csat.close] output: ${jsonEncode(output)}");
        isWebSocketStart = false;
        onSocketCSATCloseCalled.call();
      });

      AppSocketioService.socket.on("customer.is_blocked", (output) async {
        AppLoggerCS.debugLog("[socket][customer.is_blocked] output: ${jsonEncode(output)}");
        Map<String, dynamic> result = jsonDecode(output);
        AppLoggerCS.debugLog("[socket][customer.is_blocked] is_blocked: ${result['is_blocked']}");
        isCustomerBlocked = result['is_blocked'];
        if (isCustomerBlocked) {
          InterModule.accessToken = "";
        }
        onSocketCustomerIsBlockedCalled.call();
      });
      AppSocketioService.socket.on("disconnect", (output) async {
        AppLoggerCS.debugLog("[socket][disconnect] output: ${jsonEncode(output)}");
        isWebSocketStart = false;
        InterModule.accessToken = "";
        onSocketDisconnectCalled.call();
      });
    } catch (e) {
      AppLoggerCS.debugLog('[handleWebSocketIO] e: $e');
      onFailed?.call(e.toString());
    }
  }

  static String sessionId = "";
  static String roomId = "";

  void emitBotChat({
    required BodyBotPayload botDataChosen,
    required ConversationList chatData,
    void Function()? onSent,
  }) {
    String uuid = const Uuid().v4();
    Map jwtValue = JwtConverter().decodeJwt(InterModule.accessToken);
    DateTime currentDateValue = DateTime.now();
    Map<String, dynamic> dataEmit = {
      "message_id": uuid,
      "reply_id": null,
      "ttl": 5,
      "time": currentDateValue.toUtc().toIso8601String(),
      "type": botDataChosen.type,
      "text": botDataChosen.title,
      "postback": botDataChosen.toJson(),
      "channel_code": checkPlatform(),
      "from_type": 1,
      "room_id": jwtValue["payload"]["data"]["room_id"],
      "session_id": jwtValue["payload"]["data"]["session_id"],
    };

    AppLoggerCS.debugLog("[emitBotChat] dataEmit: ${jsonEncode(dataEmit)}");

    AppSocketioService.socket.emit(
      "chat",
      dataEmit,
    );

    // ConversationList? chatModel = ConversationList(
    //   fromType: "1",
    //   text: botDataChosen.title,
    //   type: "postback",
    //   messageId: uuid,
    //   status: 2,
    //   messageTime: currentDateValue.toUtc(),
    // );
    // conversationList.add(chatModel);
    onSent?.call();
  }

  void emitCarousel({
    required BodyCarouselPayload carouselDataChosen,
    required ConversationList chatData,
    void Function()? onSent,
  }) {
    String uuid = const Uuid().v4();
    Map jwtValue = JwtConverter().decodeJwt(InterModule.accessToken);
    DateTime currentDateValue = DateTime.now();
    Map<String, dynamic> dataEmit = {
      "message_id": uuid,
      "reply_id": null,
      "ttl": 5,
      "time": currentDateValue.toUtc().toIso8601String(),
      "type": carouselDataChosen.actions![0].type,
      "text": carouselDataChosen.actions![0].title,
      "postback": carouselDataChosen.actions![0].toJson(),
      "channel_code": checkPlatform(),
      "from_type": 1,
      "room_id": jwtValue["payload"]["data"]["room_id"],
      "session_id": jwtValue["payload"]["data"]["session_id"],
    };

    AppLoggerCS.debugLog("[emitCarousel] dataEmit: ${jsonEncode(dataEmit)}");

    AppSocketioService.socket.emit(
      "chat",
      dataEmit,
    );

    // ConversationList? chatModel = ConversationList(
    //   fromType: "1",
    //   text: carouselDataChosen.actions?[0].title,
    //   type: carouselDataChosen.actions?[0].type,
    //   messageId: uuid,
    //   status: 2,
    //   messageTime: currentDateValue.toUtc(),
    // );
    // conversationList.add(chatModel);
    onSent?.call();
  }

  void emitCsat({
    required BodyCsatPayload postbackDataChosen,
    required ConversationList chatData,
    void Function()? onSent,
    void Function()? onFailed,
  }) {
    try {
      String uuid = const Uuid().v4();
      Map jwtValue = JwtConverter().decodeJwt(InterModule.accessToken);
      DateTime currentDateValue = DateTime.now();
      Map<String, dynamic> dataEmit = {
        "message_id": uuid,
        "reply_id": null,
        "ttl": 5,
        "time": currentDateValue.toUtc().toIso8601String(),
        "type": "postback",
        // "type": (postbackDataChosen.type != "" || postbackDataChosen.type != null) ? postbackDataChosen.type : "button",
        "text": postbackDataChosen.title,
        "postback": {
          "type": postbackDataChosen.type,
          "key": postbackDataChosen.key,
          "value": postbackDataChosen.value,
          "title": postbackDataChosen.title,
          "description": postbackDataChosen.description,
          "media_url": postbackDataChosen.mediaUrl,
          "url": postbackDataChosen.url,
        },
        "channel_code": checkPlatform(),
        "from_type": 1,
        "room_id": jwtValue["payload"]["data"]["room_id"],
        "session_id": jwtValue["payload"]["data"]["session_id"],
      };

      AppLoggerCS.debugLog("[emitCsat] dataEmit: ${jsonEncode(dataEmit)}");

      AppSocketioService.socket.emit(
        "chat",
        dataEmit,
      );

      ConversationList? chatModel;
      chatModel = null;

      chatModel = ConversationList(
        fromType: "1",
        text: postbackDataChosen.title,
        type: "postback",
        messageId: uuid,
        status: 2,
        messageTime: currentDateValue.toUtc(),
      );
      conversationList.add(chatModel);
      onSent?.call();
    } catch (e) {
      AppController.isCSATOpen = false;
      onFailed?.call();
    }
  }

  void emitCsatText({
    required String text,
    void Function()? onSent,
    void Function()? onFailed,
  }) {
    try {
      String uuid = const Uuid().v4();
      Map jwtValue = JwtConverter().decodeJwt(InterModule.accessToken);
      DateTime currentDateValue = DateTime.now();
      Map<String, dynamic> dataEmit = {
        "message_id": uuid,
        "reply_id": null,
        "ttl": 5,
        "time": currentDateValue.toUtc().toIso8601String(),
        "type": "text",
        "text": text,
        "channel_code": checkPlatform(),
        "from_type": 1,
        "room_id": jwtValue["payload"]["data"]["room_id"],
        "session_id": jwtValue["payload"]["data"]["session_id"],
      };

      AppLoggerCS.debugLog("[emitCsatText] dataEmit: ${jsonEncode(dataEmit)}");

      AppSocketioService.socket.emit(
        "chat",
        dataEmit,
      );

      ConversationList? chatModel;
      chatModel = null;

      chatModel = ConversationList(
        fromType: "1",
        text: text,
        type: "text",
        messageId: uuid,
        status: 2,
        messageTime: currentDateValue.toUtc(),
      );
      conversationList.add(chatModel);
      onSent?.call();
    } catch (e) {
      AppController.isCSATOpen = false;
      onFailed?.call();
    }
  }

  static void Function(FetchingState state) scaffoldMessengerCallback = (FetchingState state) {};

  Future<void> getConfig({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      scaffoldMessengerCallback.call(FetchingState.loading);

      AppController.socketReady = false;

      GetConfigResponseModel? getConfigResponseModel = await ChatRepositoryImpl().getConfig(
        clientId: InterModule.clientId,
      );
      if (getConfigResponseModel == null) {
        onFailed?.call("empty data");
        scaffoldMessengerCallback.call(FetchingState.failed);
        return;
      }

      if (getConfigResponseModel.meta == null || getConfigResponseModel.data == null) {
        onFailed?.call("empty data 2");
        scaffoldMessengerCallback.call(FetchingState.failed);
        return;
      }

      if (getConfigResponseModel.meta?.code != 200) {
        onFailed?.call("${getConfigResponseModel.meta?.message}");
        scaffoldMessengerCallback.call(FetchingState.failed);
        return;
      }

      if (getConfigResponseModel.meta?.code == 200) {
        DataGetConfig tempDataConfig = getConfigResponseModel.data!;
        if (getConfigResponseModel.data!.avatarImage != null) {
          Uint8List dataAvatar = await AppBase64ConverterHelper().decodeBase64Cleaning(getConfigResponseModel.data!.avatarImage!);
          tempDataConfig.avatarImageBit = dataAvatar;
        }
        if (getConfigResponseModel.data!.iosIcon != null) {
          Uint8List dataIcon = await AppBase64ConverterHelper().decodeBase64Cleaning(getConfigResponseModel.data!.iosIcon!);
          tempDataConfig.widgetIconBit = dataIcon;
        }
        dataGetConfigValue = tempDataConfig;
        await ChatLocalSource().setConfigData(getConfigResponseModel.data!);

        await configValue();
        onSuccess?.call();
        scaffoldMessengerCallback.call(FetchingState.success);
        return;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[getConfig] e: $e");
      onFailed?.call(e.toString());
      scaffoldMessengerCallback.call(FetchingState.failed);
      return;
    }
  }

  static DataGetConfig? dataGetConfigValue;

  Future<void> getConfigFromNative({
    required DataGetConfig dataInput,
    void Function(DataGetConfig data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      DataGetConfig tempDataConfig = dataInput;
      if (dataInput.avatarImage != null) {
        Uint8List dataAvatar = await AppBase64ConverterHelper().decodeBase64Cleaning(dataInput.avatarImage!);
        tempDataConfig.avatarImageBit = dataAvatar;
      }
      if (dataInput.iosIcon != null) {
        Uint8List dataIcon = await AppBase64ConverterHelper().decodeBase64Cleaning(dataInput.iosIcon!);
        tempDataConfig.widgetIconBit = dataIcon;
      }
      dataGetConfigValue = tempDataConfig;

      await configValue();
      onSuccess?.call(tempDataConfig);
    } catch (e) {
      AppLoggerCS.debugLog("[getConfigFromNative] error $e");
      onFailed?.call(e.toString());
    }
  }

  Future<void> getConfigFromLocal({
    void Function(DataGetConfig data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      DataGetConfig? data = await ChatLocalSource().getConfigData();
      if (data == null) {
        onFailed?.call("empty data");
        return;
      }
      DataGetConfig tempDataConfig = data;
      Uint8List dataAvatar = await AppBase64ConverterHelper().decodeBase64Cleaning(data.avatarImage!);
      tempDataConfig.avatarImageBit = dataAvatar;
      Uint8List dataIcon = await AppBase64ConverterHelper().decodeBase64Cleaning(data.iosIcon!);
      tempDataConfig.widgetIconBit = dataIcon;
      await configValue();
      dataGetConfigValue = tempDataConfig;

      onSuccess?.call(tempDataConfig);
      return;
    } catch (e) {
      onFailed?.call(e.toString());
      return;
    }
  }

  static Future<DataGetConfig?> getConfigFromLocal2() async {
    try {
      DataGetConfig? data = await ChatLocalSource().getConfigData();
      if (data == null) {
        return null;
      }
      DataGetConfig tempDataConfig = data;
      Uint8List dataAvatar = await AppBase64ConverterHelper().decodeBase64Cleaning(data.avatarImage!);
      tempDataConfig.avatarImageBit = dataAvatar;
      Uint8List dataIcon = await AppBase64ConverterHelper().decodeBase64Cleaning(data.iosIcon!);
      tempDataConfig.widgetIconBit = dataIcon;
      await configValue();
      dataGetConfigValue = tempDataConfig;

      return dataGetConfigValue;
    } catch (e) {
      return null;
    }
  }

  static Color headerTextColor = Colors.green;
  static Color headerBackgroundColor = Colors.teal;
  static Color floatingButtonColor = Colors.white;
  static Color floatingTextColor = Colors.black;
  static String floatingText = "";
  static Uint8List? iconWidget;
  // static ValueNotifier<Uint8List?> iconWidget = ValueNotifier(null);

  // static Function() onConfigValueCalled = () {};

  static Future<void> configValue() async {
    AppLoggerCS.debugLog("call configValue");
    if (dataGetConfigValue != null) {
      InterModule.setupConfig(dataGetConfigValue!);
      headerTextColor = hexToColor(dataGetConfigValue!.headerTextColor!);
      headerBackgroundColor = hexToColor(dataGetConfigValue!.headerBackgroundColor!);
      floatingButtonColor = hexToColor(dataGetConfigValue!.buttonColor!);
      floatingTextColor = hexToColor(dataGetConfigValue!.textButtonColor!);
      floatingText = "${dataGetConfigValue!.textButton}";
      iconWidget = dataGetConfigValue!.widgetIconBit;
      // iconWidget.value = dataGetConfigValue!.widgetIconBit;
      // AppLoggerCS.debugLog("iyconWidget.value: ${iconWidget.value}");
      // onConfigValueCalled.call();
      AppLoggerCS.debugLog("call configValue done");
    }
  }

  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }
    return Colors.black;
  }

  static String nameUser = "";
  static String usernameUser = "";

  Future<void> loadData({
    required String name,
    required String email,
  }) async {
    isLoading = true;
    try {
      nameUser = name;
      usernameUser = email;
      await ChatLocalSource()
          .setClientData(
        name: name,
        email: email,
      )
          .then((_) {
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
    }
  }

  static bool isWebSocketStart = false;

  Future<void> sendChat({
    String? text,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
    void Function(MetaSendChat value)? onGreetingsFailed,
    void Function()? onCustomerBlockedFailed,
    void Function()? onChatSentFirst,
  }) async {
    isLoading = true;
    try {
      String uuidHolder = const Uuid().v4();
      ConversationList? chatModel0;
      chatModel0 = null;
      chatModel0 = ConversationList(
        fromType: "1",
        text: text,
        messageId: uuidHolder,
        messageTime: DateTime.now().toUtc(),
        status: 0,
      );
      conversationList.add(chatModel0);
      onChatSentFirst?.call();

      if (InterModule.accessToken == "") {
        Map<String, dynamic>? localDataFormatted = await ChatLocalSource().getClientData();

        SendChatRequestModel requestBody = SendChatRequestModel(
          name: localDataFormatted?["name"],
          text: text,
          username: localDataFormatted?["username"],
        );

        SendChatResponseModel? output = await ChatRepositoryImpl().sendChat(
          clientId: InterModule.clientId,
          request: requestBody,
        );
        // AppLoggerCS.debugLog("output: ${output?.toJson()}");
        if (output == null) {
          onFailed?.call("empty data #1110");
          return;
        }
        if (output.meta == null) {
          onFailed?.call("empty data #1111");
          return;
        }
        if (output.meta?.code == 403) {
          conversationListFirstChat = removeDuplicatesById(conversationListFirstChat);
          String uuid = const Uuid().v4();
          ConversationList? chatModel;
          chatModel = null;

          chatModel = ConversationList(
            fromType: "2",
            text: "${output.meta?.message}",
            messageId: uuid,
            messageTime: DateTime.now().toUtc(),
          );

          conversationList.add(chatModel);
          
          conversationList.map((e) {
            if (e.status == 0) {
              return e.status = 1;
            }
          });
          conversationListFirstChat.addAll(conversationList);
          onGreetingsFailed?.call(output.meta!);
          return;
        }
        if (output.meta?.code == 508) {
          isCustomerBlocked = true;
          conversationListFirstChat = removeDuplicatesById(conversationListFirstChat);
          conversationListFirstChat.addAll(conversationList);
          onCustomerBlockedFailed?.call();
          return;
        }
        if (output.meta?.code != 200) {
          onFailed?.call("${output.meta?.message}");
          return;
        }
        if (output.meta?.code == 200) {
          Map jwtValue = JwtConverter().decodeJwt(output.data!.token!);
          // AppLoggerCS.debugLog("jwtValue: ${jsonEncode(jwtValue)}");

          await ChatLocalSource().setSupportData(output.data!);

          InterModule.accessToken = output.data!.token!;
          await ChatLocalSource().setAccessToken(output.data!.token!);

          if (!isWebSocketStart) {
            await startWebSocketIO();
            await handleWebSocketIO();
            isWebSocketStart = true;
          }

          conversationData = null;
          conversationList = [];
          currentPage = 1;

          _getConversation(
            roomId: jwtValue["payload"]["data"]["room_id"],
            onSuccess: () async {
              // AppLoggerCS.debugLog("conversationList.last: ${jsonEncode(conversationList.last)}");
              if (isWebSocketStart) {
                DateTime currentDateTime = DateTime.now();
                AppSocketioService.socket.emit(
                  "chat.status",
                  {
                    "data": {
                      "message_id": conversationList.first.messageId,
                      "room_id": conversationList.first.roomId,
                      "session_id": conversationList.first.sessionId,
                      "status": 2,
                      "times": (currentDateTime.millisecondsSinceEpoch / 1000).floor(),
                      "timestamp": getDateTimeFormatted(value: currentDateTime),
                    },
                  },
                );
                isWebSocketStart = true;
              }
              onSuccess?.call();
            },
            onFailed: (errorMessage) {
              onFailed?.call(errorMessage);
            },
          );
          return;
        }
      } else {
        // if (!isWebSocketStart) {
        //   await startWebSocketIO();
        //   await handleWebSocketIO();
        //   isWebSocketStart = true;
        // }

        Map jwtValue = JwtConverter().decodeJwt(InterModule.accessToken);
        // String uuid = const Uuid().v4();
        DateTime currentDateTime = DateTime.now();
        // AppSocketioService.socket.emitWithAckAsync(
        // AppSocketioService.socket.emitWithAck(
        AppSocketioService.socket.emit(
          "chat",
          {
            "message_id": uuidHolder,
            "reply_id": null,
            "ttl": 5,
            "text": text,
            // "time": getDateTimeFormatted(),
            "time": currentDateTime.toUtc().toIso8601String(),
            "type": "text",
            "room_id": jwtValue["payload"]["data"]["room_id"],
            "session_id": jwtValue["payload"]["data"]["session_id"],
            "channel_code": checkPlatform(),
            "reply_token": "",
            "from_type": 1,
            "status": 0,
          },
        );
      }
    } catch (e) {
      AppLoggerCS.debugLog("[sendChat] error: $e");
      onFailed?.call(e.toString());
      isLoading = false;
    }
  }

  String checkPlatform() {
    String platform = "webhook";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    } else {
      platform = "web";
    }
    return platform;
  }

  String getDateTimeFormatted({
    DateTime? value,
    String? version,
  }) {
    String date1 = DateFormat("yyyy-MM-dd").format(value ?? DateTime.now());
    // AppLoggerCS.debugLog("date1: $date1");
    String time1 = DateFormat("hh:mm:ss.").format(value ?? DateTime.now());
    // AppLoggerCS.debugLog("time1: $time1");
    String concatDateTime = "";
    if (version == "1") {
      concatDateTime = "${date1}T${time1}992Z";
    } else {
      concatDateTime = "${("${date1}T$time1").replaceAll(".", "")}+07.00";
    }
    AppLoggerCS.debugLog("concatDateTime: $concatDateTime");
    return concatDateTime;
  }

  static GetConversationResponseModel? conversationData;
  static List<ConversationList> conversationList = [];

  static GetConversationResponseModel? conversationDataFirstChat;
  static List<ConversationList> conversationListFirstChat = [];

  List<ConversationList> removeDuplicatesById(List<ConversationList> originalList) {
    final seenIds = <String>{};
    return originalList.where((item) {
      final isNew = !seenIds.contains(item.messageId);
      seenIds.add(item.messageId!);
      return isNew;
    }).toList();
  }

  Future<void> _getConversation({
    // String? text,
    required String roomId,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
    void Function(bool isLoading)? onLoading,
  }) async {
    onLoading?.call(true);
    isLoading = true;
    try {
      DataSendChat? supportData = await ChatLocalSource().getSupportData();
      if (supportData == null) {
        onLoading?.call(false);
        onFailed?.call("process 2 don't success");
        return;
      }

      GetConversationResponseModel? output = await ChatRepositoryImpl().getConversation(
        limit: limit,
        roomId: roomId,
        currentPage: currentPage,
        sessionId: supportData.sessionId ?? "",
      );
      // AppLoggerCS.debugLog("[_getConversation] output ${jsonEncode(output?.meta?.toJson())}");
      if (output == null) {
        onLoading?.call(false);
        isLoading = false;
        onFailed?.call("empty data #1110");
        return;
      }
      if (output.meta == null) {
        onLoading?.call(false);
        isLoading = false;
        onFailed?.call("empty data #1111");
        return;
      }
      if (output.meta?.code != 200) {
        onLoading?.call(false);
        isLoading = false;
        onFailed?.call("${output.meta?.message}");
        return;
      }

      conversationData = output;
      conversationList.addAll(output.data!.conversations!);
      conversationList.addAll(conversationListFirstChat);
      conversationList.sort((a, b) => a.messageTime!.compareTo(b.messageTime!));
      conversationList = removeDuplicatesById(conversationList);
      // conversationList = conversationList.reversed.toList();

      InterModule.accessToken = output.data!.token!;
      await ChatLocalSource().setAccessToken(output.data!.token!);

      isLoading = false;
      onLoading?.call(false);
      onSuccess?.call();
    } catch (e) {
      AppLoggerCS.debugLog("[_getConversation] error: $e");
      isLoading = false;
      onLoading?.call(false);
      onFailed?.call(e.toString());
    }
  }

  static int currentPage = 1;
  static int limit = 20;

  Future<void> loadMoreConversation({
    String? text,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      if (conversationData != null && conversationData!.meta != null) {
        if (currentPage <= conversationData!.meta!.pageCount!) {
          currentPage++;
          Map<String, dynamic>? decodeJwt = await _decodeJwt();

          await _getConversation(
            roomId: decodeJwt!["payload"]["data"]["room_id"],
            onSuccess: () {
              isLoading = false;
              onSuccess?.call();
            },
            onFailed: (errorMessage) {
              isLoading = false;
              onFailed?.call(errorMessage);
            },
          );
        } else {
          onSuccess?.call();
        }
      }
    } catch (e) {
      AppLoggerCS.debugLog("[loadMoreConversation] error: $e");
      isLoading = false;
      onFailed?.call(e.toString());
    }
  }

  Future<void> uploadMedia({
    required String? text,
    required File mediaData,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
    void Function(bool isLoading)? onLoading,
  }) async {
    onLoading?.call(true);
    isLoading = true;
    try {
      await Future.delayed(Duration(milliseconds: 100));
      UploadFilesResponseModel? output = await ChatRepositoryImpl().uploadMedia(
        text: text,
        mediaData: mediaData.path,
      );
      AppLoggerCS.debugLog("[uploadMedia] output ${jsonEncode(output?.meta?.toJson())}");

      if (output == null) {
        isLoading = false;
        onLoading?.call(false);
        onFailed?.call("empty data");
        return;
      }

      if (output.meta == null) {
        isLoading = false;
        onLoading?.call(false);
        onFailed?.call("empty data 2");
        return;
      }

      if (output.meta?.code != 201) {
        isLoading = false;
        onLoading?.call(false);
        onFailed?.call("${output.meta?.message}");
        return;
      }

      if (output.meta?.code == 201) {
        Map<String, dynamic>? decodeJwt = await _decodeJwt();

        conversationData = null;
        conversationList = [];
        currentPage = 1;

        _getConversation(
          roomId: decodeJwt!["payload"]["data"]["room_id"],
          onLoading: onLoading,
          onSuccess: () {
            if (isWebSocketStart) {
              AppSocketioService.socket.emit(
                "chat.status",
                {
                  "data": {
                    "message_id": conversationList.first.messageId,
                    "room_id": conversationList.first.roomId,
                    "session_id": conversationList.first.sessionId,
                    "status": 2,
                    "times": (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
                    "timestamp": getDateTimeFormatted(),
                  },
                },
              );
              isWebSocketStart = true;
            }

            isLoading = false;
            onLoading?.call(false);
            onSuccess?.call();
          },
          onFailed: (errorMessage) {
            isLoading = false;
            onLoading?.call(false);
            onFailed?.call(errorMessage);
          },
        );
      }
    } catch (e) {
      isLoading = false;
      onLoading?.call(false);
      onFailed?.call(e.toString());
      return;
    }
  }

  Future<Map<String, dynamic>?> _decodeJwt({
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      String? token = await ChatLocalSource().getAccessToken();
      if (token == null) {
        onFailed?.call("process don't success");
        return null;
      }

      Map<String, dynamic> decodeJwt = JwtConverter().decodeJwt(token);
      // AppLoggerCS.debugLog("[_decodeJwt] $decodeJwt");
      return decodeJwt;
    } catch (e) {
      onFailed?.call("e: $e");
      return null;
    }
  }
}
