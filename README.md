# Slivers Uploader

A file upload tool for Flutter, which can be used for slicing large files.

## Features

- Pick files using the file picker.
- Split large files into chunks.
- Upload chunks using HTTP multipart requests.
- Handle upload success and failure.

## Usage

First, create a `FileUploader` object:

```dart
var uploader = FileUploader();
```


Then, use the `pickFile` method to pick a file:

```dart
var file = await uploader.pickFile();
```

Finally, use the `upload` method to upload the file:

```dart
await file.upload(
    url: 'http://example.com/upload',
    onSuccess: () {
    print('Upload successful!');
},
onError: () {
      print('Upload failed.');
    },
);
```


## Dependencies

This plugin depends on the following plugins:

- [http](https://pub.dev/packages/http)
- [file_picker](https://pub.dev/packages/file_picker)
- [permission_handler](https://pub.dev/packages/permission_handler)

## License

[MIT](./LICENE)
