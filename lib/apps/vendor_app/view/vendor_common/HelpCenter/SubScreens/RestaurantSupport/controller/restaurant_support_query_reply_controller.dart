import 'dart:developer';
import 'dart:io';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/HelpCenter/SubScreens/RestaurantSupport/controller/restaurant_support_controller.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http ;
import '../../../../../../../../../Core/Constant/app_urls.dart';
import '../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../Models/support_chat_model.dart';
import '../../../../Models/support_chat_reply_model.dart';

class SupportQuarryController extends GetxController {
  RxBool isReply = true.obs;

  String ticketId = '';
  String title = '';

  TextEditingController replyController = TextEditingController();
  ScrollController scrollController = ScrollController();

  final RestaurantSupportController restaurantSupportController = Get.put(RestaurantSupportController());



  @override
  void onInit() {
    final arguments = Get.arguments as Map;
    ticketId = arguments['ticketId'];
    title = arguments['title'];
    log(ticketId);
    supportChatApi(ticketId);
    super.onInit();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 80),
      curve: Curves.easeInOut,
    );
  }


  final _api = Repository();

  final supportChatData = SupportChatModel().obs;
  void supportChatDataSet(SupportChatModel value) => supportChatData.value = value;

  final rxSupportChatRequestStatus = ApiStatus.COMPLETED.obs;
  void setSupportChatStatus(ApiStatus value) => rxSupportChatRequestStatus.value = value;

  RxString errorSupportChat = ''.obs;
  void setError(String value) => errorSupportChat.value = value;

  supportChatApi(String ticketId) async {
    final data = {
      "ticket_id": ticketId,
    };
    setSupportChatStatus(ApiStatus.LOADING);
    _api.supportChatApi(data).then((value) {
      supportChatDataSet(value);
      if (supportChatData.value.status == true) {
        setSupportChatStatus(ApiStatus.COMPLETED);
        // Future.delayed(const Duration(seconds: 1),() {
        //   scrollToBottom();
        //   log("Scroll to bottom");
        // }, );
        // scrollToBottom();
        // log(value);
      } else {
        setSupportChatStatus(ApiStatus.ERROR);
        debugPrint('Error: $errorSupportChat');
      }
    }).onError((error, stackTrace) {
      setSupportChatStatus(ApiStatus.ERROR);
      setError(error.toString());
      debugPrint('Error: $error');
    },
    );

  }


  final supportChatReplyData = SupportChatReplyModel().obs;
  void supportChatReplyDataSet(SupportChatReplyModel value) => supportChatReplyData.value = value;

  final rxSupportChatReplyRequestStatus = ApiStatus.COMPLETED.obs;
  void setSupportChatReplyStatus(ApiStatus value) => rxSupportChatReplyRequestStatus.value = value;

  RxString errorSupportChatReply = ''.obs;
  void setErrorReply(String value) => errorSupportChatReply.value = value;

  // Future<void> supportChatWithImageReplyApi( List<File> images) async {
  //   final data = {
  //     "ticket_id": ticketId,
  //     "message": replyController.text,
  //   };
  //
  //   List<http.MultipartFile> imageFiles = [];
  //   for (var image in images) {
  //     var multipartFile = await http.MultipartFile.fromPath('images[]', image.path);
  //     imageFiles.add(multipartFile);
  //   }
  //
  //   setSupportChatReplyStatus(Status.LOADING);
  //   try {
  //     dynamic response = await _api.supportChatReplyApi(data,  imageFiles);
  //     supportChatReplyDataSet(SupportChatReplyModel.fromJson(response));
  //     if (supportChatReplyData.value.status == true) {
  //       setSupportChatReplyStatus(Status.COMPLETED);
  //       refreshSupportChatApi(ticketId);
  //       replyController.clear();
  //     } else {
  //       setSupportChatReplyStatus(Status.ERROR);
  //       debugPrint('Error: ${errorSupportChatReply.value}');
  //     }
  //   } catch (error) {
  //     setSupportChatReplyStatus(Status.ERROR);
  //     setErrorReply(error.toString());
  //     debugPrint('Error: $error');
  //   }
  // }


  refreshSupportChatApi(String ticketId) async {
    final data = {
      "ticket_id": ticketId,
    };
    _api.supportChatApi(data).then((value) {
      supportChatDataSet(value);
      if (supportChatData.value.status == true) {
        // Future.delayed(const Duration(seconds: 1),() {
        //   scrollToBottom();
        // }, );

        // log(value);
      } else {
        setSupportChatStatus(ApiStatus.ERROR);
        debugPrint('Error: $errorSupportChat');
      }
    }).onError((error, stackTrace) {
      setSupportChatStatus(ApiStatus.ERROR);
      setError(error.toString());
      debugPrint('Error: $error');
    },
    );

  }

  final ImagePicker picker = ImagePicker();
  List<XFile> imageXFiles = [];
  RxList<File> imageFiles = RxList<File>([]);

  Future<void> imagePicker()async {
    imageXFiles = await picker.pickMultiImage(limit: 4, imageQuality: 50,);

    if (imageXFiles.isNotEmpty) {
      // XFile list ko File list me convert karna
      imageFiles.value = imageXFiles.map((xFile) => File(xFile.path)).toList();

      // Converted Files ka path print karna
      for (var file in imageFiles) {
        debugPrint("Converted File Path: ${file.path}");
      }
    }
  }


  final markAsClosedChatData = SupportChatReplyModel().obs;
  void markAsClosedChatDataSet(SupportChatReplyModel value) => markAsClosedChatData.value = value;

  final rxMarkAsClosedChatRequestStatus = ApiStatus.COMPLETED.obs;
  void setMarkAsClosedChatStatus(ApiStatus value) => rxMarkAsClosedChatRequestStatus.value = value;

  RxString errorMarkAsClosedChat = ''.obs;
  void setErrorMarkAsClosed(String value) => errorMarkAsClosedChat.value = value;

  markAsClosedChatApi(String ticketId) async {
    final data = {
      "ticket_id": ticketId,
    };
    setMarkAsClosedChatStatus(ApiStatus.LOADING);
    _api.markAsClosedChatApi(data).then((value) {
      markAsClosedChatDataSet(value);
      if (markAsClosedChatData.value.status == true) {
        setMarkAsClosedChatStatus(ApiStatus.COMPLETED);
        restaurantSupportController.getSupportApi();
        Get.back();
        Utils.showToast("You closed this chat session");
      } else {
        setMarkAsClosedChatStatus(ApiStatus.ERROR);
        debugPrint('Error: $errorSupportChat');
      }
    }).onError((error, stackTrace) {
      setMarkAsClosedChatStatus(ApiStatus.ERROR);
      setErrorMarkAsClosed(error.toString());
      debugPrint('Error: $error');
    },
    );

  }




  Future<void> supportChatWithImageReplyApi() async {
    setSupportChatReplyStatus(ApiStatus.LOADING);
    var headers = {
      'Authorization': 'Bearer ${_api.token}'
    };

    var request = http.MultipartRequest('POST', Uri.parse(AppUrls.supportChatReplyUrl));

    request.fields.addAll({
      'ticket_id': ticketId,
      'message': replyController.text.trim(),
    });

    debugPrint("Sending Request: ${request.fields}");

    // Image files ko request me add karna
    for (var imageFile in imageFiles) {
      request.files.add(await http.MultipartFile.fromPath('images[]', imageFile.path));
    }
    print(request.files.toString());

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint("Response: ${await response.stream.bytesToString()}");
      setSupportChatReplyStatus(ApiStatus.COMPLETED);
      await refreshSupportChatApi(ticketId);
      replyController.clear();
      imageFiles.value = [];
      // Future.delayed(const Duration(microseconds: 5000),() {
      //   scrollToBottom();
      //   log("Scroll to bottom");
      // }, );
    } else {
      setSupportChatReplyStatus(ApiStatus.ERROR);
      debugPrint("Error: ${response.reasonPhrase}");
    }
  }

  //-------------------Image downLoad------------------------
  final rxDownloadImageRequestStatus = ApiStatus.COMPLETED.obs;
  void setDownloadImageRequestStatus(ApiStatus value) => rxDownloadImageRequestStatus.value = value;
  final RxList<bool> loadingList = <bool>[].obs;

  Future<List<String>> downloadAndSaveImages(List<String> imageUrls, {bool saveInDownload = true}) async {
    loadingList.assignAll(List.generate(imageUrls.length, (_) => false));
    List<String> savedPaths = [];

    setDownloadImageRequestStatus(ApiStatus.LOADING);
    if(rxDownloadImageRequestStatus.value == ApiStatus.LOADING){
      Utils.showToast("Downloading...");
    }
    for (int i = 0; i < imageUrls.length; i++) {
      loadingList[i] = true;
      try {
        final String? savedPath = await downloadAndSaveImage(imageUrls[i], saveInDownload: saveInDownload);
        if (savedPath != null) {
          savedPaths.add(savedPath);
        }
      } catch (e) {
        debugPrint("Error downloading image: $e ❌");
      }
      loadingList[i] = false;
    }

    if (savedPaths.isNotEmpty) {
      Utils.showToast("${savedPaths.length} images downloaded successfully");
      debugPrint("${savedPaths.length} images downloaded successfully");
      debugPrint("saveInDownload : $saveInDownload");
      setDownloadImageRequestStatus(ApiStatus.COMPLETED);
    } else {
      Utils.showToast("Failed to download images ");
      debugPrint("Failed to download images ");
      setDownloadImageRequestStatus(ApiStatus.ERROR);
    }

    return savedPaths;
  }


  Future<String?> downloadAndSaveImage(String imageUrl, {bool saveInDownload = true}) async {
    try {
      final Directory targetDir = saveInDownload
          ? Directory('/storage/emulated/0/Download')
          : Directory('/storage/emulated/0/DCIM/Woye');

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
      final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(targetDir.path, fileName);
      final http.Response response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        debugPrint("Image downloaded successfully ✅");

        return file.path;
      } else {
        debugPrint("Failed to download image ❌");
        return null;
      }
    } catch (e) {
      debugPrint("Error downloading image: $e ❌");
      return null;
    }
  }

}
