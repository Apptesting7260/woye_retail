import 'package:flutter/material.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

class FestivalBanner extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final String buttonText;
  final VoidCallback? onTap;

  const FestivalBanner({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: 7,
        padEnds: false,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: AppImage(
                      path:image,
                        height: 167,
                        width: 337,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Container(
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //     borderRadius: const BorderRadius.vertical(
                    //       top: Radius.circular(16),
                    //     ),
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         Colors.black.withOpacity(0.6),
                    //         Colors.transparent,
                    //       ],
                    //       begin: Alignment.bottomLeft,
                    //       end: Alignment.topRight,
                    //     ),
                    //   ),
                    // ),
                    //
                    // /// text on image
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white.withAlpha(50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "🎁 Christmas Special",
                              style: AppFontStyle.text_10_500(
                                AppColors.white,
                                fontFamily: AppFontFamily.interMedium,
                              ),
                            ),
                          ),
                          Text(
                            title,
                            style: AppFontStyle.text_17_600(
                              AppColors.white,
                              fontFamily: AppFontFamily.interBold,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: AppFontStyle.text_14_400(
                              AppColors.white,
                              fontFamily: AppFontFamily.interRegular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                hBox(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    description,
                    maxLines: 3,
                    style: AppFontStyle.text_14_400(
                      AppColors.greyTextColor,
                      fontFamily: AppFontFamily.interRegular,
                    ),
                  ),
                ),
                hBox(10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: tags.map((e) => tagBox(e)).toList(),
                  ),
                ),
                hBox(10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12),
                //   child: GestureDetector(
                //     onTap: onTap,
                //     child: Container(
                //       width: double.infinity,
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //       decoration: BoxDecoration(
                //         color: const Color(0xFF37474F),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           buttonText,
                //           style: const TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                CustomElevatedButton(
                  color: AppColors.buttonColor,
                  text: "Shop Christmas Fashion ->",
                    onPressed: onTap ?? (){},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget tagBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,  style: AppFontStyle.text_14_400(
        AppColors.greyTextColor,
        fontFamily: AppFontFamily.interRegular,
      ),),
    );
  }
}
