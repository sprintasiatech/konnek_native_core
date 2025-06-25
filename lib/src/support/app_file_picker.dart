import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:konnek_native_core/src/support/app_logger.dart';

class AppFilePickerServiceCS {
  Future<File?> pickFiles({
    bool allowMultiples = false,
    double? fileMaxSize,
    void Function(double sizeFileValue)? onSizeFile,
    void Function(String fileNameValue)? onFileName,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      AppLoggerCS.debugLog("[pickFiles]: run");
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      AppLoggerCS.debugLog("[pickFiles] result: $result");
      if (result != null) {
        File fileFormat = File(result.files.single.path!);

        String fileName = getFileName(fileFormat);
        onFileName?.call(fileName);

        double sizeFile = await calculateSizeWithValue(fileFormat);
        if (fileMaxSize == null) {
          AppLoggerCS.debugLog("[pickFiles] result fileMaxSize");
          onSizeFile?.call(sizeFile);
          return fileFormat;
        } else {
          if (sizeFile > fileMaxSize) {
            AppLoggerCS.debugLog("[pickFiles] result sizeFile > fileMaxSize");
            onFailed?.call("file exceeds limit, not allowed more than $fileMaxSize MB");
            return null;
          } else {
            AppLoggerCS.debugLog("[pickFiles] result sizeFile < fileMaxSize");
            onSizeFile?.call(sizeFile);
            return fileFormat;
          }
        }
      } else {
        AppLoggerCS.debugLog("[pickFiles] result null: $result");
        return null;
      }
    } catch (e) {
      onFailed?.call("[pickFiles] $e");
      AppLoggerCS.debugLog("[AppFilePickerServiceCS][pickFiles] $e");
      return null;
    }
  }

  String getFileName(File fileFormat) {
    String fileName = fileFormat.path.split('/').last;
    // AppLoggerCS.debugLog("[getFileName]: $fileName");
    return fileName;
  }

  Future<double> calculateSizeWithValue(File fileFormat) async {
    // Calculate the size in MB
    int sizeInBytes = await fileFormat.length();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    // AppLoggerCS.debugLog("Image Size MB: $sizeInMb");
    // AppLoggerCS.debugLog("Image Size KB: ${sizeInMb * 1000}");
    return sizeInMb;
  }
}
