class RestaurantGetAddOnModel {
  bool? status;
  List<Addons>? addons;

  RestaurantGetAddOnModel({this.status, this.addons});

  RestaurantGetAddOnModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addons {
  String? id;
  String? name;

  Addons({this.id, this.name});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
// Widget variantSection(RestaurantProductAddController controller) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomCheckboxTile(
//         title: "This product has variants (e.g., different sizes, colors)",
//         value: controller.hasVariants,
//         onChanged: (val) {
//           controller.hasVariants.value = val;
//         },
//       ),
//      hBox(12),
//       Obx(() {
//         if (!controller.hasVariants.value) return SizedBox();
//
//         return Column(
//           children: [
//             // ================= STEP 1 =================
//             AppContainer(
//               borderRadius: BorderRadius.circular(15),
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       stepCircle("1"),
//                     wBox(10),
//                       Text("Select Variant Attributes", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
//                     ],
//                   ),
//                   hBox(12),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: controller.allVariantAttributes.map((attr) {
//                       final selected = controller.selectedVariantAttributes.contains(attr);
//                       return GestureDetector(
//                         onTap: () => controller.toggleAttribute(attr),
//                         child: AppContainer(
//                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           color: selected ? AppColors.primary : AppColors.white,
//                           border: Border.all(color: AppColors.borderClr),
//                           borderRadius: BorderRadius.circular(8),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(attr, style: AppFontStyle.text_12_500(selected ? AppColors.white : AppColors.black,
//                                 fontFamily: AppFontFamily.interMedium,
//                                 ),
//                               ),
//                               if (selected) ...[
//                                 SizedBox(width: 5),
//                                 Icon(Icons.close, size: 14, color: Colors.white),
//                               ],
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   hBox(12),
//                   //Custom Attribute
//                   Obx(() {
//                     return Column(
//                       children: List.generate(
//                         controller.customAttributes.length,
//                             (index) {
//                           final item = controller.customAttributes[index];
//                           final isLast = index == controller.customAttributes.length - 1;
//
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         children: [
//                                           CustomTextFormField(
//                                             controller: item.nameController,
//                                             hintText: index == 0 ? "Attribute name *" : "Attribute name",
//                                             height: 45,
//                                           ),
//                                           const SizedBox(height: 8),
//                                           CustomTextFormField(
//                                             controller: item.valueController,
//                                             hintText: index == 0 ? "Values (comma-separated) *" : "Values (comma-separated)",
//                                             height: 45,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (isLast) ...[
//                                       wBox(10),
//                                       GestureDetector(
//                                         onTap: controller.addCustomAttributeField,
//                                         child: AppContainer(
//                                           height: 70,
//                                           width: 50,
//                                           border: Border.all(color: AppColors.borderClr),
//                                           borderRadius: BorderRadius.circular(8),
//                                           child: const Icon(Icons.add),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               hBox(6),
//                                 if (index != 0)
//                                   GestureDetector(
//                                     onTap: () => controller.removeCustomAttributeField(index),
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.close, color: Colors.red, size: 16),
//                                        wBox(5),
//                                          Text("Remove", style: AppFontStyle.text_12_500(AppColors.red, fontFamily: AppFontFamily.interMedium,),),
//                                       ],
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }),
//                   hBox(12),
//                 ],
//               ),
//             ),
//             hBox(12),
//             // ================= STEP 2 =================
//             Obx(() {
//               if (controller.selectedVariantAttributes.isEmpty) {
//                 return SizedBox();
//               }
//
//               return AppContainer(
//                 borderRadius: BorderRadius.circular(15),
//                 padding: EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         stepCircle("2"),
//                         SizedBox(width: 10),
//                         Text("Configure Attribute Values", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),
//                         ),
//                       ],
//                     ),
//                     hBox(12),
//                     Column(
//                       children: controller.selectedVariantAttributes.map((attr) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(attr, style: AppFontStyle.text_13_500(AppColors.blackTextColor, fontFamily: AppFontFamily.interMedium,),),
//                                 GestureDetector(
//                                   onTap: () => controller.addAttributeValue(attr),
//                                   child: Row(
//                                     children: [
//                                       AppContainer(
//                                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                                         borderRadius: BorderRadius.circular(6),
//                                         border: Border.all(color: AppColors.borderClr),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(Icons.add, size: 14),
//                                           wBox(5),
//                                             Text("Add Value", style: AppFontStyle.text_12_500(AppColors.primary, fontFamily: AppFontFamily.interMedium,),),
//                                           ],
//                                         ),
//                                       ),
//                                       wBox(10),
//                                       AppContainer(
//                                         borderRadius: BorderRadius.circular(4),
//                                         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//                                         child: Icon(Icons.delete_outline, color: AppColors.greyTextColor, size: 22)),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             hBox(15),
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 8,
//                               children: [
//                                 ...controller.attributeValues[attr]!.map((val) {
//                                   return AppContainer(
//                                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                                     color: AppColors.searchText,
//                                     borderRadius: BorderRadius.circular(6),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(val, style: AppFontStyle.text_12_400(AppColors.blackTextColor, fontFamily: AppFontFamily.interMedium,),),
//                                         wBox(5),
//                                         GestureDetector(
//                                           onTap: () => controller.removeAttributeValue(attr, val),
//                                           child: Icon(Icons.close, size: 16, color: AppColors.red),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }),
//                                 Container(
//                                   width: 90,
//                                   height: 34,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     border: Border.all(color: AppColors.borderClr), color: Colors.white),
//                                   child: TextField(
//                                     controller: controller.valueControllers[attr],
//                                     style: AppFontStyle.text_13_400(AppColors.greyTextColor, fontFamily: AppFontFamily.interMedium,),
//                                     decoration: InputDecoration(
//                                       isDense: true,
//                                       border: InputBorder.none,
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6,),
//                                       suffixIcon: GestureDetector(
//                                         onTap: () {
//                                           controller.valueControllers[attr]?.clear();
//                                         },
//                                         child: Icon(Icons.close, size: 16, color: AppColors.red),
//                                       ),
//                                     ),
//                                     onSubmitted: (val) {
//                                       controller.addAttributeValue(attr);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             hBox(12),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                     hBox(12),
//                     CustomElevatedButton(
//                       height: 46,
//                       borderRadius: BorderRadius.circular(8),
//                       onPressed: controller.generateVariants,
//                       child: Text(
//                         "Generate Variant Matrix (9 variants)",
//                         style: AppFontStyle.text_14_500(
//                           Colors.white,
//                           fontFamily: AppFontFamily.interMedium,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//             hBox(12),
//             Obx(() {
//               if (controller.variantList.isEmpty) return SizedBox();
//
//               final tableAttributes = controller.selectedVariantAttributes.where((attr) => attr == "Storage" || attr == "RAM").toList();
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Variant Matrix (${controller.variantList.length})", style: AppFontStyle.text_14_500(
//                         AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
//
//                       AppContainer(
//                         height: 30,
//                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         borderRadius: BorderRadius.circular(6),
//                         onTap: () {
//                           double basePrice = double.tryParse(controller.basePriceController.text.trim()) ?? 0;
//                           int baseStock = int.tryParse(controller.baseStockController.text.trim()) ?? 0;
//
//                           for (var variant in controller.variantList) {
//                             variant.price.value = basePrice;
//                             variant.stock.value = baseStock;
//                           }
//                         },
//                         child: Text("Apply Base Price to All",style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
//                       ),
//                     ],
//                   ),
//                   hBox(12),
//                   Table(
//                     border: TableBorder.all(color: AppColors.borderClr),
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     children: [
//                       TableRow(
//                         children: [
//                           Center(
//                             child: Text("Select", style: AppFontStyle.text_12_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium))),
//                           ...tableAttributes.map((attr) => cell(attr)),
//                           cell("SKU"),
//                           cell("Price"),
//                           cell("Stock"),
//                         ],
//                       ),
//                       ...controller.variantList.map((variant) {
//                         return TableRow(
//                           children: [
//                             Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//                                 child: CustomCheckboxTile(
//                                   value: variant.isSelected,
//                                   onChanged: (v) {
//                                     variant.isSelected.value = v ?? false;
//                                   },
//                                   title: '',
//                                 ),
//                               ),
//                             ),
//
//                             ...tableAttributes.map((attr) => cell(variant.values[attr] ?? "")),
//                             cell("PRD-${variant.sku}"),
//                             cell(variant.price.value.toStringAsFixed(2)),
//
//                             cell(variant.stock.value.toString()),
//                           ],
//                         );
//                       }),
//                     ],
//                   ),
//                   hBox(16),
//                   // Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 120),
//                     child: CustomElevatedButton(
//                       color: AppColors.black,
//                       height: 40.h,
//                       borderRadius: BorderRadius.circular(8),
//                       onPressed: () {
//                         // print("Saving Variants: $variantData");
//                         Get.toNamed(VendorAppRoutes.retailProductReviewScreen);
//                       },
//                       child: Text("Continue to Review", style: AppFontStyle.text_16_500(AppColors.white, fontFamily: AppFontFamily.interMedium)),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ],
//         );
//       }),
//     ],
//   );
// }