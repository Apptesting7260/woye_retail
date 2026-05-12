import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/AddOn_Screens/controller/vendor_addon_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/Models/restaurant_get_addon_model.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/validation.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';


class RestaurantAddAddonScreen extends StatelessWidget {
  RestaurantAddAddonScreen({super.key});

  final VendorAddonController restaurantAddOnController = Get.put(VendorAddonController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: appbar(context),
          body: Obx(() {
            switch (restaurantAddOnController.rxRequestAddOnStatus.value) {
              case ApiStatus.LOADING: return Center(child: circularProgressIndicator());
              case ApiStatus.ERROR:
                if (restaurantAddOnController.addOnError.value == 'No internet') {
                  return InternetExceptionWidget(
                    onPress: () {
                      restaurantAddOnController.getAddOnApi();
                    },
                  );
                } else {
                  return GeneralExceptionWidget(
                    onPress: () {
                      restaurantAddOnController.getAddOnApi();

                    },
                  );
                }
              case ApiStatus.COMPLETED:
                return RefreshIndicator(
                  onRefresh: ()async{
                    restaurantAddOnController.onInit();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: REdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        children: [
                          searchField(),
                          hBox(25.h),
                          Obx(()=> addOnListFromApi(restaurantAddOnController.searchController.value.isNotEmpty ? restaurantAddOnController.searchListAddOn : restaurantAddOnController.apiAddOnData.value.addons!)),
                        ],
                      ),
                    ),
                  ),
                );
            }
          }),
        ),
      ),
    );
  }


  CustomAppBar appbar(BuildContext context) {
    return CustomAppBar(
      appbarRightPadding: 6.w,
      title: Text(
        "AddOn",
        style: AppFontStyle.text_22_600(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroyRegular,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          color: AppColors.white,
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == "Export AddOn") {
              // FileDownload.downloadAndSavePDF( "https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf",saveInDownload: true);
            }
            else if (value == "Add AddOn") {
              showDialog(context: context,
                barrierDismissible: false,
                // useSafeArea: false,
                builder: (context) {
                  return Stack(
                    children: [
                      AlertDialog(
                        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.zero,
                        // title: Center(child: Text("Add AddOn",style:  AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.gilroyRegular,),)),
                        // titlePadding: REdgeInsets.only(top: 30.h),
                        backgroundColor: AppColors.white,
                        content:Stack(children:[
                          addAddOn(context,  id: '', isAdd: true),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(onPressed: (){
                              Get.back();
                            }, icon:  Icon(Icons.cancel,color: AppColors.primary,size: 26,)),
                          ),
                        ])
                      ),

                    ],
                  );
                },);
            }},
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Add AddOn',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Add AddOn', style: AppFontStyle.text_16_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium),),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Export AddOn',
                child: ListTile(
                  title: Text('Export Addon', style: AppFontStyle.text_16_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium),),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  CustomTextFormField searchField() {
    return CustomTextFormField(
      controller: restaurantAddOnController.searchFieldController.value,
      onTapOutside: (value){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      onChanged: (value){
        restaurantAddOnController.searchController.value = value;
        restaurantAddOnController.searchListAddOn.value = restaurantAddOnController.apiAddOnData.value.addons!.where((entry) => entry.name!.toLowerCase().contains(value.toLowerCase())).toList();
        restaurantAddOnController.update();
      },
      prefix: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: SvgPicture.asset(
          ImageConstants.searchLogo,
          height: 24,
          width: 24,
        ),
      ),
      suffix:restaurantAddOnController.searchController.value.isNotEmpty ?
    IconButton(onPressed: (){
      restaurantAddOnController.searchController.value= "";
      restaurantAddOnController.searchFieldController.value.clear();
      restaurantAddOnController.searchListAddOn.clear();
    }, icon:  Icon(Icons.cancel_outlined,color: AppColors.grey.withOpacity(0.6),size: 20.w,),)
        :const SizedBox.shrink(),
      hintText: "Search",
    );
  }

  addAddOn(BuildContext context, {bool isAdd = true, required String id}) {
    if(isAdd){
      restaurantAddOnController.requestAddOnController.value.text = '';
    }
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Obx(() =>
              Form(
                key: restaurantAddOnController.addOnKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hBox(30.h),
                    Center(child: Text( isAdd ? "Add AddOn" : "Edit AddOn",style:  AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.gilroyRegular,),)),
                    hBox(20.h),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 25.0),
                      child: CustomTextFormField(
                        controller: TextEditingController(text: restaurantAddOnController.requestAddOnController.value.text),
                        onChanged: (value){restaurantAddOnController.requestAddOnController.value.text = value;},
                        hintText: 'Enter AddOn Name',
                        // errorTextClr: restaurantAddOnController.isRedClr.value ? AppColors.red : AppColors.darkText,
                        onTapOutside: (value){
                          // restaurantAddOnController.isRedClr.value =false;
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onTap: (){
                          // restaurantAddOnController.isRedClr.value =false;
                        },
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return "Please enter addon name";
                          }
                          if (!isValidCharacters(value)) {
                            return "Please enter a valid addon (only A-Z, a-z, and numbers 1-10 allowed)";
                          }
                          return null;
                        },
                      ),
                    ),
                    hBox(13.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomElevatedButton(
                        width: 145.w,
                        height: 50.h,
                        isLoading: restaurantAddOnController.rxAddAddOnRequestStatus.value == ApiStatus.LOADING || restaurantAddOnController.rxEditAddOnRequestStatus.value == ApiStatus.LOADING ,
                        onPressed: () {

                          if(restaurantAddOnController.requestAddOnController.value.text.isEmpty){
                            // restaurantAddOnController.isRedClr.value = true;
                          }else{
                            // restaurantAddOnController.isRedClr.value = false;
                          }
                          if (restaurantAddOnController.addOnKey.currentState!.validate()) {
                            if(isAdd){
                              restaurantAddOnController.newAddOnRequestApi(context, name: restaurantAddOnController.requestAddOnController.value.text,);
                            }else{
                              restaurantAddOnController.editAddOnRequestApi(name: restaurantAddOnController.requestAddOnController.value.text, id: id);
                            }

                          }
                        },
                        text: isAdd ? "Submit" : "Update",
                        color: AppColors.primary,
                      ),
                    ),
                    hBox(30.h),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }


  Widget addOnListFromApi(List<Addons> dataList){
    return dataList.isEmpty
        ? CustomNoResultFound(heightBox: hBox(10),)
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index){
        return
          Column(
            children: [
              hBox(14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dataList[index].name ?? '', style: AppFontStyle.text_18_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyRegular,),),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            restaurantAddOnController.requestAddOnController.value.text = dataList[index].name ?? '';
                            // Get.defaultDialog(
                            //   barrierDismissible: false,
                            //   contentPadding: REdgeInsets.symmetric(horizontal: 15.w),
                            //   title: "Edit AddOn",
                            //   titlePadding: REdgeInsets.only(top: 25.h),
                            //   backgroundColor: AppColors.white,
                            //   content: addAddOn(context, id: dataList[index].id ?? "", isAdd: false),
                            //   titleStyle: AppFontStyle.text_22_400(AppColors.black, fontFamily: AppFontFamily.gilroyMedium,),
                            // );
                            showDialog(context: context,
                              barrierDismissible: false,
                              // useSafeArea: false,
                              builder: (context) {
                                return PopScope(
                                  canPop: false,
                                  child: Stack(
                                    children: [
                                      AlertDialog(
                                          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          // title: Center(child: Text("Add AddOn",style:  AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.gilroyRegular,),)),
                                          // titlePadding: REdgeInsets.only(top: 30.h),
                                          backgroundColor: AppColors.white,
                                          content:Stack(children:[
                                            addAddOn(context, id: dataList[index].id ?? "", isAdd: false),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: IconButton(onPressed: (){
                                                Get.back();
                                              }, icon:  Icon(Icons.cancel,color: AppColors.primary,size: 26,)),
                                            ),
                                          ])
                                      ),

                                    ],
                                  ),
                                );
                              },);
                          },
                          child: SvgPicture.asset(ImageConstants.addOnPencil,)),
                      wBox(20.w),
                      GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context, builder: (BuildContext context){
                              return PopScope(
                                canPop: false,
                                child: Obx(() => CustomDeleteAlertDialog(
                                  isLoading: restaurantAddOnController.rxRequestAddOnDeleteStatus.value == ApiStatus.LOADING,
                                  btnName: "Delete",
                                  title: "Warning",
                                  subtitle: "Are you sure, you want to delete",
                                  cancelOnTap: (){
                                    Get.back();
                                  },
                                  deleteOnTap: (){
                                    restaurantAddOnController.deleteAddOnApi(dataList[index].id ?? "");
                                  },
                                ),
                                ),
                              );
                            });


                          },
                          child: SvgPicture.asset(ImageConstants.addOnDelete,)),
                    ],
                  ),
                ],
              ),
              hBox(14.h),
              Divider(color: Colors.grey.shade300,),
            ],
          );
      },
    );
  }


}
