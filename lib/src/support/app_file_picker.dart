import 'dart:io';

import 'package:file_picker/file_picker.dart';

class AppFilePickerServiceCS {
  Future<File?> pickFiles({
    bool allowMultiples = false,
    double? fileMaxSize,
    void Function(double sizeFileValue)? onSizeFile,
    void Function(String fileNameValue)? onFileName,
    void Function(String errorMessage)? onFailed,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File fileFormat = File(result.files.single.path!);

        String fileName = getFileName(fileFormat);
        onFileName?.call(fileName);

        double sizeFile = await calculateSizeWithValue(fileFormat);
        if (fileMaxSize == null) {
          onSizeFile?.call(sizeFile);
          return fileFormat;
        } else {
          if (sizeFile > fileMaxSize) {
            onFailed?.call("file exceeds limit, not allowed more than $fileMaxSize MB");
            return null;
          } else {
            onSizeFile?.call(sizeFile);
            return fileFormat;
          }
        }
      } else {
        return null;
      }
    } catch (e) {
      onFailed?.call("[pickFiles] $e");
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
