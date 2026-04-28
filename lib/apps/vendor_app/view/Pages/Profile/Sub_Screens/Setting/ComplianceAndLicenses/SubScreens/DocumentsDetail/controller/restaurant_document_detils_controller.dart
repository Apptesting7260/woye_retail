
import 'package:get/get.dart';

import '../../../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../model/res_document_details_model.dart';

class RestaurantDocDetailsController extends GetxController{

  final repo = Repository();

  final Rx<ApiResponse<DocumentDetailsModel>> _documentApiData = Rx<ApiResponse<DocumentDetailsModel>>(ApiResponse.loading());
  Rx<ApiResponse<DocumentDetailsModel>>  get documentApiData => _documentApiData;
  setComplianceData(ApiResponse<DocumentDetailsModel> apiData){
    _documentApiData.value = apiData;
  }


  Future<void> getDocumentDetailsApi({required String type})async{
    setComplianceData(ApiResponse.loading());
    var data = {"type" : type};
    repo.getDocDetails(data).then((value) async {
      if(value.status == true){
        setComplianceData(ApiResponse.completed(value));
      }else{
        setComplianceData(ApiResponse.error(value.message.toString()));
      }
    }).onError((error, stackTrace) {
      setComplianceData(ApiResponse.error(error.toString()));
      // Utils.showToast('Error: $error');
      pt('Error: $error');
    },
    );

  }

}