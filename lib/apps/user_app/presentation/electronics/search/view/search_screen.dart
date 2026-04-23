import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gyaawa/shared/widgets/Custom_search_field.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../user_routes/app_routes.dart';
import '../controller/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final SearchMenuController controller = Get.put(SearchMenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    CustomSearchField(
                      hintText: "Search anything...",
                      onChanged: (value) {},
                      showCloseIcon: true,
                      onClose: (){},
                    ),
                hBox(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 18, color: AppColors.black),
                        wBox(5),
                        Text(
                          "Recent Searches",
                          style: AppFontStyle.text_12_600(
                            AppColors.black,
                            fontFamily: AppFontFamily.interSemiBold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Clear",
                      style: AppFontStyle.text_12_400(
                        AppColors.greyColors,
                        fontFamily: AppFontFamily.interMedium,
                      ),
                    ),
                  ],
                ),
                hBox(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: ListView.builder(
                    itemCount:controller.recentSearches.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: (){
                          Get.toNamed(UserRoutes.searchResultScreen);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 16, color: AppColors.arrowIconColor),
                              wBox(4),
                              Text(
                                controller.recentSearches[index],
                                style: AppFontStyle.text_12_400(
                                  AppColors.black,
                                  fontFamily: AppFontFamily.interRegular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                hBox(20),
                Row(
                  children: [
                    Icon(Icons.trending_up,
                        size: 18, color: AppColors.black),
                    wBox(7),
                    Text(
                      "Trending Searches",
                      style: AppFontStyle.text_13_500(
                        AppColors.black,
                        fontFamily: AppFontFamily.interSemiBold,
                      ),
                    ),
                  ],
                ),
                hBox(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: ListView.builder(
                    itemCount: controller.trendingSearches.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.trending_up,
                                size: 16, color: AppColors.buttonColor),
                            wBox(6),
                            Text(
                              controller.trendingSearches[index],
                              style: AppFontStyle.text_12_400(
                                AppColors.black,
                                fontFamily: AppFontFamily.interRegular,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          
                hBox(20),
                Text(
                  "Popular Categories",
                  style: AppFontStyle.text_12_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.interSemiBold,
                  ),
                ),
                hBox(10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.categories.map((text) {
                    return InkWell(
                      onTap: (){},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderClr),
                        ),
                        child: Text(
                          text,
                          style: AppFontStyle.text_12_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
