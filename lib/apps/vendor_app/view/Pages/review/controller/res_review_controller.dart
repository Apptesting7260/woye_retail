import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/api_response.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Data/user_preference_controller.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../vendor_common/FileDownload/file_download_controller.dart';
import '../../../vendor_common/Models/common_export_model.dart';
import '../../../vendor_common/Models/common_response_model.dart';
import '../model/reviews_model.dart';
import '../subscreens/bulk_responds/model/get_bulk_review_res_model.dart';

class ResReviewController extends GetxController{

  FileDownloadController fileDownloadController = Get.put(FileDownloadController());

  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  GlobalKey<FormState> fromKeyExport = GlobalKey<FormState>();
  GlobalKey<FormState> fromKeySingleRes = GlobalKey<FormState>();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController responseController = TextEditingController();
  TextEditingController responseSingleReviewReplyController = TextEditingController();

  final _repo = Repository();
  RxString selectedRating = "".obs;
  RxString selectedRatingExport = "".obs;
  RxString selectedTime = "".obs;
  RxString selectedReview = "".obs;
  RxBool selectedIndex = false.obs;
  RxInt selectedTemplateIndex = (0).obs;
  RxString selectedTemplate = "".obs;
  RxString selectedDateRange = "".obs;
  RxString selectedTemplateSingleRes = "".obs;
  RxList<int> selectedReviews = <int>[].obs;

  RxInt selectedFormat = 0.obs;
  void toggleFormat(int index) {
    selectedFormat.value = index;
  }

  RxString userRole = "".obs;

  @override
  void onInit() async {
    userRole.value = await UserPreference.getUserRole();
    getReviews();
    super.onInit();
  }
  bool get isServiceStaff => userRole.value.replaceAll(" ", "").toLowerCase() == UserType.servicestaff.name;

  final Rx<ApiResponse<ReviewsModel>> _reviewsApiData = Rx<ApiResponse<ReviewsModel>>(ApiResponse.loading());
  Rx<ApiResponse<ReviewsModel>> get reviewsApiData => _reviewsApiData;
  setReviewApiData(ApiResponse<ReviewsModel> data){
    _reviewsApiData.value = data;
  }

  RxBool isFilterLoading = false.obs;

  Future<void> getReviews({bool showLoading = true,bool? isShowReviewCardShimmer = false})async{
    if(showLoading == true) {
      setReviewApiData(ApiResponse.loading());
    }
    if(isShowReviewCardShimmer == true){
    isFilterLoading.value = true;
    }
    Map<String, dynamic>? queryParameters = {
      if(selectedRating.isNotEmpty && selectedRating.value !=  "All Ratings")
      "rating": selectedRating.value.split(" ").first.toString(),
      if(selectedTime.isNotEmpty && selectedTime.value !=  "All Time")
      "time": selectedTime.value.toLowerCase().replaceAll(" ", "_"),
    };
    pt("queryParameters :  $queryParameters");
  _repo.getReviewsApiParams(queryParameters:queryParameters).then((value) {
      if(value.status == true){
        setReviewApiData(ApiResponse.completed(value));
      }else{
        setReviewApiData(ApiResponse.error(value.message.toString()));
      }
    isFilterLoading.value = false;
},).onError((error, stackTrace) {
      isFilterLoading.value = false;
      pt("error in reviews $error");
      setReviewApiData(ApiResponse.error(error.toString()));
    },);
  }

//------------------------------------reviewsPendingResponse
 final Rx<ApiResponse<GetBulkReviewResModel>> _reviewsPendingResponse = Rx<ApiResponse<GetBulkReviewResModel>>(ApiResponse.loading());
  Rx<ApiResponse<GetBulkReviewResModel>> get reviewsPendingResponse => _reviewsPendingResponse;
  setPendingResponseReviewApiData(ApiResponse<GetBulkReviewResModel> data){
    _reviewsPendingResponse.value = data;
  }

