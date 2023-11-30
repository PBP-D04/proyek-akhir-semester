import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // Untuk menggunakan package 'path' untuk mengekstrak nama file dari URL

Future<File?> downloadAndSaveFile(String url) async {
  final response = await http.get(Uri.parse(url));
  final uint8list = response.bodyBytes;
  var buffer = uint8list.buffer;
  ByteData byteData = ByteData.view(buffer);
  var tempDir = await getTemporaryDirectory();
  if (response.statusCode == 200) {
    final directory = Directory.systemTemp; // Ganti dengan direktori penyimpanan yang diinginkan
    final fileName = basename(Uri.parse(url).path); // Mengambil nama file dari URL

    File file = File('${directory.path}/$fileName'); // Menggunakan nama file dari URL

    file.writeAsBytesSync(response.bodyBytes);

    // File telah diunduh dan disimpan sebagai objek File
    print('File telah diunduh dan disimpan di ${file.path}');

    return file; // Mengembalikan objek File yang sudah diunduh
  } else {
    // Gagal mengunduh file
    return null;
  }
}

Future<File> fileFromImageUrl(String url) async {
  final response = await http.get(Uri.parse(url));
  final documentDirectory = Directory.systemTemp;
  final fileName = basename(Uri.parse(url).path);
  final file = File(join(documentDirectory.path, fileName));
  file.writeAsBytesSync(response.bodyBytes);
  return file;
}

Future<XFile?> xFileFromImageUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Mengonversi body respons HTTP menjadi Uint8List
      Uint8List bytes = response.bodyBytes;

      // Mengonversi Uint8List menjadi XFile menggunakan XFile.fromBytes
      return XFile.fromData(bytes);
    } else {
      return null;
    }
  } catch (e) {
    print('Gagal membuat XFile: $e');
    return null;
  }
}

