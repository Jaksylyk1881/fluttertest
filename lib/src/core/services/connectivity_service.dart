import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    debugPrint('Connection status: $connectivityResult');

    debugPrint(connectivityResult[0] == ConnectivityResult.none
        ? 'No internelt'
        : 'Internet available');

    if (connectivityResult[0] == ConnectivityResult.none) {
      debugPrint('No internet');

      // Get.snackbar(
      //   'No Internet',
      //   'You are not connected to the internet.',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   duration: Duration(days: 1),
      // );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
