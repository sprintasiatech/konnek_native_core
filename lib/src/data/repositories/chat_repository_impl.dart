import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:konnek_native_core/src/data/models/request/send_chat_request_model.dart';
import 'package:konnek_native_core/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/get_conversation_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/send_chat_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/upload_media_response_model.dart';
import 'package:konnek_native_core/src/data/source/remote/chat_remote_source.dart';
import 'package:konnek_native_core/src/domain/repository/chat_repository.dart';
import 'package:konnek_native_core/src/support/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';

class ChatRepositoryImpl extends ChatRepository {
  // final ChatRemoteSource remoteSource;
  // ChatRepositoryImpl(this.remoteSource);

  static ChatRemoteSource remoteSource = ChatRemoteSourceImpl();

  @override
  io.Socket? startWebSocketIO() {
    try {
      io.Socket? socket = remoteSource.startWebSocketIO();
      return socket;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRepositoryImpl][startWebSocketIO] error: $e");
      rethrow;
    }
  }

  @override
  Future<GetConfigResponseModel?> getConfig({
    required String clientId,
  }) async {
    try {
      Response? response = await remoteSource.getConfig(
        clientId: clientId,
      );
      if (response == null) {
        return null;
      }
      if (response.data == null) {
        return null;
      }
      GetConfigResponseModel mapping = GetConfigResponseModel.fromJson(
        response.data,
      );
      return mapping;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GetConversationResponseModel?> getConversation({
    required int limit,
    required String roomId,
    required int currentPage,
    required String sessionId,
  }) async {
    try {
      Response? response = await remoteSource.getConversation(
        limit: limit,
        roomId: roomId,
        currentPage: currentPage,
        sesionId: sessionId,
      );
      if (response == null) {
        return null;
      }
      if (response.data == null) {
        return null;
      }
      GetConversationResponseModel mapping = GetConversationResponseModel.fromJson(
        response.data,
      );
      return mapping;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UploadFilesResponseModel?> uploadMedia({
    String? text,
    String? mediaData,
  }) async {
    try {
      MultipartFile media = await MultipartFile.fromFile(
        '$mediaData',
        filename: mediaData.toString().split('/').last,
        // contentType: MediaType('image', 'jpg'),
      );

      String uuid = const Uuid().v4();

      Map<String, dynamic> requestData = {
        "media": media,
        "message_id": uuid,
        "reply_id": "",
      };

      if (text != null) {
        requestData.addAll(
          {
            "text": text,
          },
        );
      }

      String date1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
      String time1 = DateFormat("hh:mm:ss.").format(DateTime.now());
      String concatDateTime = "${date1}T${time1}992Z";

      requestData.addAll(
        {
          "time": concatDateTime,
        },
      );

      Response? response = await remoteSource.uploadMedia(
        requestData: requestData,
      );
      if (response == null) {
        return null;
      }
      if (response.data == null) {
        return null;
      }

      UploadFilesResponseModel mapping = UploadFilesResponseModel.fromJson(
        response.data,
      );
      return mapping;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SendChatResponseModel?> sendChat({
    required String clientId,
    required SendChatRequestModel request,
  }) async {
    try {
      Response? response = await remoteSource.sendChat(
        clientId: clientId,
        request: request,
      );
      if (response == null) {
        return null;
      }
      if (response.data == null) {
        return null;
      }
      SendChatResponseModel mapping = SendChatResponseModel.fromJson(
        response.data,
      );
      return mapping;
    } catch (e) {
      AppLoggerCS.debugLog("[ChatRepositoryImpl][sendChat] error: $e");
      rethrow;
    }
  }
}
