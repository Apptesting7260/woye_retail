import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Utils/date_format.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../Models/support_chat_model.dart';
import '../controller/restaurant_support_query_reply_controller.dart';

class RestaurantSupportQuarryReplyScreen extends StatelessWidget {
  RestaurantSupportQuarryReplyScreen({super.key});

  final SupportQuarryController controller = Get.put(SupportQuarryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            controller.supportChatApi(controller.ticketId);
          },
          child: Scaffold(
            appBar: appbar(),
            body: Obx(() {
              switch (controller.rxSupportChatRequestStatus.value) {
                case ApiStatus.LOADING:
                  return Center(child: circularProgressIndicator());
                case ApiStatus.ERROR:
                  if (controller.errorSupportChat.value == 'No internet') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.supportChatApi(controller.ticketId);
                      },
                    );
                  } else {
                    return GeneralExceptionWidget(
                      onPress: () {
                        controller.supportChatApi(controller.ticketId);
                      },
                    );
                  }
                case ApiStatus.COMPLETED:
                  return  Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minHeight: Get.height,
                        ),
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Padding(
                            padding: REdgeInsets.symmetric(horizontal: 23.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(controller.title, style: AppFontStyle.text_20_400(AppColors.darkText, fontFamily: AppFontFamily.gilroySemiBold,), maxLines: 2,),
                                hBox(10.h),
                                Row(
                                  children: [
                                    Icon(Icons.flag, color: AppColors.primary, size: 20,),
                                    Text("Technical Problem", style: AppFontStyle.text_16_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyRegular,), maxLines: 2,),
                                  ],
                                ),
                                Divider(height: 30.h),
                                // issuesCard(),
                                // hBox(20.h),
                                // supportTeamCard(),
                                // hBox(25.h),
                                chat(controller.supportChatData.value.chat ?? []),
                                // Spacer(),
                                if(controller.supportChatData.value.ticketStatus != "close") ...[
                                  hBox(200.h),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(controller.supportChatData.value.ticketStatus != "close") ...[
                        Positioned(
                          bottom: 0,
                          left: 5,
                          right: 5,
                          child: replyFormField(),
                        )
                      ],
                    ],
                  );
              }
            },
            ),
          ),
        ),
      ),
    );
  }

  Container replyFormField() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.textFieldBorder,
          ),
          borderRadius: BorderRadius.circular(10.r)),
      // height: 50,
      child: Obx(() {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          return controller.scrollToBottom();
        },);
        return Column(
            children: [
              Padding(
                padding: REdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  children: [
                    wBox(15.h),
                    GestureDetector(
                      onTap: () {
                        controller.isReply.value = true;
                      },
                      child: Text(
                        "Reply",
                        style: AppFontStyle.text_14_400(
                          controller.isReply.value
                              ? AppColors.primary
                              : AppColors.darkText,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                    // wBox(15.h),
                    // GestureDetector(
                    //   onTap: () {
                    //     controller.isReply.value = false;
                    //   },
                    //   child: Text("Private Note", style: AppFontStyle.text_14_400(controller.isReply.value ? AppColors.darkText : AppColors.primary, fontFamily: AppFontFamily.gilroyMedium,)),
                    // ),
                    // const Spacer(),
                    // Text("Reply as:", style: AppFontStyle.text_14_400(AppColors.mediumText, fontFamily: AppFontFamily.gilroyMedium,)),
                    // wBox(6.h),
                    // CircleAvatar(
                    //   backgroundColor: AppColors.primary,
                    //   radius: 12,
                    //   child: Center(
                    //     child: Text(
                    //       "ST",
                    //       style: AppFontStyle.text_10_400(
                    //         AppColors.white,
                    //         fontFamily: AppFontFamily.gilroySemiBold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // wBox(10.h),
                  ],
                ),
              ),
              Stack(
                children: [
                  Divider(
                    color: AppColors.textFieldBorder,
                    height: 2,
                  ),
                  Positioned(
                    left: controller.isReply.value ? 12.w : 100.w,
                    child: Container(
                      height: 2,
                      color: AppColors.primary,
                      width: 35,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: controller.replyController,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Reply.....",
                  hintStyle: AppFontStyle.text_14_400(
                    AppColors.mediumText,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
                style: AppFontStyle.text_14_400(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                minLines: 2,
                maxLines: 2,
              ),
              Divider(
                color: AppColors.textFieldBorder,
                height: 0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      REdgeInsets.only(left: 15.w, top: 10.w, bottom: 10.w),
                      child: CustomElevatedButton(
                        isLoading: controller.rxSupportChatReplyRequestStatus.value == ApiStatus.LOADING,
                        width: 80,
                        height: 38,
                        text: "Reply",
                        textStyle: AppFontStyle.text_20_500(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                        onPressed: () {
                          // controller.scrollToBottom();
                          if(controller.replyController.text.isNotEmpty){
                            controller.supportChatWithImageReplyApi();
                          }else{
                            Utils.showToast("Please enter reply");
                          }                          // controller.supportChatReplyApi(controller.ticketId, controller.replyController.text, controller.imageFiles);
                        },
                      ),
                    ),
                    wBox(15.w),
                    GestureDetector(
                      onTap: (){
                        controller.imagePicker();
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            ImageConstants.galleryLogo,
                            colorFilter: ColorFilter.mode(
                              AppColors.hintText,
                              BlendMode.srcIn,
                            ),
                            height: 22,
                          ),
                          if(controller.imageFiles.isNotEmpty)
                            Positioned(
                              right: -5,
                              top: -5,
                              child: CircleAvatar(
                                backgroundColor: AppColors.primary,
                                radius: 8,
                                child: Center(
                                  child: Obx(() =>
                                      Text(
                                        controller.imageFiles.length.toString(),
                                        style: AppFontStyle.text_10_500(
                                          AppColors.white,
                                          fontFamily: AppFontFamily.gilroySemiBold,
                                        ),
                                      ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // const Spacer(),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.more_vert,
                    //     color: AppColors.hintText,
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          );
      },
      ),
    );
  }


  chat(List<Chat> chatList){
    return chatList.isEmpty
        ? const SizedBox.shrink()
        : ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: chatList.length,
      itemBuilder: (BuildContext context, index){
        return chatList[index].senderType.toString().toLowerCase() == 'admin'
            ? supportTeamCard(chatList[index])
            : issuesCard(chatList[index]);
      },
    );
  }

  Widget issuesCard(Chat chat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44.h,
              width: 44.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.r),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: controller.supportChatData.value.vendor?.shopImage ?? '',
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline, color: AppColors.black),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.bgColor,
                    highlightColor: AppColors.lightText,
                    child: Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            wBox(10.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${controller.supportChatData.value.vendor?.firstName} ${controller.supportChatData.value.vendor?.lastName}",
                          style: AppFontStyle.text_16_400(
                            AppColors.darkText,
                            fontFamily: AppFontFamily.gilroySemiBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        FormatDate.ddMMYyyy(chat.createdAt ?? ''),
                        style: AppFontStyle.text_14_400(
                          AppColors.mediumText,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                      ),
                    ],
                  ),

                  hBox(8.h),
                  Text(
                    chat.message ?? '',
                        // "I am facing problem as I can not select currency on buy order page. Can you guys let me know what I am doing wrong? Please check attached files.",
                    style: TextStyle(
                      color: AppColors.mediumText,
                      fontFamily: AppFontFamily.gilroyRegular,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),

        hBox(15.h),
        imagesContainer(chat.images ?? []),
        hBox(20.h),
      ],
    );
  }

  Widget imagesContainer(List<String> imageFiles) {
    return imageFiles.isEmpty
        ? const SizedBox.shrink()
        : Container(
      width: Get.width,
      decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textFieldBorder,
          ),
          borderRadius: BorderRadius.circular(10.r)),
      // height: 50,
      child: Column(
        children: [
          ListView.separated(
            padding: REdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
            shrinkWrap: true,
            itemCount: imageFiles.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  SvgPicture.asset(
                    ImageConstants.galleryLogo,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                    height: 22,
                  ),
                  wBox(10.w),
                  Expanded(
                    child: Text(
                      imageFiles[index].split("/").last,
                      style: AppFontStyle.text_14_400(
                        overflow: TextOverflow.ellipsis,
                        AppColors.darkText,
                        fontFamily: AppFontFamily.gilroyRegular,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => hBox(10.h),
          ),
          Divider(
            color: AppColors.textFieldBorder,
            height: 0,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: REdgeInsets.only(left: 20.w),
                  child: Text(
                    "${imageFiles.length} files attached",
                    style: AppFontStyle.text_14_400(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    controller.rxDownloadImageRequestStatus.value ==ApiStatus.LOADING ? null:
                    controller.downloadAndSaveImages(imageFiles);
                  },
                  label: Text(
                    "Download All",
                    style: AppFontStyle.text_14_400(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                  icon: Image.asset(
                    ImageConstants.downloadImage,
                    height: 22,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget supportTeamCard(Chat chat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44.h,
              width: 44.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.r),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: controller.supportChatData.value.admin?[0].image ?? '',
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline, color: AppColors.black),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.bgColor,
                    highlightColor: AppColors.lightText,
                    child: Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            wBox(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Support Team",
                          style: AppFontStyle.text_16_400(
                            AppColors.darkText,
                            fontFamily: AppFontFamily.gilroySemiBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        FormatDate.ddMMYyyy(chat.createdAt ?? ''),
                        style: AppFontStyle.text_14_400(
                          AppColors.mediumText,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                      ),
                    ],
                  ),

                  hBox(8.h),
                  Text(
                    chat.message ?? '',
                    // "I am facing problem as I can not select currency on buy order page. Can you guys let me know what I am doing wrong? Please check attached files.",
                    style: TextStyle(
                      color: AppColors.mediumText,
                      fontFamily: AppFontFamily.gilroyRegular,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),
        hBox(15.h),
        imagesContainer(chat.images ?? []),
        hBox(20.h),
      ],
    );
  }

  // supportTeamCard(Chat chat) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             height: 44.h,
  //             width: 44.w,
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //             ),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(22.r),
  //               child: CachedNetworkImage(
  //                 imageUrl: controller.supportChatData.value.admin?[0].image ?? '',
  //                 errorWidget: (context, url, error) => Icon(Icons.error_outline,color: AppColors.black,),
  //                 placeholder: (context, url) => Shimmer.fromColors(
  //                   baseColor: AppColors.bgColor,
  //                   highlightColor: AppColors.lightText,
  //                   child: Container(
  //                     height: 35.h,
  //                     width: 35.w,
  //                     decoration: BoxDecoration(
  //                       color: AppColors.grey,
  //                       borderRadius: BorderRadius.circular(100.r),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           wBox(10.w),
  //           RichText(
  //             text: TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: "Support Team",
  //                   style: AppFontStyle.text_16_400(
  //                     AppColors.darkText,
  //                     fontFamily: AppFontFamily.gilroySemiBold,
  //                   ),
  //                 ),
  //                 // TextSpan(
  //                 //   text: " (You)",
  //                 //   style: AppFontStyle.text_16_400(
  //                 //     AppColors.mediumText,
  //                 //     fontFamily: AppFontFamily.gilroyRegular,
  //                 //   ),
  //                 // )
  //               ],
  //             ),
  //           ),
  //           const Spacer(),
  //           Text(
  //             FormatDate.ddMMYyyy(chat.createdAt ?? ''),
  //             style: AppFontStyle.text_14_400(
  //               AppColors.mediumText,
  //               fontFamily: AppFontFamily.gilroyRegular,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Padding(
  //         padding: REdgeInsets.only(left: 56.r),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Text(
  //             //   "Hello team,",
  //             //   style: AppFontStyle.text_14_400(
  //             //     AppColors.mediumText,
  //             //     fontFamily: AppFontFamily.gilroyRegular,
  //             //   ),
  //             // ),
  //             hBox(5.h),
  //             Text(
  //               // "I am facing problem as i can not select currency on buy order page. Can you guys let me know what i am doing doing wrong? Please check attached files.",
  //               chat.message ?? '',
  //               style: TextStyle(
  //                 color: AppColors.mediumText,
  //                 fontFamily: AppFontFamily.gilroyRegular,
  //               ),
  //             ),
  //             // hBox(20.h),
  //             // Text(
  //             //   "Thank you\nSaurabh",
  //             //   style: TextStyle(
  //             //     color: AppColors.mediumText,
  //             //     fontFamily: AppFontFamily.gilroyRegular,
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //       ),
  //       hBox(15.h),
  //       imagesContainer(chat.images ?? []),
  //       hBox(20.h),
  //     ],
  //   );
  // }

  CustomAppBar appbar() {
    return CustomAppBar(
      actions: [
        Obx((){
          if(controller.supportChatData.value.ticketStatus != null && controller.supportChatData.value.ticketStatus != "close"){
            return InkWell(
              onTap: (){
                controller.markAsClosedChatApi(controller.ticketId);
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textFieldBorder, width: 1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.done,
                        size: 18,
                        color: AppColors.hintText,
                      ),
                      wBox(6.w),
                      Text(
                        "Mark as Closed",
                        style: AppFontStyle.text_13_400(
                          AppColors.mediumText,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        // wBox(5.h),
        // const Icon(
        //   Icons.more_vert,
        //   size: 24,
        // ),
      ],
    );
  }
}
