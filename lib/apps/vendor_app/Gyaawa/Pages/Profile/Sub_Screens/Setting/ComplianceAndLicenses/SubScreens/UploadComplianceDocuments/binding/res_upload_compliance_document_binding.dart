import 'package:get/get.dart';

import '../controller/res_upload_compliance_document_controller.dart';

class ResUploadComplianceDocumentBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResUploadComplianceDocumentController());
  }
}