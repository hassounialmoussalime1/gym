import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// ضغط الصورة قبل الرفع
  Future<File?> _compressImage(XFile image) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // ضغط الصورة باستخدام FlutterImageCompress
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path, // path من XFile
        targetPath,
        quality: 60,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) return null;

      // إذا كان نوع compressedFile هو XFile (أحيانًا يظهر في بعض الإصدارات)
      return File(compressedFile.path);
    } catch (e) {
      print("❌ Compression error: $e");
      return null;
    }
  }

  /// رفع صورة مضغوطة وإرجاع رابطها
  Future<String?> uploadImage(XFile imageFile, String folderName) async {
    try {
      final compressedFile = await _compressImage(imageFile);

      if (compressedFile == null) {
        print("❌ Could not compress image");
        return null;
      }

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('$folderName/$fileName.jpg');

      final uploadTask = await ref.putFile(compressedFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('❌ Error uploading image: $e');
      return null;
    }
  }
}
