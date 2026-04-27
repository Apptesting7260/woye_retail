import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/common_response_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/user_preference_controller.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../model/create_support_model.dart';
import '../model/restaurant_get_support_model.dart';

class RestaurantSupportController extends GetxController{

  RxInt currentIndex = 0.obs;

  GlobalKey<FormState> createKey = GlobalKey<FormState>();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey categoryKey = GlobalKey();
  GlobalKey priorityKey = GlobalKey();

  void scrollToFields(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(
          context,
        alignment: 0.05,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  RxList<AllTickets> filterList = RxList<AllTickets>([]);

  // RxBool isRedClr = false.obs;

  List<Map<String,dynamic>> supportList = [
    {"image":ImageConstants.chat,"title":"Live Chat","des": "Chat with our restaurant support team in real-time","btnName":"Start Chat","color":AppColors.blueClr },
    {"image":ImageConstants.emailClr,"title":"Email Support","des":"Send us an email and we'll respond within 24 hours","btnName":"Send Email","color":AppColors.greenClr },
    {"image":ImageConstants.callFiled,"title":"Phone Support","des":"Call us for immediate restaurant assistance","btnName":"Call Now","color":AppColors.purpleColor }
  ];

  List<String> supportListGrocery = [
   "Chat with our store support team in real-time",
   "Send us an email and we'll respond within 24 hours",
   "Call us for immediate store assistance",
  ];

  List<String> supportListPharmacy = [
     "Chat with our pharmacy support team in real-time",
     "Send us an email for non-urgent pharmacy issues",
     "Call for urgent pharmacy assistance",
    ];

  RxString selectedCategory = "".obs;
  RxString selectedPriority = "".obs;
  List<String> categoryList = ["Technical Issue","Menu Management","Order Processing","Payment Issues","Account Settings","Training and Support","Other",];
  List<String> priorityList = ["Low","Medium","High","Urgent"];

  RxString loginType = "".obs;

  @override
  void onInit() async {
    loginType.value = await UserPreference.getLoginType();
    pt("logntype >>>>> $loginType");
    await getSupportApi();
    super.onInit();
  }


  Repository api = Repository();

  // final rxRequestSupportStatus = Status.COMPLETED.obs;
  // void setRxRequestSupportStatus(Status value) => rxRequestSupportStatus.value = value;
  Rx<ApiResponse<RestaurantGetSupportModel>> supportData = Rx<ApiResponse<RestaurantGetSupportModel>>(ApiResponse.loading());
  

  // RxString supportError = ''.obs;
  // void setCategoryError(String value) => supportError.value = value;

  // final apiSupportData = RestaurantGetSupportModel().obs;
  // void supportSetData(RestaurantGetSupportModel value) => apiSupportData.value = value;


  Future<void> getSupportApi() async {

    // setRxRequestSupportStatus(Status.LOADING);
    supportData.value = ApiResponse.loading();
    
    api.gatSupportApi().then((value) {
      // supportSetData(value);
      if(value.status == true){

        supportData.value = ApiResponse.completed(value);
        // setRxRequestSupportStatus(Status.COMPLETED);
      }else{
        supportData.value = ApiResponse.error("get support error");
        // print(supportError);
        // setRxRequestSupportStatus(Status.ERROR);
      }
    }).onError((error, stackError) {
      // setCategoryError(error.toString());
      print(error);
      supportData.value = ApiResponse.error(error.toString());
      // setRxRequestSupportStatus(Status.ERROR);
    });
  }


  final createSupportData = CommonResponseModel().obs;
  void createSupportSet(CommonResponseModel value) => createSupportData.value = value;

  final rxCreateSupportStatus = ApiStatus.COMPLETED.obs;
  void setCreateSupportStatus(ApiStatus value) => rxCreateSupportStatus.value = value;

  RxString errorCreateSupport = ''.obs;
  void setError(String value) => errorCreateSupport.value = value;

  RxBool isError = false.obs;

  createSupportApi() async {
    Map<String, String>? fields = {
      "category": selectedCategory.value.toLowerCase().replaceAll(" ", "_"),
      "priority": selectedPriority.value.toLowerCase(),
      "subject":subjectController.value.text,
      "description":descriptionController.value.text
    };
    Map<String, File> files = {};

    for (int i = 0; i < pickedFiles.length; i++) {
        files["attachment[]=@"] = pickedFiles[i];
        pt(pickedFiles[i].path.toString());
    }

    pt(fields.toString());


    setCreateSupportStatus(ApiStatus.LOADING);
    api.supportTicketCreate(files: files,fields:fields).then((value) {
      createSupportSet(value);
      if (createSupportData.value.status == true) {
        setCreateSupportStatus(ApiStatus.COMPLETED);
        Utils.showToast(createSupportData.value.message.toString());
        selectedCategory.value = "";
        selectedPriority.value = "";
        subjectController.text = "";
        descriptionController.text = "";
        pickedFiles.clear();
        isError.value = false;

      } else {
        setCreateSupportStatus(ApiStatus.ERROR);
        Utils.showToast(createSupportData.value.message.toString(),bgColor: AppColors.red);
        print('Error: $errorCreateSupport');
      }
    }).onError((error, stackTrace) {
      setCreateSupportStatus(ApiStatus.ERROR);
      Utils.showToast(createSupportData.value.message.toString());
      print('Error: $error');
    },
    );
  }


  //-----------------images and pdf
  Rx<File?> image = Rx<File?>(null);
  RxString imageBase64 = "".obs;
  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;
  RxBool isErrorColor = false.obs;
  RxList<File> pickedFiles = <File>[].obs;

  Future<void> pickImage(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        for (var file in result.files) {
          if (file.path == null) continue;

          // Validate size (10MB)
          if (file.size > 10 * 1024 * 1024) {
            Utils.showToast(
              'Image too large - must be less than 10MB',
              bgColor: AppColors.red,
            );
            continue;
          }

          // DIRECTLY process image (no cropping)
          await _processImage(File(file.path!));
        }

        update();
      }
    } catch (e) {
      print("Error picking file: $e");
      Utils.showToast('Failed to pick image', bgColor: AppColors.red);
    }
  }

  Future<void> _processImage(File imageFile) async {
    _pickedFile = XFile(imageFile.path);

    // Compress directly (no cropping)
    final compressedXFile = await compressImage(imageFile: imageFile);
    File compressed = File(compressedXFile.path);

    pickedFiles.add(compressed);

    print("Added image: ${compressed.path}");
  }

  Future<XFile> compressImage({
    required File imageFile,
    int quality = 25,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    pt(imageFile.lengthSync().toString(), name: "Original size");

    try {
      final String targetPath =
      p.join(Directory.systemTemp.path, 'temp.${format.name}');
      final XFile? compressedImage =
      await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: quality,
        format: format,
      );

      if (compressedImage == null) {
        throw ("Failed to compress the image");
      }

      pt("Compressed Image: ${compressedImage.path}");
      final compressedFile = File(compressedImage.path);
      pt(compressedFile.lengthSync().toString(), name: "Compressed size");

      return compressedImage;
    } catch (e) {
      pt("Error during image compression: $e");
      rethrow;
    }
  }


}