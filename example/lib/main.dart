import 'package:flutter/material.dart';
import 'package:slivers_uploader/file_uploader.dart';

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
  final uploader = FileUploader();

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
              url: 'http://127.0.0.1/upload',
              onSuccess: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Upload successful!')),
                );
              },
              onError: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Upload failed.')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
