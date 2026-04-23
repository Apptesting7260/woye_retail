import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Utils/snack_bar.dart';

class NetworkController extends GetxController {
  bool isConnected = true;

  @override
  void onInit() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var result = connectivityResult[0];

    if (result == ConnectivityResult.none) {
      isConnected = false;
    } else {
      isConnected = true;
    }
    isConnected != true
        ? Utils.showToast("Internet not connected",
        gravity: ToastGravity.TOP)
        : "";

    super.onInit();
  }
}
