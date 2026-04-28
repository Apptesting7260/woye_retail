import 'package:get/get.dart';
import 'package:gyaawa/Data/response/api_response.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../Products/Sub_screen/EditProduct/Model/res_single_product_model.dart';

class RestaurantMenuItemDetailsController extends GetxController{

  final repo = Repository();

  RxString productId = "".obs;

  @override
  void onInit() {
    productId.value = Get.arguments;
    getSingleProductApi(productId:productId.value);
    print("✅ onInit called with arguments: ${Get.arguments}");
    super.onInit();
  }

  final Rx<ApiResponse<ResSingleProductModel>> _apiData = ApiResponse<ResSingleProductModel>.completed(null).obs;
  Rx<ApiResponse<ResSingleProductModel>> get apiData => _apiData;
  setProductDetailsApiData(ApiResponse<ResSingleProductModel> response)=> _apiData.value = response;
  RxString error = ''.obs;
  void setError(String value) => error.value = value;

  Future<void> getSingleProductApi({bool isShowLoading = true,required String productId})async{
    if(isShowLoading == true) {
      setProductDetailsApiData(ApiResponse.loading());
    }
    final data = {"product_id": productId};
    try{
      await repo.getSingleProductsApi(data).then((value) {
        if(value.status == true){
          setProductDetailsApiData(ApiResponse.completed(value));
        }else if(value.status == false){
          setProductDetailsApiData(ApiResponse.completed(value));
          if(value.message == "Product not found!"){
            Utils.showToast(value.message ?? "");
            Get.back();
          }
          pt("product list setProductDetailsApiData..... ${value.message}");
          setError(value.message);
        }else{
          setProductDetailsApiData(ApiResponse.error(value.message));
          pt("Error product setProductDetailsApiData api ${value.message}");
          setError(value.message);
        }
      },
      );
    }catch(e,s){
      pt("Error getting product setProductDetailsApiData api $e $s");
      setProductDetailsApiData(ApiResponse.error(e.toString()));
      setError(e.toString());
    }
  }

}