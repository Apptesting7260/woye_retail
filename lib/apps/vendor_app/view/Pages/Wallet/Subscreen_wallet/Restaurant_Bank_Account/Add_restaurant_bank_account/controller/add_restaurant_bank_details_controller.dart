// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:woye_vendor_app/Core/Utils/snack_bar.dart';
// import 'package:woye_vendor_app/Data/Repository/repository.dart';
// import 'package:woye_vendor_app/Payment/model/all_bank_data_model.dart';
// import 'package:woye_vendor_app/presentation/Restaurant/Pages/Wallet/Subscreen_wallet/Restaurant_Bank_Account/Add_restaurant_bank_account/model/add_bank_account_model.dart';
// import 'package:woye_vendor_app/presentation/Restaurant/Pages/Wallet/Subscreen_wallet/Restaurant_Bank_Account/Restaurant_bank_account_details/controller/restaurant_bank_account_details_controller.dart';
// import 'package:woye_vendor_app/presentation/Restaurant/Pages/Wallet/Subscreen_wallet/Restaurant_Bank_Account/Restaurant_bank_account_details/model/get_single_bank_account_details_model.dart';
// import 'package:woye_vendor_app/shared/theme/colors.dart';
//
// import '../../../../../../../../Data/response/status.dart';
// import '../model/delete_bank_account_model.dart';
//
// class AddRestaurantBankDetailsController extends GetxController {
//
//   final RestaurantBankAccountDetailsController restaurantBankAccountDetailsController = Get.put(RestaurantBankAccountDetailsController());
//
//   RxString bankId =  ''.obs;
//   GlobalKey<FormState> addBankFormKey = GlobalKey<FormState>();
//   // Rx<TextEditingController> bankNameController = TextEditingController().obs;
//   Rx<TextEditingController> accountHolderNameController = TextEditingController().obs;
//   Rx<TextEditingController> accountNumberController = TextEditingController().obs;
//   Rx<TextEditingController> confirmAccountNumberController = TextEditingController().obs;
//   Rx<TextEditingController> ifscController = TextEditingController().obs;
//
//   var bankName = Rxn<String>();
//
//
//   // RxList<String> accountType = ['Saving', 'Current', "Business"].obs;
//   // RxList<String> status = ['Active', 'Inactive'].obs;
//   var selectedAccount = Rxn<String>();
//   // var selectedStatus = Rxn<String>();
//
//
//   @override
//   void onInit()async {
//     // TODO: implement onInit
//     // bankId.value = Get.arguments ?? '';
//     // if(bankId.value.isNotEmpty || bankId.value != ''){
//     //   getSingleBankAccountApi();
//     // }
//     allBanksApi();
//     super.onInit();
//   }
//
// //------------------------Add Bank Details --------------------------------------------------
//   final _api = Repository();
//   final addBankAccountData = AddBankAccountModel().obs;
//   void addBankAccountSet(AddBankAccountModel value) => addBankAccountData.value = value;
//   final rxAddBankAccountRequestStatus = ApiStatus.COMPLETED.obs;
//   void setAddBankAccountRxRequestStatus(ApiStatus value) => rxAddBankAccountRequestStatus.value = value;
//   RxString errorAddBankAccount = ''.obs;
//   void setError(String value) => errorAddBankAccount.value = value;
//
//   addBankAccountApi() async {
//     final data = {
//       "bankname": bankName.value,
//       "ac_holder_name": accountHolderNameController.value.text,
//       "ac_number": accountNumberController.value.text,
//       "ac_type": selectedAccount.value?.toLowerCase(),
//       "bank_code": ifscController.value.text,
//       // "primary_status": selectedStatus.value,
//     };
//     setAddBankAccountRxRequestStatus(ApiStatus.LOADING);
//     _api.addBankAccountApi(data).then((value) {
//       addBankAccountSet(value);
//       if (addBankAccountData.value.status == true) {
//         setAddBankAccountRxRequestStatus(ApiStatus.COMPLETED);
//         Utils.showToast(addBankAccountData.value.message.toString());
//         restaurantBankAccountDetailsController.getSingleBankAccountDetailsApi(isRefresh: true);
//         Get.back();
//       bankName.value = "";
//       accountHolderNameController.value.clear();
//       accountNumberController.value.clear();
//       confirmAccountNumberController.value.clear();
//       selectedAccount.value = '';
//       ifscController.value.clear();
//       } else if(addBankAccountData.value.status == false) {
//         setAddBankAccountRxRequestStatus(ApiStatus.COMPLETED);
//         Utils.showToast(addBankAccountData.value.message.toString(),bgColor: AppColors.black);
//         print('Error: $errorAddBankAccount');
//       }
//     }).onError((error, stackTrace) {
//       setAddBankAccountRxRequestStatus(ApiStatus.ERROR);
//       setError(error.toString());
//       // Utils.showToast(addAddOnData.value.message.toString());
//       print('Error: $error');
//     },
//     );
//
//   }
// //------------------------get single Bank Details --------------------------------------------------
// //   final singleBankAccountData = GetSingleBankAccountDetailsModel().obs;
// //   void singleBankAccountSet(GetSingleBankAccountDetailsModel value) => singleBankAccountData.value = value;
// //   final rxSingleBankAccountRequestStatus = ApiStatus.COMPLETED.obs;
// //   void setSingleBankAccountRxRequestStatus(ApiStatus value) => rxSingleBankAccountRequestStatus.value = value;
// //
// //   getSingleBankAccountApi() async {
// //     final data = {
// //       "bank_id": bankId.value,
// //     };
// //     setSingleBankAccountRxRequestStatus(ApiStatus.LOADING);
// //     _api.getSingleBankAccountDetailsApi(data).then((value) {
// //       singleBankAccountSet(value);
// //       if (singleBankAccountData.value.status == true) {
// //         // bankNameController.value.text = singleBankAccountData.value.account?.bankname.toString() ?? "";
// //         bankName.value = singleBankAccountData.value.account?.bankname.toString() ?? "";
// //         accountHolderNameController.value.text = singleBankAccountData.value.account?.acHolder.toString() ?? "";
// //         accountNumberController.value.text = singleBankAccountData.value.account?.acNo.toString() ?? "";
// //         confirmAccountNumberController.value.text = singleBankAccountData.value.account?.acNo.toString() ?? "";
// //         selectedAccount.value = singleBankAccountData.value.account?.acType;
// //         // selectedStatus.value = singleBankAccountData.value.account?.primaryStatus;
// //         ifscController.value.text = singleBankAccountData.value.account?.ifsc.toString() ?? "";
// //         setSingleBankAccountRxRequestStatus(ApiStatus.COMPLETED);
// //       }
// //     }).onError((error, stackTrace) {
// //       setSingleBankAccountRxRequestStatus(ApiStatus.ERROR);
// //       setError(error.toString());
// //       // Utils.showToast(addAddOnData.value.message.toString());
// //       print('Error: $error');
// //     },
// //     );
// //   }
//
// //------------------------Update Bank Details --------------------------------------------------
// //   final updateBankAccountData = AddBankAccountModel().obs;
// //   void updateBankAccountSet(AddBankAccountModel value) => updateBankAccountData.value = value;
// //   final rxUpdateBankAccountRequestStatus = ApiStatus.COMPLETED.obs;
// //   void setUpdateBankAccountRxRequestStatus(ApiStatus value) => rxUpdateBankAccountRequestStatus.value = value;
// //
// //   updateBankAccountApi() async {
// //     final data = {
// //       "bank_id": bankId.value,
// //       "bankname": bankName.value,
// //       // "bankname": bankNameController.value.text,
// //       "ac_holder_name": accountHolderNameController.value.text,
// //       "ac_number": accountNumberController.value.text,
// //       "ac_type": selectedAccount.value,
// //       "ifsc": ifscController.value.text,
// //       // "primary_status":selectedStatus.value,
// //     };
// //     setUpdateBankAccountRxRequestStatus(ApiStatus.LOADING);
// //     _api.updateBankAccountDetailsApi(data).then((value) {
// //       updateBankAccountSet(value);
// //       if (updateBankAccountData.value.status == true) {
// //         setUpdateBankAccountRxRequestStatus(ApiStatus.COMPLETED);
// //         Utils.showToast(updateBankAccountData.value.message.toString());
// //         restaurantBankAccountDetailsController.getBankAccountApi();
// //         Get.back();
// //       } else {
// //         setUpdateBankAccountRxRequestStatus(ApiStatus.ERROR);
// //         Utils.showToast(updateBankAccountData.value.message.toString(),bgColor: AppColors.black);
// //       }
// //     }).onError((error, stackTrace) {
// //       setUpdateBankAccountRxRequestStatus(ApiStatus.ERROR);
// //       setError(error.toString());
// //       // Utils.showToast(addAddOnData.value.message.toString());
// //       print('Error111: $error');
// //     },
// //     );
// //
// //   }
// //
//
// //------------------------Delete Bank Details --------------------------------------------------
//
//   final deleteBankAccountData = DeleteBankResponse().obs;
//   void deleteBankAccountSet(DeleteBankResponse value) => deleteBankAccountData.value = value;
//   final rxAccountRequestStatusDelete = ApiStatus.COMPLETED.obs;
//   void setAccountRxRequestStatusDelete(ApiStatus value) => rxAccountRequestStatusDelete.value = value;
//
//   deleteBankAccountApi({required String bankId}) async {
//     final data = {
//       "bank_id": bankId,
//     };
//     setAccountRxRequestStatusDelete(ApiStatus.LOADING);
//     _api.deleteBankAccountDetailsApi(data).then((value) {
//       deleteBankAccountSet(value);
//       if (deleteBankAccountData.value.status == true) {
//         setAccountRxRequestStatusDelete(ApiStatus.COMPLETED);
//         Utils.showToast(deleteBankAccountData.value.message.toString());
//         restaurantBankAccountDetailsController.getSingleBankAccountDetailsApi(isRefresh: true);
//         Get.back();
//       } else {
//         setAccountRxRequestStatusDelete(ApiStatus.ERROR);
//         Utils.showToast(deleteBankAccountData.value.message.toString(),bgColor: AppColors.black);
//       }
//     }).onError((error, stackTrace) {
//       setAccountRxRequestStatusDelete(ApiStatus.ERROR);
//       setError(error.toString());
//       // Utils.showToast(addAddOnData.value.message.toString());
//       print('Error111: $error');
//     },
//     );
//
//   }
//
//
//   //--------------------------------------------------------All banks api
//
//   Rx<ApiStatus> rxRequestStatus = ApiStatus.COMPLETED.obs;
//   void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;
//
//   Rx<AllBanksModel> apiDataAllBanks = AllBanksModel().obs;
//   void setApiDataBanks(AllBanksModel value) => apiDataAllBanks.value = value;
//
//   Future<void> allBanksApi() async {
//     setRxRequestStatus(ApiStatus.LOADING);
//     _api.allBanksApi().then((value) {
//       setApiDataBanks(value);
//       if(apiDataAllBanks.value.status == true){
//         setRxRequestStatus(ApiStatus.COMPLETED);
//         final match = apiDataAllBanks.value.data;
//         print("All banks>>>>>>>>>>>>>>>>>>>>>> ${match?.first.name}");
//         print("All banks>>>>>>>>>>>>>>>>>>>>>> ${jsonEncode(match)}");
//       }else{
//         setRxRequestStatus(ApiStatus.COMPLETED);
//         print("Errror allBanksApi>>>>>>>>>>>>>>> ${apiDataAllBanks.value.status}");
//         print("Errror allBanksApi>>>>>>>>>>>>>>> ${apiDataAllBanks.value.message}");
//       }
//     },).onError((error, stackTrace) {
//       setRxRequestStatus(ApiStatus.ERROR);
//       print("Errror allBanksApi>>>>>>>>>>>>>>> ${apiDataAllBanks.value.status}");
//       print("Errror allBanksApi>>>>>>>>>>>>>>> ${apiDataAllBanks.value.message}");
//       },);
//   }
// }
//
// class BankAccountStatusDropdownItem {
//   final String name;
//   final String id;
//
//   BankAccountStatusDropdownItem({required this.name, required this.id});
// }
// final statusItems = [
//   BankAccountStatusDropdownItem(name: "Active", id: "1"),
//   BankAccountStatusDropdownItem(name: "Inactive", id: "0"),
// ];
// // RxList<String> accountType = ['Saving', 'Current', "Business"].obs;
//
// class BankAccountTypeDropdownItem {
//   final String name;
//   final String id;
//
//   BankAccountTypeDropdownItem({required this.name, required this.id});
// }
// final bankAccountTypeItems = [
//   // BankAccountTypeDropdownItem(name: "Saving", id: "Saving"),
//   BankAccountTypeDropdownItem(name: "Personal", id: "Personal"),
//   BankAccountTypeDropdownItem(name: "Business", id: "Business"),
// ];
//
//
