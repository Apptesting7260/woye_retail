import 'package:get/get.dart';

import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../EditProduct/Model/res_single_product_model.dart';


class ProductDetailsController extends GetxController {
  List productTitle = [
    "Category",
    "Regular Price",
    "Size",
    "Ingredients",
    "Add On",
    "Discount",
    "Status"
  ];
  List productSubTitle = [
    "Pizza",
    "\$20.00",
    "Small, Medium, Large ",
    "White Base, Cheese Burst, Wheat...",
    "Capsicum, Tomato, Onion, Extra...",
    "10%",
    "Active",
  ];

  RxString productId = ''.obs;

  @override
  void onInit() {
    productId.value = Get.arguments ?? '';
      getSingleProductApi(productId: productId.value);
    super.onInit();
  }

  final rxRequestSingleProductStatus = ApiStatus.COMPLETED.obs;
  final apiSingleProductData = ResSingleProductModel().obs;
  void singleProductSetData(ResSingleProductModel value) => apiSingleProductData.value = value;
  void setRxSingleProductStatus(ApiStatus value) => rxRequestSingleProductStatus.value = value;
  final api = Repository();
  RxString error = ''.obs;
  void setError(String value) => error.value = value;

  Future<void> getSingleProductApi({required String productId}) async {
    final data = {"product_id": productId};
    setRxSingleProductStatus(ApiStatus.LOADING);
    api.getSingleProductsApi(data).then((value) async {
      singleProductSetData(value);
      setRxSingleProductStatus(ApiStatus.COMPLETED);
    }
    ).onError((error, stackError) {
      setError(error.toString());
      print("error>>>>>>>>>>>>> $error");
      setRxSingleProductStatus(ApiStatus.ERROR);
    });
  }
}
