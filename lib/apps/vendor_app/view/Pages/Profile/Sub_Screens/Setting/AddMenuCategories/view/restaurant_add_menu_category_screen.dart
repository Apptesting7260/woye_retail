import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/image.dart';
import '../../RestaurantInformation/view/restaurant_information_screen.dart';
import '../../controller/restaurant_setting_controller.dart';

class RestaurantAddMenuCategoryScreen extends StatefulWidget{
  RestaurantAddMenuCategoryScreen({super.key});

  @override
  State<RestaurantAddMenuCategoryScreen> createState() => _RestaurantAddMenuCategoryScreenState();
}

class _RestaurantAddMenuCategoryScreenState extends State<RestaurantAddMenuCategoryScreen> {
  final RestaurantSettingController controller  = Get.find<RestaurantSettingController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getSelectedCategory();
      controller.selectedTypeIndex.value = 0;
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundClr,
      appBar: const CustomAppBar(),
      body: Obx(() {
        switch(controller.selCategoryData.value.status){
          case ApiStatus.LOADING :
            return  addMenuCategoryShimmer();
          case ApiStatus.ERROR :
            if (controller.selCategoryData.value.message == 'No internet') {
              return InternetExceptionWidget(
                onPress: () {
                  controller.getSelectedCategory();
                },
              );
            } else {
              return GeneralExceptionWidget(
                onPress: () {
                  controller.getSelectedCategory();
                  },
              );
            }
          case ApiStatus.COMPLETED :
            return body();
          default:
           return const SizedBox.shrink();
          }
      },
      ),
    );
  }


  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        children: [
          header(
            title: "Add Store Categories",
            description: "Select from predefined categories or request a new category to be added to the system.",
          ),
          hBox(14),
          catButton(),
          hBox(16),
          Obx(
            ()=> controller.selectedTypeIndex.value == 0 ?
            selectedCategories() : requestCategory(),
          ),

          hBox(6),
        ],
      ),
    );
  }

  Widget selectedCategories() {
    return Expanded(
      child: SingleChildScrollView(
        controller: controller.scrollCatController,
        child: Column(
          children: [
            CustomTextFormField(
              controller: controller.searchController.value,
              height: 56,
              hintText: "Search categories...",
              onChanged:(val){
                controller.filterCategories(val);
              },
              prefix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AppImage(path: ImageConstants.searchLogo),
              ),
              suffix:controller.searchQuery.isNotEmpty?  IconButton(
                onPressed: (){
                    controller.clearSearch();
                },
                icon: const Icon(Icons.clear),
              ) : const SizedBox.shrink(),
            ),
            if(controller.selectedCategories.isNotEmpty)
            hBox(18),
            selectedCategoryCard(),
            hBox(18),
            categoryList(),
            hBox(18),
           if(controller.filteredList.isNotEmpty)
            CustomElevatedButton(
              onPressed: () {
                if(controller.selectedCategories.isNotEmpty){
                  controller.appendSelectedCategoriesToProfile();
                  Get.back();
                }
              },
              text: 'Add Selected (${controller.selectedCategories.length.toString()})',
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryList() {
    return Obx(
      () {
        
        if(controller.filteredList.isEmpty){
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomNoResultFound(heightBox:hBox(0)),
          );
        }
        
        return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
           return Obx(
            () {

              final categories = controller.filteredList[index];
              RxBool isSelected = controller.selectedCategories.any((element) => element['id'] == categories.id).obs;
              return GestureDetector(
                onTap: () => controller.toggleCategorySelection({
                  'id' : categories.id,
                  "name" : categories.name
                }),
                child: AppContainer(
                boxShadow: const [],
                border: Border.all(color: isSelected.value ? AppColors.primary : AppColors.borderClr),
                radius: 14,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(categories.name ?? "", style: AppFontStyle.text_14_600(AppColors.blackClr, fontFamily: AppFontFamily.gilroyRegular)),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Transform.scale(
                        scale: 1.06,
                        child: Checkbox(
                          value: isSelected.value,
                          onChanged: (val) {
                            controller.toggleCategorySelection({
                              'id' : categories.id,
                              "name" : categories.name
                            });
                          },
                          activeColor: AppColors.primary,
                          side: BorderSide(width: 1, color: AppColors.lightBlackClr),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      );
      },
    );
  }

  Widget selectedCategoryCard() {
    return Obx(
      () {
        return controller.selectedCategories.isEmpty ? const SizedBox.shrink() : AppContainer(
        radius: 10,
        boxShadow: const [],
        width: Get.width,
        color: AppColors.greenClr.withAlpha(12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: Border.all(color: AppColors.greenLightClr, width: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Selected Categories (${controller.selectedCategories.length})",
              style: AppFontStyle.text_14_600(AppColors.primary, fontFamily: AppFontFamily.gilroyMedium),
            ),
            hBox(8),
            Wrap(
              children: List.generate(controller.selectedCategories.length,(index) => Padding(
                padding: const EdgeInsets.only(right: 10,bottom: 10),
                child: AppContainer(
                  boxShadow: const [],
                  color: AppColors.primary.withAlpha(25),
                  radius: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.selectedCategories[index]['name'],
                        style: AppFontStyle.text_14_400(AppColors.primary, fontFamily: AppFontFamily.gilroyMedium),
                      ),
                      wBox(6),
                      InkWell(
                        onTap: () {
                          controller.toggleCategorySelection({
                            'id' : controller.selectedCategories[index]['id'],
                            "name" : controller.selectedCategories[index]['name']
                          });
                        },
                        child: Icon(Icons.clear, color: AppColors.primary, size: 18),
                      ),
                    ],
                  ),
                ),
              ), ),
            )
          ],
        ),
      );
      },
    );
  }

  AppContainer catButton() {
    return AppContainer(
      boxShadow: const [],
      radius: 100,
      color: AppColors.whiteShadow,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
                (index) => Obx(
                  () => InkWell(
                onTap: () {
                  controller.updateSelectedType(index);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 3 : 0),
                  child: AppContainer(
                    color: controller.selectedTypeIndex.value == index ? AppColors.white : AppColors.transparent,
                    radius: 100,
                    boxShadow: const [],
                    padding: const EdgeInsets.symmetric(horizontal: 9.5, vertical: 6),
                    child: Row(
                      children: [
                        index == 1 ? AppImage(path: ImageConstants.send, height: 16) : const Icon(Icons.check_circle_outline, size: 19),
                        wBox(4),
                        Text(controller.categoryList[index], style: AppFontStyle.text_14_400(AppColors.blackClr, fontFamily: AppFontFamily.gilroySemiBold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  ///-------------------------request category
  requestCategory(){
    return Expanded(
      child: SingleChildScrollView(
        controller: controller.scrollReqCatController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hBox(6),
              AppContainer(
                color: AppColors.blueClr.withAlpha(5),
                radius: 10,
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                boxShadow: const [],
                border: Border.all(color: AppColors.blueLightColor.withAlpha(40),width: 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Request New Category",style: AppFontStyle.text_16_400(AppColors.blueLightColor,fontFamily: AppFontFamily.gilroySemiBold),),
                    hBox(6),
                    Text(
                      "If you can't find the category you need in our predefined list, you can request it to be added. Our team will review your request and add it to the system if approved.",
                      maxLines: 10,
                      style: AppFontStyle.text_14_400(AppColors.blueLightColor,fontFamily: AppFontFamily.gilroyRegular),
                    ),
                  ],
                ),
              ),
              hBox(16),
              title("Category Name *"),
              hBox(4),
               CustomTextFormField(
                 key: controller.nameKey,
                controller: controller.catNameController.value,
                 validator: (value) {
                   if (controller.isSubmitted.value) return null;

                   if (value == null || value.isEmpty) {
                     return "Please enter category name";
                   }
                   return null;
                 },
                 hintText: "e.g., Gluten-Free Options",
              ),
              hBox(16),
              // title("Department *"),
              // hBox(4),
              // CustomDropDown(
              //   hintText: "Select department",
              //     btnHeight: 56,
              //     items: const ["Food & Beverages"],
              //     onChanged: (val){},
              // ),
              // hBox(16),
              title("Category Description"),
              hBox(4),
               CustomTextFormField(
                controller: controller.catDescriptionController.value,
                hintText: "Explain why this category is needed for your business...",
                minLines: 5,
                maxLines: 5,
              ),
              hBox(16),
              title("Business Justification *"),
              hBox(4),
              CustomTextFormField(
                controller: controller.businessJustificationController.value,
                hintText: "Explain why this category is needed for your business...",
                minLines: 5,
                maxLines: 5,
                validator: (value) {
                  if(controller.isSubmitted.value) return null;
                  if(value?.isEmpty ?? false){
                    return "Please enter business justification";
                  }
                  return null;
                },
              ),
              hBox(16),
              title("Request Priority"),
              hBox(4),
              CustomDropDown(
                hintText: "Normal - Standard timeline",
                selectedValue: controller.selectedPriority.value,
                btnHeight: 56,
                items: const ["High",'Medium','Low'],
                onChanged: (val){
                  controller.selectedPriority.value = val ?? "";
                },
              ),
              hBox(30),
              Obx(
                ()=> CustomElevatedButton(
                  height: 56,
                  onPressed: () {
                    if(controller.catNameController.value.text.isEmpty){
                      controller.isSubmitted.value = false;
                      controller.scrollToFields(controller.nameKey);
                      controller.formKey.currentState?.validate();
                    }else {
                      if (controller.formKey.currentState?.validate() ?? false) {
                        controller.newCategoryRequestApi();
                        controller.isSubmitted.value = true;
                      }
                    }
                  },
                  child:controller.newCategoriesData.value.status == ApiStatus.LOADING ?
                  circularProgressIndicator(color: AppColors.white) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    AppImage(path: ImageConstants.send,svgColor: ColorFilter.mode(AppColors.white, BlendMode.srcIn,),height: 22,width: 22),
                    wBox(10),
                    Text("Submit Request",
                      style: AppFontStyle.text_18_400(AppColors.white,fontFamily: AppFontFamily.gilroySemiBold),
                    ),
                  ],
                  ),
                ),
              ),
              hBox(20),
            ],
          ),
        ),
      ),
    );
  }

  title(String title) {
    return Text(
      title,
        style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
      );
  }

  Widget addMenuCategoryShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 180, height: 22),
          const SizedBox(height: 10),
          const ShimmerBox(width: double.infinity, height: 16),

          const SizedBox(height: 18),

          // Category buttons row
          const Row(
            children: [
              ShimmerBox(width: 120, height: 40, radius: 100),
              SizedBox(width: 10),
              ShimmerBox(width: 120, height: 40, radius: 100),
            ],
          ),

          const SizedBox(height: 20),

          // Search box
          const ShimmerBox(width: double.infinity, height: 56, radius: 12),

          const SizedBox(height: 20),

          // Selected Category Card
          const ShimmerBox(width: double.infinity, height: 90, radius: 12),

          const SizedBox(height: 20),

          // Category List
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) =>
                  const ShimmerBox(width: double.infinity, height: 60, radius: 14),
            ),
          ),
        ],
      ),
    );
  }

}