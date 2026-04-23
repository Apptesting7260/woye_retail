import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../services/mapbox_services.dart';


class MapboxSearchField extends StatelessWidget {
  final TextEditingController? controller;

  final void Function(String selectedLocation)? onLocationSelected;
  final void Function(String? lat, String? long)? onCoordinatesSelected;
  final String? Function(String?)? validator;
  MapboxSearchField({
    super.key,
    this.controller,
    this.onLocationSelected,
    this.onCoordinatesSelected,
    this.validator,
  });

  final MapboxService mapboxService = Get.find<MapboxService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          validator:validator,
          controller: controller,
          hintText: "Search location...",
          onChanged: (value) async {
            if (value.isEmpty) {
              mapboxService.clearSuggestions();
            } else {
              await mapboxService.fetchSuggestions(value);
            }
          },
        ),

        const SizedBox(height: 5),

        Obx(() {
          final suggestions = mapboxService.suggestions;
          if (suggestions.isEmpty) return const SizedBox();

          return Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey),
              color: Colors.white,
            ),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => Divider(height: 0, color: Colors.grey.withAlpha(100)),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                final features = mapboxService.mapApiData.value.data?.features;
                final coordinates = (features != null && features.length > index)
                    ? features[index].properties?.coordinates
                    : null;

                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    pt("coordinates?.latitude?.toString() ${coordinates?.latitude?.toString()}");
                    pt("coordinates?.longitude?.toString() ${coordinates?.longitude?.toString()}");
                    if (onLocationSelected != null) onLocationSelected!(suggestion);

                    if (onCoordinatesSelected != null) {
                      onCoordinatesSelected!(
                        coordinates?.latitude?.toString(),
                        coordinates?.longitude?.toString(),
                      );

                    }
                    suggestions.clear();
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
