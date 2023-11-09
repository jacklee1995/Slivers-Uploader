import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:slivers_uploader/file_uploader.dart';

void main() {
  testWidgets('FileUploader widget test', (WidgetTester tester) async {
    var widget = MaterialApp(
      home: Scaffold(
        body: TextButton(
          child: const Text('Upload File'),
          onPressed: () async {
            var uploader = FileUploader();
            var file = await uploader.pickFile();
            await file.upload(
              url: 'http://127.0.0.1/upload',
              onSuccess: () {
                print('Upload successful!');
              },
              onError: () {
                print('Upload failed.');
              },
            );
          },
        ),
      ),
    );

    await tester.pumpWidget(widget);

    var finder = find.text('Upload File');

    expect(finder, findsOneWidget);
  });
}
