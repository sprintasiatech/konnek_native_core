import 'package:fam_coding_supply/logic/export.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppSocketioService {
  // Dart client
  // IO.Socket socket = IO.io('http://localhost:3000');
  // socket.onConnect((_) {
  //   print('connect');
  //   socket.emit('msg', 'test');
  // });
  // socket.on('event', (data) => print(data));
  // socket.onDisconnect((_) => print('disconnect'));
  // socket.on('fromServer', (_) => print(_));

  static late IO.Socket socket;

  static bool isOn = false;

  static IO.Socket connect({
    required String url,
    required String token,
  }) {
    try {
      AppLoggerCS.debugLog("connect socket");
      socket = IO.io(
        // "your-socket-url",
        url,
        IO.OptionBuilder()
            .setReconnectionDelayMax(10000)
            .setTransports(['websocket'])
            // ..setTransportOptions(
            //   {
            //     'polling': {
            //       'extraHeaders': {
            //         'Authorization': token,
            //       }
            //     },
            //   },
            // )
            .setExtraHeaders(
              {
                'Authorization': token,
              },
            )
            // .setAuth(
            //   {
            //     'Authorization': token,
            //   },
            // )
            // .disableAutoConnect()
            .enableForceNew()
            .enableReconnection()
            .build(),
      );

      socket.onConnect((_) {
        AppLoggerCS.debugLog("[AppSocketioService][onConnect] Connection established");
        AppLoggerCS.debugLog('🔐 Session ID: ${socket.id}'); // ← this is the sid
        isOn = true;
        socket.id = socket.id;
      });

      socket.onDisconnect((_) {
        AppLoggerCS.debugLog("[AppSocketioService][onDisconnect] Disconnect socket");
        isOn = false;
      });

      socket.onConnectError((error) {
        AppLoggerCS.debugLog("[error] $error");
      });

      socket.onError((error) {
        AppLoggerCS.debugLog("[error1] $error");
      });

      socket.connect();
      return socket;
    } catch (e) {
      AppLoggerCS.debugLog("[AppSocketioService] error here: $e");
      rethrow;
    }
  }

  void listenToMessages(String eventName, Function(dynamic) onMessage) {
    socket.on(
      // 'new_message',
      eventName, 
      (data) {
        onMessage(data); // callback
      },
    );
  }

  void sendMessage(String eventName, Map<String, dynamic> message) {
    socket.emit(
      // 'send_message',
      eventName, 
      message,
    );
  }
}
