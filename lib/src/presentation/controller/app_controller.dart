import 'dart:convert';
import 'dart:io';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter_module1/inter_module.dart';
import 'package:flutter_module1/src/data/models/request/send_chat_request_model.dart';
import 'package:flutter_module1/src/data/models/response/get_config_response_model.dart';
import 'package:flutter_module1/src/data/models/response/get_conversation_response_model.dart';
import 'package:flutter_module1/src/data/models/response/send_chat_response_model.dart';
import 'package:flutter_module1/src/data/models/response/socket_chat_response_model.dart';
import 'package:flutter_module1/src/data/models/response/upload_media_response_model.dart';
import 'package:flutter_module1/src/data/repositories/chat_repository_impl.dart';
import 'package:flutter_module1/src/data/source/local/chat_local_source.dart';
import 'package:flutter_module1/src/support/app_socketio_service.dart';
import 'package:flutter_module1/src/support/jwt_converter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppController {
  static bool isLoading = false;

  static bool socketReady = false;

  Future<void> startWebSocketIO({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      AppLoggerCS.debugLog("Call here AppController startWebSocketIO");
      await sendChat(
        onSuccess: () {
          IO.Socket? data = ChatRepositoryImpl().startWebSocketIO();
          if (data == null) {
            onSuccess?.call();
          } else {
            AppLoggerCS.debugLog("empty socket");
            onFailed?.call("empty socket");
          }
        },
        onFailed: (errorMessage) {
          onFailed?.call(errorMessage);
        },
      );
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

  Future<void> handleWebSocketIO({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      AppSocketioService.socket.onConnect((_) {
        AppLoggerCS.debugLog("onConnect: ${AppSocketioService.socket.toString()}");
      });

      AppSocketioService.socket.on("chat", (output) async {
        AppLoggerCS.debugLog("socket output: ${jsonEncode(output)}");
        SocketChatResponseModel socket = SocketChatResponseModel.fromJson(output);

        ConversationList? chatModel;
        chatModel = null;

        chatModel = ConversationList(
          // widget.data.session?.agent?.id
          session: SessionGetConversation(
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
        onSuccess?.call();
      });
    } catch (e) {
      AppLoggerCS.debugLog('[handleWebSocketIO] e: $e');
      onFailed?.call(e.toString());
    }
  }

  Future<void> getConfig({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      bool? valueSocketReady = await ChatLocalSource().getSocketReady();
      if (valueSocketReady != null) {
        AppController.socketReady = valueSocketReady;
      }

      GetConfigResponseModel? getConfigResponseModel = await ChatRepositoryImpl().getConfig(
        clientId: InterModule.clientId,
      );
      if (getConfigResponseModel == null) {
        onFailed?.call("empty data");
        return;
      }

      if (getConfigResponseModel.meta == null || getConfigResponseModel.data == null) {
        onFailed?.call("empty data 2");
        return;
      }

      if (getConfigResponseModel.meta?.code != 200) {
        onFailed?.call("${getConfigResponseModel.meta?.message}");
        return;
      }

      if (getConfigResponseModel.meta?.code == 200) {
        dataGetConfigValue = getConfigResponseModel.data;
        await ChatLocalSource().setConfigData(getConfigResponseModel.data!);
        onSuccess?.call();
        return;
      }
    } catch (e) {
      onFailed?.call(e.toString());
      return;
    }
  }

  static DataGetConfig? dataGetConfigValue;

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
      dataGetConfigValue = data;

      onSuccess?.call(data);
      return;
    } catch (e) {
      onFailed?.call(e.toString());
      return;
    }
  }

  Future<void> loadData({
    required String name,
    required String email,
  }) async {
    isLoading = true;
    try {
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

  Future<void> sendChat({
    String? text,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading = true;
    try {
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

        conversationData = null;
        conversationList = [];
        currentPage = 1;

        await _getConversation(
          roomId: jwtValue["payload"]["data"]["room_id"],
          onSuccess: () async {
            onSuccess?.call();
          },
          onFailed: (errorMessage) {
            onFailed?.call(errorMessage);
          },
        );
        return;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[sendChat] error: $e");
      onFailed?.call(e.toString());
      isLoading = false;
    }
  }

  static GetConversationResponseModel? conversationData;
  static List<ConversationList> conversationList = [];

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
  }) async {
    isLoading = true;
    try {
      DataSendChat? supportData = await ChatLocalSource().getSupportData();
      if (supportData == null) {
        onFailed?.call("process 2 don't success");
        return;
      }

      GetConversationResponseModel? output = await ChatRepositoryImpl().getConversation(
        limit: limit,
        roomId: roomId,
        currentPage: currentPage,
        sesionId: supportData.sessionId ?? "",
      );
      // AppLoggerCS.debugLog("[_getConversation] output ${jsonEncode(output?.meta?.toJson())}");
      if (output == null) {
        onFailed?.call("empty data #1110");
        return;
      }
      if (output.meta == null) {
        onFailed?.call("empty data #1111");
        return;
      }
      if (output.meta?.code != 200) {
        onFailed?.call("${output.meta?.message}");
        return;
      }

      conversationData = output;
      conversationList.addAll(output.data!.conversations!);
      conversationList = removeDuplicatesById(conversationList);
      // conversationList = conversationList.reversed.toList();

      InterModule.accessToken = output.data!.token!;
      await ChatLocalSource().setAccessToken(output.data!.token!);

      isLoading = false;
      onSuccess?.call();
    } catch (e) {
      AppLoggerCS.debugLog("[_getConversation] error: $e");
      isLoading = false;
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
  }) async {
    try {
      UploadFilesResponseModel? output = await ChatRepositoryImpl().uploadMedia(
        text: text,
        mediaData: mediaData.path,
      );
      AppLoggerCS.debugLog("[uploadMedia] output ${jsonEncode(output?.meta?.toJson())}");

      if (output == null) {
        onFailed?.call("empty data");
        return;
      }

      if (output.meta == null) {
        onFailed?.call("empty data 2");
        return;
      }

      if (output.meta?.code != 201) {
        onFailed?.call("${output.meta?.message}");
        return;
      }

      if (output.meta?.code == 201) {
        Map<String, dynamic>? decodeJwt = await _decodeJwt();

        conversationData = null;
        conversationList = [];
        currentPage = 1;

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
      }
    } catch (e) {
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
