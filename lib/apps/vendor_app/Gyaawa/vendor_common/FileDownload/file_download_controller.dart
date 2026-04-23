import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';


import '../../../../../Data/response/status.dart';
import '../../../../../Utils/snack_bar.dart';

class FileDownloadController extends GetxController{

  final rxRequestStats = ApiStatus.COMPLETED.obs;
  void setRxRequestStats(ApiStatus status) =>rxRequestStats.value = status;


  Future<String?> downloadAndSavePDF(String pdfUrl,{bool saveInDownload = true}) async {
    setRxRequestStats(ApiStatus.LOADING);
    try {
      Directory? targetDir;
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          debugPrint("❌ Storage permission denied.");
          setRxRequestStats(ApiStatus.ERROR);
          return null;
        }
        targetDir = saveInDownload
            ? Directory('/storage/emulated/0/Download')
            : Directory('/storage/emulated/0/Documents/Woye');
      } else if (Platform.isIOS) {
        targetDir = await getApplicationDocumentsDirectory();
      }

      if (targetDir == null) {
        debugPrint("❌ Failed to get the target directory.");
        return null;
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final String fileName = 'woye_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final String filePath = path.join(targetDir.path, fileName);
      final http.Response response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        debugPrint("✅ PDF Downloaded: $filePath");
        Utils.showToast("Downloaded successfully");
        setRxRequestStats(ApiStatus.COMPLETED);
        return file.path;
      } else {
        debugPrint("❌ Failed to download PDF. Status Code: ${response.statusCode}");
        setRxRequestStats(ApiStatus.ERROR);
        Utils.showToast("Download failed");
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error downloading PDF: $e");
      setRxRequestStats(ApiStatus.ERROR);
      return null;
    }
  }


  Future<String?> downloadAndSaveXLSX(String? fileUrl, {bool saveInDownload = true}) async {
    setRxRequestStats(ApiStatus.LOADING);

    if (fileUrl == null || fileUrl.isEmpty) {
      debugPrint("❌ Error: fileUrl is null or empty");
      Utils.showToast("Invalid file URL");
      setRxRequestStats(ApiStatus.ERROR);
      return null;
    }

    try {
      Directory? targetDir;
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          debugPrint("❌ Storage permission denied.");
          setRxRequestStats(ApiStatus.ERROR);
          return null;
        }
        targetDir = saveInDownload
            ? Directory('/storage/emulated/0/Download')
            : Directory('/storage/emulated/0/Documents/Woye');
      } else if (Platform.isIOS) {
        targetDir = await getApplicationDocumentsDirectory();
      }

      if (targetDir == null) {
        debugPrint("❌ Failed to get the target directory.");
        return null;
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final String fileName = 'woye_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final String filePath = path.join(targetDir.path, fileName);
      final http.Response response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        debugPrint("✅ XLSX Downloaded: $filePath");
        Utils.showToast("Downloaded successfully");
        setRxRequestStats(ApiStatus.COMPLETED);
        return file.path;
      } else {
        debugPrint("❌ Failed to download XLSX. Status Code: ${response.statusCode}");
        setRxRequestStats(ApiStatus.ERROR);
        Utils.showToast("Download failed");
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error downloading XLSX: $e");
      setRxRequestStats(ApiStatus.ERROR);
      return null;
    }
  }

  Future<String?> downloadAndSaveFile(String? fileUrl, {bool saveInDownload = true}) async {
    setRxRequestStats(ApiStatus.LOADING);

    if (fileUrl == null || fileUrl.isEmpty) {
      debugPrint("❌ Error: fileUrl is null or empty");
      Utils.showToast("Invalid file URL");
      setRxRequestStats(ApiStatus.ERROR);
      return null;
    }

    try {
      Directory? targetDir;
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          debugPrint("❌ Storage permission denied.");
          setRxRequestStats(ApiStatus.ERROR);
          return null;
        }
        targetDir = saveInDownload
            ? Directory('/storage/emulated/0/Download')
            : Directory('/storage/emulated/0/Documents/Woye');
      } else if (Platform.isIOS) {
        targetDir = await getApplicationDocumentsDirectory();
      }

      if (targetDir == null) {
        debugPrint("❌ Failed to get the target directory.");
        return null;
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      // 🔹 Detect file extension automatically
      String extension = path.extension(fileUrl);
      if (extension.isEmpty) extension = ".xlsx"; // default fallback

      final String fileName = 'woye_${DateTime.now().millisecondsSinceEpoch}$extension';
      final String filePath = path.join(targetDir.path, fileName);
      final http.Response response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        debugPrint("✅ File Downloaded: $filePath");
        Utils.showToast("Downloaded successfully");

        setRxRequestStats(ApiStatus.COMPLETED);

        // 🔹 Open the downloaded file
        final result = await OpenFilex.open(file.path);
        debugPrint("📂 OpenFile Result: ${result.message}");

        return file.path;
      } else {
        debugPrint("❌ Failed to download file. Status Code: ${response.statusCode}");
        setRxRequestStats(ApiStatus.ERROR);
        Utils.showToast("Download failed");
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error downloading file: $e");
      setRxRequestStats(ApiStatus.ERROR);
      return null;
    }
  }


  RxBool isLoading = false.obs;


}