import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// ضغط الصورة قبل الرفع (Mobile only)
  Future<XFile?> _compressImage(XFile image) async {
    if (kIsWeb) return null; // لا ضغط على Web

    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 60,
        format: CompressFormat.jpeg,
      );

      return compressedFile;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Compression error: $e");
      }
      return null;
    }
  }

  /// رفع صورة مضغوطة وإرجاع رابطها
  Future<String?> uploadImage(XFile imageFile, String folderName) async {
    try {
      if (kIsWeb) {
        // Web: رفع الصورة مباشرة بدون ضغط
        final data = await imageFile.readAsBytes();
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final ref = _storage.ref().child('$folderName/$fileName.jpg');
        final uploadTask = await ref.putData(data);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        return downloadUrl;
      } else {
        // Mobile: ضغط الصورة قبل الرفع
        final compressedFile = await _compressImage(imageFile);
        if (compressedFile == null) return null;
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final ref = _storage.ref().child('$folderName/$fileName.jpg');
        final uploadTask = await ref.putFile(compressedFile as File);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading image: $e');
      }
      return null;
    }
  }
}
