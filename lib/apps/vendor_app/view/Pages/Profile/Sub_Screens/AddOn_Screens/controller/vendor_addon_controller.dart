import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/Models/restaurant_get_addon_model.dart';
import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../vendor_common/Models/add_addon_model.dart';

class VendorAddonController extends GetxController{
  Rx<TextEditingController> requestAddOnController = TextEditingController().obs;
  Rx<TextEditingController> searchFieldController = TextEditingController().obs;
  RxString searchController = "".obs;
  RxList<Addons> searchListAddOn = RxList<Addons>([]);
  GlobalKey<FormState> addOnKey = GlobalKey<FormState>();
  // RxBool isRedClr = false.obs;


  @override
  void onInit() async  {
    await getAddOnApi();
    super.onInit();
  }



  final addAddOnData = AddAddOnModel().obs;
  void newAddOnSet(AddAddOnModel value) => addAddOnData.value = value;

  final rxAddAddOnRequestStatus = ApiStatus.COMPLETED.obs;
  void setNewAddOnRxRequestStatus(ApiStatus value) => rxAddAddOnRequestStatus.value = value;

  RxString errorNewAddOn = ''.obs;
  void setError(String value) => errorNewAddOn.value = value;



  final _api = Repository();

  newAddOnRequestApi(context, {required String name}) async {
    final data = {"name": name,};
    setNewAddOnRxRequestStatus(ApiStatus.LOADING);
    _api.newAddOnApi(data).then((value) {
      newAddOnSet(value);
      if (addAddOnData.value.status == true) {
        getAddOnApi();
        setNewAddOnRxRequestStatus(ApiStatus.COMPLETED);
        Utils.showToast(addAddOnData.value.message.toString());
        Get.back();
      } else {
        setNewAddOnRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(addAddOnData.value.message.toString(),bgColor: AppColors.red);
        print('Error: $errorNewAddOn');
      }
    }).onError((error, stackTrace) {
        setNewAddOnRxRequestStatus(ApiStatus.ERROR);
        // Utils.showToast(addAddOnData.value.message.toString());
        print('Error: $error');
      },
    );
  }



  final editAddOnData = AddAddOnModel().obs;
  void editAddOnSet(AddAddOnModel value) => editAddOnData.value = value;

  final rxEditAddOnRequestStatus = ApiStatus.COMPLETED.obs;
  void setEditAddOnRxRequestStatus(ApiStatus value) => rxEditAddOnRequestStatus.value = value;

  RxString errorEditAddOn = ''.obs;
  void setEditError(String value) => errorEditAddOn.value = value;

  editAddOnRequestApi({required String name, required String id}) async {
    final data = {"name": name, "id": id};
    setEditAddOnRxRequestStatus(ApiStatus.LOADING);
    _api.editAddOnApi(data).then((value)  {
      editAddOnSet(value);
      if (editAddOnData.value.status == true) {
        getAddOnApi();
        setEditAddOnRxRequestStatus(ApiStatus.COMPLETED);
        Get.back();
      } else {
        setEditAddOnRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(editAddOnData.value.message.toString(),bgColor: AppColors.red,);
        print('Error: $errorNewAddOn');
      }
    }).onError((error, stackTrace) {
      setEditAddOnRxRequestStatus(ApiStatus.ERROR);
      // Utils.showToast('Error: $error');
      print('Error: $error');
    },
    );
  }

  final rxRequestAddOnStatus = ApiStatus.COMPLETED.obs;
  RxString addOnError = ''.obs;
  final apiAddOnData = RestaurantGetAddOnModel().obs;
  void setRxRequestAddOnStatus(ApiStatus value) => rxRequestAddOnStatus.value = value;
  void addOnSetData(RestaurantGetAddOnModel value) => apiAddOnData.value = value;
  void setAddOnError(String value) => addOnError.value = value;

  Future<void> getAddOnApi() async {

    setRxRequestAddOnStatus(ApiStatus.LOADING);

    await _api.restaurantGetAddOnApi().then((value) {
      addOnSetData(value);
      if(apiAddOnData.value.status == true){
        setRxRequestAddOnStatus(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setAddOnError(error.toString());
      print(error);
      setRxRequestAddOnStatus(ApiStatus.ERROR);
    });
  }



  final rxRequestAddOnDeleteStatus = ApiStatus.COMPLETED.obs;
  RxString addOnDeleteError = ''.obs;
  final apiAddOnDeleteData = AddAddOnModel().obs;
  void setRxRequestAddOnDeleteStatus(ApiStatus value) => rxRequestAddOnDeleteStatus.value = value;
  void addOnSetDeleteData(AddAddOnModel value) => apiAddOnDeleteData.value = value;
  void setAddOnDeleteError(String value) => addOnDeleteError.value = value;

  Future<void> deleteAddOnApi(String id) async {
    final data = {"id": id};
    setRxRequestAddOnDeleteStatus(ApiStatus.LOADING);

    await _api.deleteAddOnApi(data).then((value) {
      addOnSetDeleteData(value);
      if(apiAddOnDeleteData.value.status == true){
        setRxRequestAddOnDeleteStatus(ApiStatus.COMPLETED);
        getAddOnApi();
        Get.back();
      } else{
        Utils.showToast(apiAddOnDeleteData.value.message.toString());
        setRxRequestAddOnDeleteStatus(ApiStatus.ERROR);
      }
    }).onError((error, stackError) {
      setAddOnDeleteError(error.toString());
      print(error);
      setRxRequestAddOnDeleteStatus(ApiStatus.ERROR);
    });
  }




}