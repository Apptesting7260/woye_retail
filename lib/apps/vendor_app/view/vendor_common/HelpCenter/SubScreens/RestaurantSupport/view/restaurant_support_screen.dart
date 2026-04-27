import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
 import 'package:get/get.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../Pages/Profile/Sub_Screens/Setting/RestaurantInFormation/view/restaurant_information_screen.dart';
import '../controller/restaurant_support_controller.dart';

class RestaurantSupportScreen extends GetView<RestaurantSupportController>{
const RestaurantSupportScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.backgroundClr,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Obx(
            ()=> Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  header(
                  title: "Contact Support",
                  description:controller.loginType.value == "grocery" ? "Our grocery store support team is here to help you with any questions or issues"
                      :controller.loginType.value == "pharmacy" ? "Our pharmacy support team is here to help you with any questions or compliance issues"
                      : "Our restaurant support team is here to h  elp you with any questions or compliance issues"
                  ),
                  hBox(20),
                 supportCard(),
                  Divider(
                    color: AppColors.borderClr,
                    height: 48,
                  ),
                  Text("Submit a Ticket",style: AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),),
                  hBox(6),
                  Text(
                    controller.loginType.value == "grocery" ? "Describe your grocery store issue in detail and we'll get back to you"
                    : controller.loginType.value == "pharmacy" ? "Describe your pharmacy issue in detail and we'll get back to you"
                    : "Describe your restaurant issue in detail and we'll get back to you",
                    maxLines: 3,
                    style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular),
                  ),
                  hBox(16),
                  title("Category"),
                  hBox(6),
                  Obx(
                    ()=> CustomDropDown(
                      key: controller.categoryKey,
                        btnHeight: 56,
                        selectedValue: controller.selectedCategory.value,
                        items: controller.categoryList,
                        onChanged: (value) {
                          controller.selectedCategory.value = value ?? "";
                        },
                      validator: (value) {
                        if(controller.selectedCategory.value.isEmpty && controller.isError.value){
                          return "Please select category";
                        }
                        return null;
                      },
                    ),
                  ),
                  hBox(16),
                  title("Priority"),
                  hBox(6),
                  Obx(
                    ()=> CustomDropDown(
                      key: controller.priorityKey,
                        btnHeight: 56,
                        selectedValue: controller.selectedPriority.value,
                        items: controller.priorityList,
                        onChanged: (value) {
                          controller.selectedPriority.value = value ?? "";
                        },
                      validator: (value) {
                        if(controller.selectedPriority.value.isEmpty && controller.isError.value){
                          return "Please select priority";
                        }
                        return null;
                      },
                    ),
                  ),
                  hBox(16),
                  title("Subject"),
                  hBox(6),
                  CustomTextFormField(
                    controller: controller.subjectController,
                    hintText: "Brief description of your issue",
                    validator: (value) {
                      if(controller.isError.value) {
                        if(value?.isEmpty ?? false){
                        return "Brief description of your issue...";
                      }}
                      return null;
                    },
                  ),
                  hBox(16),
                  title("Description"),
                  hBox(6),
                  CustomTextFormField(
                    controller: controller.descriptionController,
                    maxLines: 4,
                    minLines: 4,
                    hintText:controller.loginType.value == "grocery" ? "Please describe your grocery store issue in detail..." : "Please describe your restaurant issue in detail...",
                    validator: (value) {
                      if(controller.isError.value) {
                        if (value?.isEmpty ?? false) {
                          return "Please describe your restaurant issue in detail...";
                        }
                      }
                      return null;
                    },
                  ),
                  hBox(16),
                  title("Attachments"),
                  hBox(6),
                    Obx(
                    ()=>controller.pickedFiles.isNotEmpty ? ListView.separated(
                      separatorBuilder:  (context, index) => hBox(4),
                        shrinkWrap: true,
                        itemCount: controller.pickedFiles.length,
                        itemBuilder: (context, index) {
                        return AppContainer(
                          boxShadow: const [],
                          radius: 6,
                            padding: const EdgeInsets.fromLTRB(6,4,0,4),
                            child: Row(
                          children: [
                            Flexible(
                              flex: 9,
                              child: Text(controller.pickedFile?.name ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () => controller.pickedFiles.removeAt(index),
                                child: Icon(Icons.clear,color: AppColors.red,size: 20,),
                              ),
                            ),
                          ],
                        ));
                      },) : const SizedBox.shrink(),
                    ),
                    hBox(6),
                  uploadDocuments(),
                  hBox(44),
                  Obx(
                    ()=> CustomElevatedButton(
                      isLoading: controller.rxCreateSupportStatus.value == ApiStatus.LOADING,
                      onPressed: (){

                        if(controller.subjectController.value.text.isEmpty || controller.descriptionController.value.text.isEmpty){
                          controller.isError.value = true;
                        }else{
                          controller.isError.value = false;
                        }

                        if(controller.selectedCategory.value.isEmpty || controller.selectedCategory.value == ""){
                          controller.scrollToFields(controller.categoryKey);
                          controller.formKey.currentState?.validate();
                        }else if(controller.selectedPriority.value.isEmpty || controller.selectedPriority.value == ""){
                          controller.scrollToFields(controller.priorityKey);
                          controller.formKey.currentState?.validate();
                        }else{
                          if(controller.formKey.currentState?.validate() ?? false){

                            controller.createSupportApi();
                          }
                        }

                      },
                      text: "Submit Ticket",
                       textStyle:AppFontStyle.text_17_600(AppColors.white,fontFamily: AppFontFamily.gilroyMedium),
                    ),
                  ),
                  hBox(8),
                  hBox(8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

Widget uploadDocuments() {
  return Obx(
        ()=> SizedBox(
      height: 150,
      child: InkWell(
        onTap: () => controller.pickImage(Get.context!),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          padding: const EdgeInsets.all(6),
          dashPattern: const [4],
          strokeWidth: 1.2,
          color: controller.isErrorColor.value
              ? AppColors.red
              : AppColors.borderClr,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Center(
              child: Obx(() {
                final imageFile = controller.image.value;


                // Check if the current file is PDF by its path
                final isPdf = imageFile?.path.toLowerCase().endsWith('.pdf') ?? false;

                return SizedBox(
                  width: Get.width,
                  height: Get.width * .7,

                  child: isPdf
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImage(
                        path: ImageConstants.pdfPng,
                        height: 110,width: 110,
                      ),
                      hBox(14),
                      Text(imageFile?.path.split('/').last.toString() ?? "",
                        style: AppFontStyle.text_14_500(
                          AppColors.blackClr,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ],
                  )
                      : imageFile != null
                      ? Image.file(
                    imageFile,
                    width: 130,
                    height: 130,
                    fit: BoxFit.fill,
                  )

                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppContainer(
                        color: AppColors.backgroundClr,
                        radius: 10,
                        boxShadow: const [],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: AppImage(path:
                            ImageConstants.upload,
                            height: 34,
                            width: 34,
                            svgColor: ColorFilter.mode(
                              AppColors.greyClr.withAlpha(140),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),

                      // const SizedBox(height: 5),

                      Text(
                        "Drop files here or click to upload",
                        style: AppFontStyle.text_14_500(
                          AppColors.grey,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    ),
  );
}

Text title(String title) => Text(title,style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),);

  Widget supportCard() {
    return ListView.separated(
         separatorBuilder: (context, index) => hBox(16),
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         itemCount: controller.supportList.length,
         itemBuilder: (context, index) =>  AppContainer(
         radius: 14,
         color: AppColors.white,
         width: Get.width,
         padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 22),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             AppContainer(
               padding: const EdgeInsets.all(14),
               shape: BoxShape.circle,
               boxShadow: const [],
               color: controller.supportList[index]['color'].withAlpha(30),
               child: AppImage(path: controller.supportList[index]['image'],svgColor: ColorFilter.mode(controller.supportList[index]['color'], BlendMode.srcIn),),
             ),
             hBox(15),
             Text(controller.supportList[index]['title'],style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyBold),),
             hBox(8),
             Text(controller.loginType.value == "grocery" ? controller.supportListGrocery[index]
                 : controller.loginType.value == "pharmacy" ? controller.supportListGrocery[index]
                 : controller.supportList[index]['des'],
               maxLines: 3,
               style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular),
             ),
             hBox(15),
             CustomElevatedButton(
               borderRadius: BorderRadius.circular(10),
               padding: EdgeInsets.zero,
               width: 120,
               height: 40,
               color: controller.supportList[index]['color'],
               onPressed: () {
                 // switch(index){
                 //   // case 0 :
                 //     // Get.toNamed(AppRoutes.resLiveChatSupportScreen);
                 //   case 1 :
                 //     Get.toNamed(AppRoutes.resEmailSupportScreen);
                 //   case 2 :
                 //     Get.toNamed(AppRoutes.resPhoneSupportScreen);
                 // }
               },
               text: controller.supportList[index]['btnName'],
               textStyle: AppFontStyle.text_14_600(AppColors.white,fontFamily: AppFontFamily.gilroyMedium),
             ),
           ],
         ),
       ),
    );
  }

}




//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:woye_vendor_app/Data/components/general_exception.dart';
// import 'package:woye_vendor_app/Routes/app_routes.dart';
//
// import '../../../../../../../../../Core/Constant/image_constant.dart';
// import '../../../../../../../../../Core/Utils/date_format.dart';
// import '../../../../../../../../../Core/Utils/sized_box.dart';
// import '../../../../../../../../../Data/components/internet_exception.dart';
// import '../../../../../../../../../Data/response/status.dart';
// import '../../../../../../../../../shared/theme/colors.dart';
// import '../../../../../../../../../shared/theme/font_family.dart';
// import '../../../../../../../../../shared/theme/font_style.dart';
// import '../../../../../../../../../shared/widgets/circular_progress_indicator.dart';
// import '../../../../../../../../../shared/widgets/custom_appbar.dart';
// import '../../../../../../../../../shared/widgets/custom_elevated_button.dart';
// import '../../../../../../../../../shared/widgets/custom_no_result_found.dart';
// import '../../../../../../../../../shared/widgets/custom_query_tile.dart';
// import '../../../../../../../../../shared/widgets/custom_text_form_field.dart';
// import '../controller/restaurant_support_controller.dart';
// import '../model/restaurant_get_support_model.dart';
//
// class RestaurantSupportScreen extends StatelessWidget {
//   RestaurantSupportScreen({super.key});
//
//   final RestaurantSupportController restaurantSupportController = Get.put(RestaurantSupportController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.white,
//       child: SafeArea(
//         child: Scaffold(
//           appBar: CustomAppBar(
//             title: Text("Support", style: AppFontStyle.text_20_600(AppColors.darkText, fontFamily: AppFontFamily.gilroyRegular),),
//           ),
//           body: Obx((){
//             switch(restaurantSupportController.supportData.value.status){
//               case ApiStatus.LOADING:
//                 return Center(child: circularProgressIndicator());
//               // case ApiStatus.ERROR:
//               //   if (restaurantSupportController.supportData.value.message == 'No internet') {
//               //     return InternetExceptionWidget(
//               //       onPress: () {
//               //         restaurantSupportController.getSupportApi();
//               //       },
//               //     );
//               //   } else {
//               //     return GeneralExceptionWidget(
//               //       onPress: () {
//               //         restaurantSupportController.getSupportApi();
//               //       },
//               //     );
//               //   }
//               case ApiStatus.COMPLETED:
//                 return RefreshIndicator(
//                   onRefresh: ()async{
//                     await restaurantSupportController.getSupportApi();
//                   },
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: Padding(
//                       padding: REdgeInsets.symmetric(horizontal: 22.0),
//                       child: Column(
//                         children: [
//                         hBox(8.h),
//                         searchFromField(),
//                         hBox(25.h),
//                         _tabBar(),
//                         hBox(30.h),
//                         Obx(()=>
//                           queryList(
//                           restaurantSupportController.currentIndex.value == 0 && restaurantSupportController.searchQuery.value == ''
//                             ? restaurantSupportController.supportData.value.data?.openTickets ?? []
//                             : restaurantSupportController.currentIndex.value == 0 && restaurantSupportController.searchQuery.value != ''
//                             ? restaurantSupportController.filterList
//                             : restaurantSupportController.currentIndex.value == 1 && restaurantSupportController.searchQuery.value == ''
//                             ? restaurantSupportController.supportData.value.data?.closeTickets ?? []
//                             : restaurantSupportController.currentIndex.value == 1 && restaurantSupportController.searchQuery.value != ''
//                             ? restaurantSupportController.filterList
//                             : restaurantSupportController.currentIndex.value == 2 && restaurantSupportController.searchQuery.value != ''
//                             ? []
//                             : restaurantSupportController.currentIndex.value == 3 && restaurantSupportController.searchQuery.value == ''
//                             ? restaurantSupportController.supportData.value.data?.allTickets ?? []
//                             : restaurantSupportController.filterList
//                           )
//                         ),
//
//                         hBox(30.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               default:
//                 if (restaurantSupportController.supportData.value.message == 'No internet') {
//                   return InternetExceptionWidget(
//                     onPress: () {
//                       restaurantSupportController.getSupportApi();
//                     },
//                   );
//                 } else {
//                   return GeneralExceptionWidget(
//                     onPress: () {
//                       restaurantSupportController.getSupportApi();
//                     },
//                   );
//                 }
//             }
//           })
//         ),
//       ),
//     );
//   }
//
//   Widget searchFromField() {
//     return Row(
//       children: [
//         Expanded(
//           child: CustomTextFormField(
//             suffix:  restaurantSupportController.searchQuery.value != ""
//                 ? IconButton(
//               onPressed: (){
//                 restaurantSupportController.searchController.text = '';
//                 restaurantSupportController.searchQuery.value = '';
//               },
//               icon: Icon(Icons.cancel_outlined, color: AppColors.grey.withOpacity(0.6),size: 20.w),
//             )
//                 : const SizedBox.shrink(),
//             controller: restaurantSupportController.searchController,
//             onChanged: (value){
//               restaurantSupportController.searchQuery.value = value;
//               restaurantSupportController.filterList.value =
//                 restaurantSupportController.currentIndex.value == 0
//                   ? restaurantSupportController.supportData.value.data?.openTickets?.where((item) => item.title!.toLowerCase().contains(value.toLowerCase())).toList() ?? []
//                   : restaurantSupportController.currentIndex.value == 1
//                   ? restaurantSupportController.supportData.value.data?.closeTickets?.where((item) => item.title!.toLowerCase().contains(value.toLowerCase())).toList() ?? []
//                   : restaurantSupportController.currentIndex.value == 2
//                   ? []
//                   : restaurantSupportController.currentIndex.value == 3
//                   ? restaurantSupportController.supportData.value.data?.allTickets?.where((item) => item.title!.toLowerCase().contains(value.toLowerCase())).toList() ?? []
//                   : [];
//             },
//             prefix: Padding(
//               padding: REdgeInsets.only(left: 15, right: 10),
//               child: SvgPicture.asset(
//                 ImageConstants.searchLogo,
//                 height: 24,
//                 width: 24,
//               ),
//             ),
//             hintText: "Search",
//           ),
//         ),
//         wBox(8.w),
//         GestureDetector(
//           onTap: (){
//             restaurantSupportController.titleController.text = '';
//             restaurantSupportController.subjectController.text = '';
//             showDialog(
//               context: Get.context!,
//               barrierDismissible: false,
//               builder: (context) {
//                 return PopScope(
//                   canPop: false,
//                   child: Stack(
//                     children: [
//                       AlertDialog(
//                           insetPadding: const EdgeInsets.symmetric(horizontal: 22),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
//                           contentPadding: EdgeInsets.zero,
//                           backgroundColor: AppColors.white,
//                           content: Stack(
//                             children: [
//                               createTicket(context),
//                               Positioned(
//                                 right: 0,
//                                 top: 0,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     Get.back();
//                                     restaurantSupportController.titleController.text = '';
//                                     restaurantSupportController.subjectController.text = '';
//                                     },
//                                   icon: Icon(
//                                     Icons.cancel, color: AppColors.primary,
//                                     size: 26,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//           child: Container(
//             height: 52.h,
//             width: 52.w,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               borderRadius: BorderRadius.circular(15.r),
//             ),
//             child: Padding(
//               padding: REdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.add,
//                 size: 30.sp,
//                 color: AppColors.white,
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   createTicket(BuildContext context) {
//     return Obx(
//           () =>
//           Form(
//             key: restaurantSupportController.createKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 hBox(30.h),
//                 Text("Create A Ticket", style: AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.gilroyRegular,),),
//                 hBox(20.h),
//                 Padding(
//                   padding: REdgeInsets.symmetric(horizontal: 25.0),
//                   child: CustomTextFormField(
//                     controller: TextEditingController(text: restaurantSupportController.titleController.text),
//                     onChanged: (value){restaurantSupportController.titleController.text = value;},
//                     hintText: 'Enter title',
//                     // errorTextClr: restaurantSupportController.isRedClr.value ? AppColors.red : AppColors.darkText,
//                     onTapOutside: (value){
//                       FocusManager.instance.primaryFocus?.unfocus();
//                     },
//                     onTap: (){
//                       // restaurantSupportController.isRedClr.value = false;
//                     },
//                     validator: (value) {
//                       if(value == null || value.isEmpty){
//                         return "Please enter title";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 hBox(13.h),
//                 Padding(
//                   padding: REdgeInsets.symmetric(horizontal: 25.0),
//                   child: CustomTextFormField(
//                     controller: TextEditingController(text: restaurantSupportController.subjectController.text),
//                     onChanged: (value){restaurantSupportController.subjectController.text = value;},
//                     hintText: 'Enter Subject',
//                     // errorTextClr: restaurantSupportController.isRedClr.value ? AppColors.red : AppColors.darkText,
//                     onTapOutside: (value){
//                       FocusManager.instance.primaryFocus?.unfocus();
//                     },
//                     onTap: (){
//                       // restaurantSupportController.isRedClr.value = false;
//                     },
//                     validator: (value) {
//                       if(value == null || value.isEmpty){
//                         return "Please enter subject";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 hBox(13.h),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: CustomElevatedButton(
//                     width: 115.w,
//                     height: 50.h,
//                     isLoading: restaurantSupportController.rxCreateSupportStatus.value == ApiStatus.LOADING,
//                     onPressed: () async {
//                       // restaurantSupportController.isRedClr.value = true;
//                       if((restaurantSupportController.createKey.currentState?.validate() ?? false)){
//                         restaurantSupportController.createSupportApi(title: restaurantSupportController.titleController.text, subject: restaurantSupportController.subjectController.text);
//                       }
//                     },
//                     text: "Save",
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 hBox(20.h),
//               ],
//             ),
//           ),
//     );
//   }
//
//   _tabBar() {
//     List<String> tabBarItems = [
//       "Active",
//       "Closed",
//       "Stared",
//       "All",
//     ];
//     return Obx(
//       () => Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(tabBarItems.length, (index) {
//             bool isSelected = restaurantSupportController.currentIndex.value == index;
//             return InkWell(
//               highlightColor: Colors.transparent,
//               splashColor: Colors.transparent,
//               onTap: () {
//                 restaurantSupportController.currentIndex.value = index;
//                 restaurantSupportController.filterList.value =
//                 restaurantSupportController.currentIndex.value == 0
//                   ? restaurantSupportController.supportData.value.data?.openTickets?.where((item) => item.title!.toLowerCase().contains(restaurantSupportController.searchQuery.value.toLowerCase())).toList() ?? []
//                   : restaurantSupportController.currentIndex.value == 1
//                   ? restaurantSupportController.supportData.value.data?.closeTickets?.where((item) => item.title!.toLowerCase().contains(restaurantSupportController.searchQuery.value.toLowerCase())).toList() ?? []
//                   : restaurantSupportController.currentIndex.value == 2
//                   ? []
//                   : restaurantSupportController.currentIndex.value == 3
//                   ? restaurantSupportController.supportData.value.data?.allTickets?.where((item) => item.title!.toLowerCase().contains(restaurantSupportController.searchQuery.value.toLowerCase())).toList() ?? []
//                   : [];
//               },
//               child: Padding(
//                 padding: REdgeInsets.only(right: 12),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   alignment: Alignment.topLeft,
//                   curve: Curves.easeInOut,
//                   // width: 60.w,
//                   child: Column(
//                     children: [
//                       Text(
//                         tabBarItems[index],
//                         style: isSelected
//                             ? AppFontStyle.text_16_600(
//                                 AppColors.primary,
//                                 fontFamily: AppFontFamily.gilroyRegular,
//                               )
//                             : AppFontStyle.text_16_400(AppColors.greyClr,
//                                 fontFamily: AppFontFamily.gilroyMedium),
//                       ),
//                       hBox(8.h),
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.linear,
//                         height: 2.h,
//                         width: 52.w,
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? AppColors.primary
//                               : Colors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           })),
//     );
//   }
//
//   queryList(List<AllTickets> dataList) {
//     return dataList.isEmpty
//       ? CustomNoResultFound(heightBox: hBox(10.h),)
//       : ListView.separated(
//       padding: EdgeInsets.zero,
//       shrinkWrap: true,
//       itemCount: dataList.length,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         String vendorName = "${restaurantSupportController.supportData.value.data?.vendor?.firstName ?? ''} ${restaurantSupportController.supportData.value.data?.vendor?.lastName ?? ''}".isEmpty
//             ? restaurantSupportController.supportData.value.data?.vendor?.name ?? ''
//             : "${restaurantSupportController.supportData.value.data?.vendor?.firstName ?? ''} ${restaurantSupportController.supportData.value.data?.vendor?.lastName ?? ''}";
//         return CustomQueryTile(
//           imageUrl: restaurantSupportController.supportData.value.data?.vendor?.shopimage ?? '',
//           title: dataList[index].title,
//           date: FormatDate.ddMMYyyy(dataList[index].createdAt ?? ''),
//           subject: dataList[index].subject,
//           vendorName: vendorName,
//           onTap: () {
//             Get.toNamed(AppRoutes.restaurantSupportQueryReplayScreen,arguments:
//             {
//               "ticketId": dataList[index].id.toString(),
//               "title": dataList[index].title,
//             });
//           },
//         );
//       },
//       separatorBuilder: (context, index) {
//         return const Divider(height: 50,);
//       },
//     );
//   }
// }
