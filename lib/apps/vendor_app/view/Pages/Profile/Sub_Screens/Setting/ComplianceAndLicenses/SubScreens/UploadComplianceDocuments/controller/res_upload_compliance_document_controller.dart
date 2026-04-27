import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import '../../../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../../../../Utils/date_format.dart';
import '../../../../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/custom_image_cropper.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../../../../vendor_common/Models/common_response_model.dart';
import '../../../controller/restaurant_compliance_and_licenses_controller.dart';

class ResUploadComplianceDocumentController  extends GetxController{

  final ComplianceAndLicensesController complianceAndLicensesController = Get.isRegistered<ComplianceAndLicensesController>()
      ? Get.find<ComplianceAndLicensesController>() :  Get.put(ComplianceAndLicensesController());

  final repo = Repository();

  List<String> docType = ['Health Permit','Food Safety Certificate','Liquor License','Fire Safety certificate','Food Handler Certificate',
                          'Business License','Building Permit','Occupancy Certificate','Music Entertainment License','Other' ];


  Map<String, String> docTypeApiMap = {
    'Health Permit': 'health_permit',
    'Food Safety Certificate': 'food_safety_certificate',
    'Liquor License': 'liquor_license',
    'Fire Safety certificate': 'fire_safety_certificate',
    'Food Handler Certificate': 'food_handler_certificate',
    'Business License': 'business_license',
    'Building Permit': 'building_permit',
    'Occupancy Certificate': 'occupancy_certificate',
    'Music Entertainment License': 'music_entertainment_license',
    'Other': 'other',
  };

  RxString selectedDocType = "".obs;

  RxBool isErrorColor = false.obs;
  RxBool isErrorDocType = false.obs;

  Rx<TextEditingController> docLicenceNoController = TextEditingController().obs;
  Rx<TextEditingController> issuingAuthorityController = TextEditingController().obs;
  Rx<TextEditingController> additionalController = TextEditingController().obs;
  Rx<TextEditingController> issueDateController = TextEditingController().obs;
  Rx<TextEditingController> expiryDateController = TextEditingController().obs;

  final Rx<ApiResponse<CommonResponseModel>> _uploadDoc = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get uploadDoc => _uploadDoc;
  setUploadDoc(ApiResponse<CommonResponseModel> value){
    _uploadDoc.value = value;
  }


  Future<void> complianceDocumentsUploadApi()async{
    setUploadDoc(ApiResponse.loading());
    String selectedUiValue = selectedDocType.value;
    String apiValueSelectedDocType = docTypeApiMap[selectedUiValue] ?? '';

    var data = {
      "documents": [
        {
          "document_type": apiValueSelectedDocType,
          "document_number": docLicenceNoController.value.text,
          "issuing_authority": issuingAuthorityController.value.text,
          "issue_date":FormatDate.convertToApiFormat(issueDateController.value.text),
          "expiry_date": FormatDate.convertToApiFormat(expiryDateController.value.text),
          "additional_notes": additionalController.value.text,
          "image": imageBase64.value,
        }
      ]
    };
    pt(data.toString());

    repo.complianceDocumentsUpload(jsonEncode(data)).then((value) async{
      if(value.status == true){
        setUploadDoc(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "Documents uploaded successfully.");
        await complianceAndLicensesController.getComplianceApi(isRefresh: false);
        Get.back();
      }else{
        setUploadDoc(ApiResponse.error(value.message));
      }
    },).onError((error, stackTrace) {
      setUploadDoc(ApiResponse.error(error.toString()));
      pt(error.toString());
    },);

  }


  //-- date picker
  void pickDate({required TextEditingController controller})async{
    DateTime initialDate = DateTime.now();
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(controller.text);
      } catch (_) {
        initialDate = DateTime.now();
      }
    }
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if(pickedDate != null){
      controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      pt("format date>>>>>>>> ${controller.text}");
    }

  }

