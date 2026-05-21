import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/model/bulk_upload_response_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/model/bulk_upload_template_model.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/FileDownload/file_download_controller.dart';

import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class ProductBulkUploadController extends GetxController {

  final repo = Repository();
  RxString uploadErrorMessage = ''.obs;

  final FileDownloadController fileDownloadController = Get.put(FileDownloadController());


  final rxTemplateStatus = ApiStatus.COMPLETED.obs;
  final templateData = BulkUploadTemplateModel().obs;
  void setTemplateStatus(ApiStatus v) => rxTemplateStatus.value = v;

  Future<void> downloadTemplate() async {
    setTemplateStatus(ApiStatus.LOADING);
    try {
      final value = await repo.getProductBulkUploadTemplateApi();
      templateData.value = value;
      if (templateData.value.status == true) {
        final downloadedPath = await fileDownloadController.downloadAndSaveFile(
          templateData.value.url.toString());
        if (downloadedPath != null) {
          setTemplateStatus(ApiStatus.COMPLETED);
          Utils.showToast(templateData.value.message.toString());
        }
      } else {
        setTemplateStatus(ApiStatus.ERROR);
        Utils.showToast(
          templateData.value.message.toString(),
        );
      }
      pt("response data $value ");
    } catch (e) {
      pt("Template download error => $e");
      Utils.showToast(
        templateData.value.message.toString(),
      );
      setTemplateStatus(ApiStatus.ERROR);
    }
  }
  // ───────────────── FILE PICKER ─────────────────

  String? filePath;
  RxString fileName = ''.obs;
  RxBool isFileError = false.obs;
  Future<void> pickFile() async {isFileError.value = false;uploadErrorMessage.value = "";
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        if (file.size > 10 * 1024 * 1024) {
          isFileError.value = true;
          Utils.showToast("File must be less than 10MB");
          return;
        }
        filePath = file.path;
        fileName.value = file.name;
        uploadErrorMessage.value = "";
      }
    } catch (e) {
      isFileError.value = true;
      pt("File pick error => $e");
    }
  }
  void removeFile() {
    filePath = null;
    fileName.value = '';
    isFileError.value = false;
  }
  bool _validateFile() {
    if (filePath == null ||
        filePath!.isEmpty) {
      isFileError.value = true;
      Utils.showToast(
        "Please select a CSV or Excel file",
      );
      return false;
    }
    return true;
  }
  // ───────────────── BULK UPLOAD ─────────────────

  final rxUploadStatus = ApiStatus.COMPLETED.obs;
  final uploadData = BulkUploadResponseModel().obs;

  void setUploadStatus(ApiStatus v) => rxUploadStatus.value = v;

  // Future<void> uploadProducts() async {
  //   if (!_validateFile()) return;
  //   _setUploadStatus(ApiStatus.LOADING);
  //   try {
  //     final value = await _repo.productBulkUploadApi(
  //         file: File(filePath!));
  //     uploadData.value = value;
  //     if (uploadData.value.status == true) {
  //       _setUploadStatus(ApiStatus.COMPLETED);
  //       Utils.showToast(
  //         uploadData.value.message.toString(),
  //       );
  //       removeFile();
  //       Get.back(result: true);
  //     } else {
  //       _setUploadStatus(ApiStatus.ERROR);
  //       final errMsg =
  //       (uploadData.value.errors != null &&
  //           uploadData.value.errors!.isNotEmpty)
  //           ? uploadData.value.errors!.first
  //           : uploadData.value.message.toString();
  //       Utils.showToast(errMsg);
  //     }
  //     pt("response data $value ");
  //   } catch (e) {
  //     pt("Bulk upload error => $e");
  //     Utils.showToast(
  //       uploadData.value.message.toString(),
  //     );
  //     _setUploadStatus(ApiStatus.ERROR);
  //   }
  // }
  Future<void> uploadProducts() async {
    if (!_validateFile()) return;
    setUploadStatus(ApiStatus.LOADING);
    try {
      final value = await repo.productBulkUploadApi(file: File(filePath!),);
      uploadData.value = value;
      if (uploadData.value.status == true) {
        setUploadStatus(ApiStatus.COMPLETED);
        uploadErrorMessage.value = "";
        Utils.showToast(uploadData.value.msg?.toString() ??  "Products uploaded successfully");
        removeFile();
        Get.back(result: true);
      } else {
        setUploadStatus(ApiStatus.ERROR);
        String errMsg = "";
        if (uploadData.value.msg != null) {
          if (uploadData.value.msg is List) {
            errMsg = (uploadData.value.msg as List).join("\n");
          } else {
            errMsg = uploadData.value.msg.toString();
          }
        }
        uploadErrorMessage.value = errMsg;
      }
      pt("response data $value ");
    } catch (e) {
      pt("Bulk upload error => $e");
      Utils.showToast("Something went wrong");
      setUploadStatus(ApiStatus.ERROR);
    }
  }
}