import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// 文件上传类
class FileUploader {
  final int chunkSize; // 分块大小
  final int minChunkSize; // 最小分块大小

  // 可以设置分块大小和最小分块大小
  FileUploader({this.chunkSize = 1024 * 1024, this.minChunkSize = 1024 * 1024});

  // 选择文件的方法
  Future<PickedFile> pickFile() async {
    // 请求存储权限
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    // 选择文件
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      throw Exception('用户取消了文件选择');
    }
    PlatformFile file = result.files.first;

    // 返回一个PickedFile对象，如果文件大小大于minChunkSize，则分块，否则不分块
    return PickedFile(
      file: file,
      chunkSize: file.size > minChunkSize ? chunkSize : file.size,
    );
  }
}

// 选择的文件类
class PickedFile {
  final PlatformFile file; // 文件
  final int chunkSize; // 分块大小

  // 构造函数，需要一个文件和分块大小
  PickedFile({required this.file, required this.chunkSize});

  // 上传文件的方法，可以指定URL、方法、头部、成功回调和失败回调
  Future<void> upload({
    required String url,
    String method = 'POST',
    Map<String, String>? headers,
    Function? onSuccess,
    Function? onError,
  }) async {
    // 从文件路径读取文件内容
    List<int> bytes = await File(file.path!).readAsBytes();

    // 分块
    List<List<int>> chunks = [];
    for (int i = 0; i < bytes.length; i += chunkSize) {
      int end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      chunks.add(bytes.sublist(i, end));
    }

    // 上传块
    for (var chunk in chunks) {
      var request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll(headers ?? {});
      request.files.add(http.MultipartFile.fromBytes('file', chunk));
      var response = await request.send();
      if (response.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call();
      }
    }
  }
}