  Future<void> getReviewsPendingResponse({bool showLoading = true})async{
    if(showLoading == true) {
      setPendingResponseReviewApiData(ApiResponse.loading());
    }
  _repo.reviewsPendingResponse().then((value) {
      if(value.status == true){
        setPendingResponseReviewApiData(ApiResponse.completed(value));
      }else{
        setPendingResponseReviewApiData(ApiResponse.error(value.message.toString()));
      }
    },).onError((error, stackTrace) {
      pt("error in setPendingResponseReviewApiData $error");
      setPendingResponseReviewApiData(ApiResponse.error(error.toString()));
    },);
  }


//------------------------------------bulkReviewResponse
 final Rx<ApiResponse<CommonResponseModel>> _bulkReviewResApiData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get bulkReviewResApiData => _bulkReviewResApiData;
  setBulkReviewResponseApiData(ApiResponse<CommonResponseModel> data){
    _bulkReviewResApiData.value = data;
  }

  Future<void> bulkReviewResponse({bool showLoading = true})async{
    if(showLoading == true) {
      setBulkReviewResponseApiData(ApiResponse.loading());
    }

    var data = {
      "review_ids" : selectedReviews,
      "response" : responseController.text.isEmpty ? templateList[selectedTemplateIndex.value]['responsePre'] : responseController.text,
    };

    pt("data >>>>> $data");

  _repo.bulkReviewResponse(jsonEncode(data)).then((value) {
      if(value.status == true){
        setBulkReviewResponseApiData(ApiResponse.completed(value));
        getReviews(showLoading: false);
        if(responseController.text.isNotEmpty){
          responseController.clear();
        }
        Get.back();
      }else{
        setBulkReviewResponseApiData(ApiResponse.error(value.message.toString()));
      }
    },).onError((error, stackTrace) {
      pt("error in setPendingResponseReviewApiData $error");
      setBulkReviewResponseApiData(ApiResponse.error(error.toString()));
    },);
  }
//------------------------------------Single Review Response
 final Rx<ApiResponse<CommonResponseModel>> _singleReviewResApiData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get singleReviewResApiData => _singleReviewResApiData;
  setSingleReviewResponseApiData(ApiResponse<CommonResponseModel> data){
    _singleReviewResApiData.value = data;
  }

  Future<void> singleReviewResponse({bool showLoading = true,required String reviewId})async{
    if(showLoading == true) {
      setSingleReviewResponseApiData(ApiResponse.loading());
    }

    var data = {
      "review_id" : reviewId,
      "response" :responseSingleReviewReplyController.text,
    };

    pt("data >>>>> $data");

  _repo.singleReviewResponse(jsonEncode(data)).then((value) {
      if(value.status == true){
        setSingleReviewResponseApiData(ApiResponse.completed(value));
        getReviews(showLoading: false);
        Get.back();
      }else{
        setSingleReviewResponseApiData(ApiResponse.error(value.message.toString()));
      }
    },).onError((error, stackTrace) {
      pt("error in setSingleReviewResponseApiData $error");
      setSingleReviewResponseApiData(ApiResponse.error(error.toString()));
    },);
  }

  //------------------------------------review export
 final Rx<ApiResponse<CommonExportModel>> _reviewsExportApiData = Rx<ApiResponse<CommonExportModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonExportModel>> get reviewsExportApiData => _reviewsExportApiData;
  setReviewsExportApiData(ApiResponse<CommonExportModel> data){
    _reviewsExportApiData.value = data;
  }

  Future<void> reviewsExport({bool showLoading = true})async{
    if(showLoading == true) {
      setReviewsExportApiData(ApiResponse.loading());
    }

    var data ={
      "format" : selectedFormat.value == 0 ? "csv" : "excel",
      "date_range" : selectedDateRange.value == "All Time" ? selectedDateRange.value.toLowerCase().split(" ").first.toString() : selectedDateRange.value.toLowerCase().replaceAll(" ","_"),
      if(selectedDateRange.value == "Custom Range" && startDateController.text.isNotEmpty)
      "start_date" : convertDate(startDateController.text),
      if(selectedDateRange.value == "Custom Range" && endDateController.text.isNotEmpty)
      "end_date" : convertDate(endDateController.text),
      if(selectedRatingExport.value.isNotEmpty)
      "rating" : selectedRatingExport.value.toLowerCase().split(" ").first.toString(),
    };

    pt("data >>>>> $data");

  _repo.reviewsExportApi(jsonEncode(data)).then((value) {
      if(value.status == true){
        fileDownloadController.downloadAndSaveFile(
            value.downloadUrl ?? "",
            saveInDownload: true).then((val) {
              // Utils.showToast(value.message ?? "");
          setReviewsExportApiData(ApiResponse.completed(value));
        },);
      }else{
        Utils.showToast(value.message ?? "");
        setReviewsExportApiData(ApiResponse.error(value.message.toString()));
      }
    },).onError((error, stackTrace) {
      pt("error in setReviewsExportApiData $error");
      setReviewsExportApiData(ApiResponse.error(error.toString()));
    },);
  }