//scroll
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey docTypeKey = GlobalKey();
  GlobalKey issuingAuthorityKey = GlobalKey();
  GlobalKey licenseNoKey = GlobalKey();
  GlobalKey issueKey = GlobalKey();
  GlobalKey uploadDocKey = GlobalKey();
  GlobalKey expiryDateKey = GlobalKey();

  void scrollToFields(GlobalKey key, {alignment}){
    final context = key.currentContext;
    if(context!=null){
      Scrollable.ensureVisible(
          context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment:alignment ?? 0.05,
      );
    }
  }

  //-----------------images and pdf
  Rx<File?> image = Rx<File?>(null);
  RxString imageBase64 = "".obs;
  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  Future<void> pickImage(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;

        // Validate file size (10MB = 10 * 1024 * 1024 bytes)
        if (file.size > 10 * 1024 * 1024) {
          Utils.showToast( 'File too large - PDF file must be smaller than 10MB',bgColor: AppColors.red,toastLength: Toast.LENGTH_LONG);
          return;
        }

        // Validate file type
        final validImageTypes = ['jpg', 'jpeg', 'png'];
        final validPdfType = ['pdf'];
        final fileExtension = file.extension?.toLowerCase() ?? '';

        if (validImageTypes.contains(fileExtension)) {
          // Handle image files
          _pickedFile = XFile(file.path!);
          await cropImage(image, imageBase64);
        } else if (validPdfType.contains(fileExtension)) {
          // Handle PDF files
          await handlePdfFile(File(file.path!));
        } else {
          Utils.showToast( 'Invalid file type - Please select JPG, PNG, or PDF files only',bgColor: AppColors.red,toastLength: Toast.LENGTH_LONG);

          return;
        }

        isErrorColor.value = false;

        update();      }
    } catch (e) {
      print("Error picking file: $e");
      Utils.showToast( 'Failed to pick file.',bgColor: AppColors.red,toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> handlePdfFile(File pdfFile) async {
    try {
      // Validate PDF file size again
      final fileLength = await pdfFile.length();
      if (fileLength > 10 * 1024 * 1024) {
       Utils.showToast( 'File too large - PDF file must be smaller than 10MB',bgColor: AppColors.red,toastLength: Toast.LENGTH_LONG);
        return;
      }

      _pickedFile = XFile(pdfFile.path);
      // Convert PDF to base64
      final base64String = await convertFileToBase64(pdfFile);
      if (base64String.isNotEmpty) {
        print("Base64 PDF: --->>>$base64String<<<-----");
        imageBase64.value = base64String;

        // You might want to store the original file as well
        image.value = pdfFile;
        isErrorColor.value = false;
      } else {
        print("Failed to convert PDF to Base64");
        Utils.showToast( 'Failed to process PDF file',bgColor: AppColors.red,toastLength: Toast.LENGTH_LONG);

      }
    } catch (e) {
      print("Error handling PDF file: $e");
      Utils.showToast( 'Failed to process PDF file',bgColor: AppColors.red,toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<String> convertFileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print("Error converting file to Base64: $e");
      return '';
    }
  }

  Future<void> cropImage(Rx<File?> image, RxString imageBase64) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            activeControlsWidgetColor: AppColors.primary,
            toolbarTitle: 'Image Cropper',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio:CropAspectRatioPresetCustom9x6(),
              statusBarColor: AppColors.primary,
            lockAspectRatio: true,
            aspectRatioPresets: [CropAspectRatioPresetCustom9x6()],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [CropAspectRatioPresetCustom9x6()],
          ),
          WebUiSettings(
            context: Get.context!,
            presentStyle: WebPresentStyle.dialog,
          ),
        ],
      );

      if (croppedFile != null) {
        image.value = File(croppedFile.path);
        final compressedFile = await compressImage(imageFile: image.value!);
        final compressedFileAsFile = File(compressedFile.path);
        isErrorColor.value = false;
        final base64String = await convertFileToBase64(compressedFileAsFile);
        if (base64String.isNotEmpty) {
          print("Base64 Image: --->>>$base64String<<<-----");
          imageBase64.value = base64String;
        } else {
          print("Failed to convert image to Base64");
        }
      }
    }
  }

  Future<XFile> compressImage({
    required File imageFile,
    int quality = 25,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    log(imageFile.lengthSync().toString(), name: "Original size");
    try {
      final String targetPath = p.join(Directory.systemTemp.path, 'temp.${format.name}');
      final XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: quality,
        format: format,
      );

      if (compressedImage == null) {
        throw ("Failed to compress the image");
      }

      print("Compressed Image: ${compressedImage.path}");
      final compressedFile = File(compressedImage.path);
      log(compressedFile.lengthSync().toString(), name: "Compressed size");
      return compressedImage;
    } catch (e) {
      print("Error during image compression: $e");
      rethrow;
    }
  }

}