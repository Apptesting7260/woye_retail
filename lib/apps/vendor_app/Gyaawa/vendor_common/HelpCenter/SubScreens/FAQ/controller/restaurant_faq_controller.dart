import 'package:get/get.dart';
import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Data/user_preference_controller.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../Models/faq_privacy_term_condition_model.dart';

class RestaurantFAQController extends GetxController {

  RxString loginType = "".obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    // getPages();
    loginType.value = await UserPreference.getLoginType();
    pt("loginType >>>>> $loginType");
    super.onInit();
  }

  final api = Repository();
  RxString error = "".obs;
  final apiData = GetPagesModel().obs;
  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  void rxRequestStatusSet(ApiStatus value) => rxRequestStatus.value = value;
  void setApiData(GetPagesModel value) => apiData.value = value;
  void setError(String value) => error.value = value;


  RxString selectedCategory = "".obs;

    getPages(){
      rxRequestStatusSet(ApiStatus.LOADING);
    api.getFaqPrivacyTc().then((value){

      setApiData(value);
      if(apiData.value.status == true){
        rxRequestStatusSet(ApiStatus.COMPLETED);
        if( value.faqs?.isNotEmpty ?? false) {
          selectedCategory.value = value.faqs?.first.category ?? "";
        }
      }else{
        rxRequestStatusSet(ApiStatus.ERROR);
        setError(value.message ?? "");
      }
    }).onError((error, stackTrace) {
      rxRequestStatusSet(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        print('Error: $error');
      },
    );
  }

  String format(String string) {
    String  plainText =string.replaceAllMapped(RegExp(r'(\d+\.)(?=\s)'), (match) {
      return '\n\n${match.group(0)}';
    });
    return plainText;
  }
}