  String convertDate(String input) {
    final parts = input.split("/");
    return "${parts[2]}-${parts[0]}-${parts[1]}";
  }

  List<Color> ratingBarColor = [AppColors.greenClrRatingBar,AppColors.greenLightClr,AppColors.goldStar.withAlpha(200),AppColors.yellow,AppColors.red,];
  List<double> ratingValue = [0.8,0.5,0.5,0.3,0.2];

  final List<String> iconList = [ImageConstants.starLogo,ImageConstants.messages,ImageConstants.share,ImageConstants.alertSvgLogo];
  List<Color> cardColor = [AppColors.yellowClr,AppColors.blueClr,AppColors.greenClr,AppColors.orange,];
  List<Color> ratingCardColor = [AppColors.greenClr,AppColors.blueTextColor,AppColors.purpleColor];
  List<String> cardTitle = ["Overall Rating","Total Reviews","Response Rate","Pending Responses"];
  List<String> cardSubTitle = ["4.8","1,247","89%","12"];
  List<String> rating = ["All Ratings","5 Stars","4 Stars","3 Stars","2 Stars","1 Stars"];
  List<String> time = ["All Time","This Week","Last Week","This Month","Last Month"];
  List<String> review = ["All Reviews","Food Quality","Service","Ambiance","Value"];
  List<String> dateRangeList = ["All Time","Today","Yesterday","This Week","Last Week","This Month","Last Month","Custom Range"];
  List<String> responseBestPracticeList = ["Thank the customer for their feedback","Express appreciation for their positive experience",
    "Maintain professional medical privacy standards","Invite them to return","Keep responses concise and authentic"];
  List<Map<String ,dynamic>> templateList = [
    {"title":"Positive Reviews (4-5 stars)","responsePre":"Thank you for your wonderful review! We're delighted that you enjoyed your dining experience with us. Your feedback means the world to our team, and we look forward to welcoming you back soon."},
    {"title":"Neutral Reviews (3 stars)","responsePre":"Thank you for taking the time to review your experience with us. We appreciate your feedback and are always working to improve our service and food quality. We hope to see you again soon."},
    {"title":"Negative Reviews (1-2 stars)","responsePre":"Thank you for your feedback. We sincerely apologize that your experience didn't meet your expectations. We take all feedback seriously and would love the opportunity to make things right. Please contact us directly so we can address your concerns."},
    {"title":"Custom Response","responsePre":""}
  ];


  List<Map<String, dynamic>> templateListSingleRes = [
    {
      "title": "Choose a template or write custom response",
      "responsePre":
      "Dear {customer_name},\n\nThank you so much for your wonderful 5-star review! We're thrilled to hear you enjoyed your meal.\n\nBest regards,\n{res_type}"
    },
    {
      "title": "Thank You - Positive",
      "responsePre":
      "Dear {customer_name},\n\nWe truly appreciate your kind words and positive feedback.\n\nBest regards,\n{res_type}"
    },
    {
      "title": "Apologetic - Negative",
      "responsePre":
      "Dear {customer_name},\n\nThank you for bringing this to our attention. We’re sorry your experience wasn’t great.\n\nSincerely,\n{res_type}"
    },
  ];

  DateTime parseDate(String date) {
    return DateFormat("MM/dd/yyyy").parse(date);
  }

  GlobalKey overAllRatingKey = GlobalKey();

  scrollToFields(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.01
      );
    }
  }

}