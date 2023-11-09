import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUploader {
  final int chunkSize;
  final int minChunkSize;

  FileUploader({this.chunkSize = 1024 * 1024, this.minChunkSize = 1024 * 1024});

  Future<PickedFile> pickFile() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      throw Exception('用户取消了文件选择');
    }
    PlatformFile file = result.files.first;

    return PickedFile(
      file: file,
      chunkSize: file.size > minChunkSize ? chunkSize : file.size,
    );
  }
}

class PickedFile {
  final PlatformFile file;
  final int chunkSize;

  PickedFile({required this.file, required this.chunkSize});

  Future<void> upload({
    required String url,
    String method = 'POST',
    Map<String, String>? headers,
    Function(int)? onSuccess,
    Function(int)? onError,
  }) async {
    var raf = File(file.path!).openSync(mode: FileMode.read);

    int sentBytes = 0;
    int chunkNumber = 0;
    while (sentBytes < raf.lengthSync()) {
      List<int> chunk = raf.readSync(chunkSize);

      var request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll(headers ?? {});
      request.files.add(
          http.MultipartFile.fromBytes('file', chunk, filename: file.name));
      var response = await request.send();
      if (response.statusCode == 200) {
        onSuccess?.call(chunkNumber);
      } else {
        onError?.call(chunkNumber);
      }

      sentBytes += chunk.length;
      chunkNumber++;
    }

    raf.closeSync();
  }
}
