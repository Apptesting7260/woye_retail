
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/api_response.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../model/mapbox_model.dart';

class MapboxService extends GetxService {
  final api = Repository();

  RxString accessToken = "".obs;
  Coordinates? coordinates;
  RxList<String> suggestions = <String>[].obs;

  @override
  void onInit() async {
    accessToken.value = dotenv.env['mapboxKey'] ?? "";
    super.onInit();
  }

  final Rx<ApiResponse<MapBoxModel>> _mapApiData = Rx<ApiResponse<MapBoxModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<MapBoxModel>> get mapApiData => _mapApiData;
  setMapApiData(ApiResponse<MapBoxModel> data){
    return _mapApiData.value = data;
  }

  Future<void> fetchSuggestions(String query) async {
    try {
      final model = await api.mapboxApi(queryParameters: {
        "q": query,
        "access_token": accessToken.value,
      });

      if (model.features == null) {
        suggestions.clear();
        return;
      }

      setMapApiData(ApiResponse.completed(model));

      suggestions.value = model.features!
          .map((f) => f.properties?.fullAddress ?? "")
          .where((e) => e.isNotEmpty)
          .toList();

      pt("Suggestions: $suggestions");
    } catch (e) {
      pt("Error fetching suggestions: $e");
      suggestions.clear();
    }
  }

  void clearSuggestions() => suggestions.clear();

  void selectSuggestion(String value) {
    clearSuggestions();
    pt("Selected location: $value");
  }

  void selectLatLong(String? lat, String? long) {
    if (lat != null && long != null) {
      pt("Selected Lat: $lat, Long: $long");
    }
  }


}
