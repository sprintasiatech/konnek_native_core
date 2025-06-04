import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Payload for isolate communication
class Base64DecodeMessage {
  final String base64String;
  final SendPort sendPort;

  Base64DecodeMessage(this.base64String, this.sendPort);
}

/// Top-level function to run in an isolate
void _base64DecodeIsolate(Base64DecodeMessage message) {
  final cleaned = _stripBase64Prefix(message.base64String);
  final decoded = base64Decode(cleaned);
  message.sendPort.send(decoded);
}

/// Strip MIME type and metadata prefix from base64 string
String _stripBase64Prefix(String base64Str) {
  final regex = RegExp(r'data:.*?;base64,');
  return base64Str.replaceFirst(regex, '');
}

/// Main function to call from UI or business logic
Future<Uint8List> decodeBase64UsingIsolate(String base64String) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(
    _base64DecodeIsolate,
    Base64DecodeMessage(base64String, receivePort.sendPort),
  );

  final result = await receivePort.first as Uint8List;
  receivePort.close();
  return result;
}

class AppBase64ConverterHelper {
  // // This function will run on a separate isolate
  // Future<String> decodeBase64(String base64String) async {
  //   return await compute(_base64Decode, base64String);
  // }

  // // Helper function that does the actual base64 decoding
  // String _base64Decode(String base64String) {
  //   List<int> bytes = base64Decode(base64String);
  //   return utf8.decode(bytes);
  // }

  // This function spawns an isolate, executes the _counterLoop function with a specified length,
// sends the result back to the main isolate, and returns the computed counter.
  Future<Uint8List> isolateRunBase64(String base64Value) async {
    // Creating a ReceivePort to listen for messages from the spawned isolate
    final receivePort = ReceivePort();

    // Spawning an isolate to execute the _counterLoop function
    Isolate.spawn((SendPort sendPort) {
      // Performing a computation in the spawned isolate and sending the result back
      Uint8List outputBase64 = _base64DecodeCleaning(base64Value);
      sendPort.send(outputBase64);
    }, receivePort.sendPort);

    // Waiting for the result from the spawned isolate
    final outputBase64 = await receivePort.first;

    // Closing the ReceivePort after receiving the result
    receivePort.close();

    // Returning the computed counter to the calling code
    return outputBase64;
  }

  Future<Uint8List> decodeBase64UsingIsolate(String base64String) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _base64DecodeIsolate,
      Base64DecodeMessage(base64String, receivePort.sendPort),
    );

    final result = await receivePort.first as Uint8List;
    receivePort.close();
    return result;
  }

  String stripBase64Prefix(String base64Str) {
    final regex = RegExp(r'data:.*?;base64,');
    return base64Str.replaceFirst(regex, '');
  }

  // Function to decode Base64 string and return Uint8List on a background isolate
  Future<Uint8List> decodeBase64Cleaning(String base64String) async {
    // String strippedBase64 = stripBase64Prefix(base64String);
    // return await compute(base64Decode, strippedBase64);
    // return Future.delayed(const Duration(milliseconds: 200), () async {
    //   return await compute(base64Decode, strippedBase64);
    // });
    return await compute(_base64DecodeCleaning, base64String);
  }

  // Helper function for decoding base64 to Uint8List
  Uint8List _base64DecodeCleaning(String base64String) {
    // Future<Uint8List> _base64DecodeCleaning(String base64String) {
    // return Future.delayed(const Duration(milliseconds: 100), () {
    //   String strippedBase64 = stripBase64Prefix(base64String);
    //   // Uint8List value = Uri.parse(base64String).data!.contentAsBytes();
    //   // return value;
    //   // return base64Decode(base64String);
    //   return base64Decode(strippedBase64);
    // });
    String strippedBase64 = stripBase64Prefix(base64String);
    // Uint8List value = Uri.parse(base64String).data!.contentAsBytes();
    // return value;
    // return base64Decode(base64String);
    return base64Decode(strippedBase64);
  }

  // Function to decode Base64 string and return Uint8List on a background isolate
  Future<Uint8List> decodeBase64(String base64String) async {
    return await compute(_base64Decode, base64String);
  }

// Helper function for decoding base64 to Uint8List
  Uint8List _base64Decode(String base64String) {
    return base64Decode(base64String);
  }

// Function to encode a Uint8List to Base64 string on a background isolate
  Future<String> encodeBase64(Uint8List data) async {
    return await compute(_base64Encode, data);
  }

// Helper function for encoding Uint8List to Base64 string
  String _base64Encode(Uint8List data) {
    return base64Encode(data);
  }

  Future<Uint8List> decodeVeryLargeBase64(String base64String) async {
    final receivePort = ReceivePort();
    final cleanBase64 = base64String.contains(',') ? base64String.split(',').last : base64String;

    await Isolate.spawn(
      _chunkedBase64Decode,
      _DecodeRequest(cleanBase64, receivePort.sendPort),
    );

    return await receivePort.first as Uint8List;
  }

  void _chunkedBase64Decode(_DecodeRequest request) {
    try {
      const chunkSize = 40000; // Process in 50KB chunks
      final result = BytesBuilder();
      final totalChunks = (request.base64String.length / chunkSize).ceil();

      for (var i = 0; i < totalChunks; i++) {
        final start = i * chunkSize;
        final end = (i + 1) * chunkSize;
        final chunk = request.base64String.substring(
          start,
          end.clamp(0, request.base64String.length),
        );

        result.add(base64.decode(chunk));
      }

      request.sendPort.send(result.toBytes());
    } catch (e) {
      request.sendPort.send(Exception('Chunked decode failed: $e'));
    } finally {
      Isolate.exit();
    }
  }
}

class _DecodeRequest {
  final String base64String;
  final SendPort sendPort;

  _DecodeRequest(this.base64String, this.sendPort);
}
