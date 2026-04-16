import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


//main use
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, required this.width, required this.height, this.radius, this.isCircle});

  final double width;
  final double height;
  final double? radius;
  final bool? isCircle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: isCircle == true ? const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        )
            : BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 15),
        ),
      ),
    );
  }
}

// Widget productGrid() {
//   return GridView.builder(
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: controller.products.length,
//     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 0,
//         crossAxisSpacing: 0,
//         childAspectRatio: 0.70),
//     itemBuilder: (context, index) {
//       final product = controller.products[index];
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16)),
//                 child: AppImage(
//                   path: product["image"],
//                   height: 167,
//                   width: 180,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 left: 10,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     "New",
//                     style: AppFontStyle.text_10_500(
//                       AppColors.buttonColor,
//                       fontFamily: AppFontFamily.interMedium,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 40,
//                 left: 10,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.buttonColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     "Best Seller",
//                     style: AppFontStyle.text_10_500(
//                       AppColors.white,
//                       fontFamily: AppFontFamily.interMedium,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 70,
//                 left: 10,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.boldRed,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     product["discount"],
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   padding: EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Icons.favorite_border, size: 18),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product["brand"],
//                   style: AppFontStyle.text_12_400(
//                     AppColors.buttonHideColor,
//                     fontFamily: AppFontFamily.interRegular,
//                   ),
//                 ),
//                 wBox(4),
//                 Text(
//                   product["name"],
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppFontStyle.text_12_500(
//                     AppColors.black,
//                     fontFamily: AppFontFamily.interMedium,
//                   ),
//                 ),
//                 wBox(6),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.amber, size: 14),
//                     Icon(Icons.star, color: Colors.amber, size: 14),
//                     Icon(Icons.star, color: Colors.amber, size: 14),
//                     Icon(Icons.star, color: Colors.amber, size: 14),
//                     SizedBox(width: 4),
//                     Text(
//                       "${product["rating"]} (${product["reviews"]})",
//                       style: AppFontStyle.text_12_400(
//                         AppColors.buttonHideColor,
//                         fontFamily: AppFontFamily.interRegular,
//                       ),
//                     ),
//                   ],
//                 ),
//                 wBox(6),
//                 Row(
//                   children: [
//                     Text(
//                       product["price"],
//                       style: AppFontStyle.text_14_600(
//                         AppColors.buttonColor,
//                         fontFamily: AppFontFamily.interBold,
//                       ),
//                     ),
//                     wBox(6),
//                     Text(
//                       product["originalPrice"],
//                       overflow: TextOverflow.ellipsis,
//                       style: AppFontStyle.text_12_400(
//                         AppColors.buttonHideColor,
//                         fontFamily: AppFontFamily.interRegular,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
// Widget festiveSlider() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CarouselSlider.builder(
//         itemCount: controller.dummyData.length,
//         options: CarouselOptions(
//           height: 167,
//           autoPlay: false,
//           viewportFraction: 0.85,
//           padEnds: false,
//           enlargeCenterPage: false,
//           onPageChanged: (index, reason) {
//             controller.currentSliderIndex.value = index;
//           },
//         ),
//         itemBuilder: (context, index, realIndex) {
//           final slideItem = controller.dummyData[index];
//
//           return Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(20),
//                 topLeft: Radius.circular(20),
//               ),
//               child: Stack(
//                 children: [
//                   Image.network(
//                     slideItem["image"],
//                     width: 367,
//                     height: 167,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         Container(color: Colors.grey.shade300),
//                   ),
//                   Positioned(
//                     bottom: 10,
//                     left: 10,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           slideItem["title"],
//                           style: AppFontStyle.text_17_600(
//                             AppColors.white,
//                             fontFamily: AppFontFamily.interBold,
//                           ),
//                         ),
//                         Text(
//                           slideItem["subtitle"],
//                           style: AppFontStyle.text_14_400(
//                             AppColors.white,
//                             fontFamily: AppFontFamily.interRegular,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 65,
//                     left: 10,
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: AppColors.white.withAlpha(50),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "🎁 Christmas Special",
//                         style: AppFontStyle.text_10_500(
//                           AppColors.white,
//                           fontFamily: AppFontFamily.interMedium,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       hBox(30),
//       Obx(() {
//         final item =
//             controller.dummyData[controller.currentSliderIndex.value];
//         final tags = item["tags"] as List<String>;
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             children: [
//               Text(
//                 item["desc"],
//                 maxLines: 3,
//                 style: AppFontStyle.text_14_400(
//                   AppColors.greyTextColor,
//                   fontFamily: AppFontFamily.interRegular,
//                 ),
//               ),
//               hBox(15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     tags[0],
//                     style: AppFontStyle.text_14_400(
//                       AppColors.greyTextColor,
//                       fontFamily: AppFontFamily.interRegular,
//                     ),
//                   ),
//                   Text(
//                     tags[1],
//                     style: AppFontStyle.text_14_400(
//                       AppColors.greyTextColor,
//                       fontFamily: AppFontFamily.interRegular,
//                     ),
//                   ),
//                 ],
//               ),
//               hBox(15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     tags[2],
//                     style: AppFontStyle.text_14_400(
//                       AppColors.greyTextColor,
//                       fontFamily: AppFontFamily.interRegular,
//                     ),
//                   ),
//                   Text(
//                     tags[3],
//                     style: AppFontStyle.text_14_400(
//                       AppColors.greyTextColor,
//                       fontFamily: AppFontFamily.interRegular,
//                     ),
//                   ),
//                 ],
//               ),
//               hBox(15),
//               CustomElevatedButton(
//                 color: AppColors.buttonColor,
//                 text: item["buttonText"],
//                 textStyle: AppFontStyle.text_14_500(
//                   fontFamily: AppFontFamily.interMedium,
//                   AppColors.white,
//                 ),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         );
//       }),
//     ],
//   );
// }
