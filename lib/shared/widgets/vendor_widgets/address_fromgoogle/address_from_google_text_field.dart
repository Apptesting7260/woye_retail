import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../theme/colors.dart';
import '../../../theme/font_family.dart';
import '../../../theme/font_style.dart';
import '../circular_progress_indicator.dart';
import 'modal/google_location_model.dart';

class AddressFromGoogleAPI extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final Future<Predictions>? Function(Predictions)? onSelected;
  final Future<List<Predictions>> Function(String)? suggestionsCallback;
  final Widget Function(BuildContext, Predictions)? itemBuilder;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutSide;

  const AddressFromGoogleAPI({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.validator,
    required this.onSelected,
    required this.suggestionsCallback,
    this.itemBuilder,
    this.onTap,
    this.onTapOutSide,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Predictions>(
      offset: const Offset(0, -19),
      suggestionsCallback: (query) async {
        final results = await suggestionsCallback!(query);
        return results.toList();
      },
      hideOnEmpty: controller.text == "" ? true : false,
      onSelected: (selected) async {
        onSelected!(selected);
      },
      loadingBuilder: (context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circularProgressIndicator2(),
          ],
        );
      },
      controller: controller,
      builder: (context, controller, focusNode) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            TextFormField(
              onTap: onTap,
              onTapOutside: onTapOutSide ,
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                errorStyle:  AppFontStyle.text_12_400(
                  AppColors.errorColor,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                // errorBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: AppColors.primary),
                //   borderRadius: BorderRadius.all(Radius.circular(15.r)),
                // ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(14.r)),
                ),
                hintText: hintText,
                // prefixIcon: Padding(
                //   padding: REdgeInsets.all(15),
                //   child: SvgPicture.asset(
                //     ImageConstants.locationImage,
                //     height: 19,
                //     width: 19,
                //   ),
                // ),
                hintStyle: AppFontStyle.text_14_400(AppColors.searchText,fontFamily: AppFontFamily.gilroyRegular),
                isDense: true,
                contentPadding:
                    REdgeInsets.symmetric(vertical: 15, horizontal: 10),
                filled: true,
                fillColor: AppColors.filledClr.withAlpha(150),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(14.r)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(14.r)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(14.r)),
                ),
              ),
            ),
            // Positioned(
            //   right: 10,
            //   top: 5,
            //   child: Container(
            //     width: 20,
            //     height: 20,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       shape: BoxShape.circle,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.6),
            //           spreadRadius: 2,
            //           blurRadius: 6,
            //           offset: const Offset(0, 3),
            //         ),
            //       ],
            //     ),
            //     child: Center(
            //       child: GestureDetector(
            //         child: const Icon(
            //           Icons.clear,
            //           size: 15,
            //         ),
            //         onTap: () {
            //           controller.clear();
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
      itemBuilder: itemBuilder!,
    );
  }
}

// class AddressSearchWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final ValueChanged<String> onChanged;
//   final FormFieldValidator<String> validator;
//   final Function(Predictions) onSelected;
//
//   AddressSearchWidget({
//     required this.controller,
//     required this.hintText,
//     required this.onChanged,
//     required this.validator,
//     required this.onSelected,
//   });
//
//   List<Predictions> searchPlace = [];
//   String googleAPIKey = "AIzaSyDmk0hMehi2j2nIi_TxaK8-ovJ3ZsQ1tyk";
//
//   @override
//   Widget build(BuildContext context) {
//     return TypeAheadField<Predictions>(
//       suggestionsCallback: (pattern) async {
//         if (pattern.isEmpty) return [];
//         return await searchAutocomplete(pattern);
//       },
//       hideOnEmpty: controller.text == "" ? true : false,
//       onSelected: (suggestion) {
//         controller.text = suggestion.description ?? "";
//         _getLatLang(controller.text);
//         onSelected(suggestion); // Trigger the onSelected callback
//       },
//       controller: controller,
//       builder: (context, controller, focusNode) {
//         return Stack(
//           alignment: Alignment.topRight,
//           children: [
//             TextFormField(
//               controller: controller,
//               focusNode: focusNode,
//               onChanged: onChanged,
//               // Trigger the onChanged callback
//               validator: validator,
//               // Use the validator to validate input
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 // Use the passed hintText
//                 hintStyle: AppFontStyle.text_14_400(AppColors.hintText),
//                 isDense: true,
//                 contentPadding:
//                     REdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                 fillColor: Colors.transparent,
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.textFieldBorder),
//                   borderRadius: BorderRadius.all(Radius.circular(15.r)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.textFieldBorder),
//                   borderRadius: BorderRadius.all(Radius.circular(15.r)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.textFieldBorder),
//                   borderRadius: BorderRadius.all(Radius.circular(15.r)),
//                 ),
//               ),
//             ),
//             controller.text.isNotEmpty
//                 ? Positioned(
//                     right: 10,
//                     top: 5,
//                     child: Container(
//                       width: 20,
//                       height: 20,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.6),
//                             spreadRadius: 2,
//                             blurRadius: 6,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: GestureDetector(
//                           child: Icon(
//                             Icons.clear,
//                             size: 15,
//                           ),
//                           onTap: () {
//                             controller.clear();
//                           },
//                         ),
//                       ),
//                     ),
//                   )
//                 : const SizedBox(),
//           ],
//         );
//       },
//       itemBuilder: (context, Predictions suggestion) {
//         return ListTile(
//           title: Text(
//             suggestion.description ?? "",
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//         );
//       },
//     );
//   }
//
//   Future<List<Predictions>> searchAutocomplete(String query) async {
//     Uri uri =
//         Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
//       "input": query,
//       "key": googleAPIKey,
//     });
//
//     try {
//       final response = await http.get(uri);
//       if (response.statusCode == 200) {
//         final parse = jsonDecode(response.body);
//         if (parse['status'] == "OK") {
//           SearchPlaceModel searchPlaceModel = SearchPlaceModel.fromJson(parse);
//           return searchPlaceModel.predictions ?? [];
//         }
//       }
//     } catch (err) {
//       print("Error: $err");
//     }
//     return [];
//   }
//
//   Future<void> _getLatLang(String address) async {
//     List<Location> locations = await locationFromAddress(address);
//     if (locations.isNotEmpty) {
//       var first = locations.first;
//       double lat = first.latitude;
//       double long = first.longitude;
//       print("Latitude: $lat, Longitude: $long");
//     }
//   }
// }
