import 'package:flutter/material.dart';
import 'package:slivers_uploader/slivers_uploader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Uploader Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final uploader = FileUploader(
    chunkSize: 50 * 1024 * 1024, // 指定分块大小，默认 1024*1024
  );

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Uploader Example'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Upload File'),
          onPressed: () async {
            var file = await uploader.pickFile();
            await file.upload(
              url: 'http://192.168.31.239:8001/upload/',
              onSuccess: (chunkNumber) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Chunk $chunkNumber upload successful!')),
                );
              },
              onError: (chunkNumber) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Chunk $chunkNumber upload failed.')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
