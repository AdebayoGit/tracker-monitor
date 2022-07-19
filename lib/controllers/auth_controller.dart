import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:viewer/components/sign_out_dialog.dart';
import 'package:viewer/services/auth_services.dart';

import '../components/forgot_password_sheet.dart';
import '../helpers/response.dart';
import '../models/response_status.dart';
import '../utils/app_theme.dart';
import '../views/auth_view.dart';
import '../views/custom_navigator.dart';

class AuthController extends GetxController {
  late final AuthServices _services;

  late final User _user;

  @override
  Future<void> onInit() async {
    _services = AuthServices();
    await _listenForUser();
    super.onInit();
  }

  User get user => _user;

  Future<void> _listenForUser() async {
    _services.authStream().listen((User? user) async {
      if (user == null) {
        Get.offAll(
          () => AuthView(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      } else {
        _user = user;
        Get.offAll(
          () => const CustomNavigator(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    ResponseHelpers.showProgressDialog("Please wait...");
    Status status = await _services.signIn(email: email, password: password);
    Get.back();
    ResponseHelpers.showSnackbar(status.response.toString());
  }

  Future<void> signOut() async {
    ResponseHelpers.showProgressDialog("Please wait...");
    Get.back();
    await Get.dialog(
      SignOutDialog(
        yes: () async {
          Status status = await _services.signOut();
          ResponseHelpers.showSnackbar(status.response.toString());
        },
        no: () => Get.back(),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> forgotPassword({required String email}) async {
    ResponseHelpers.showProgressDialog("Please wait...");

    Status status = await _services.forgotPassword(email: email);

    Get.back();

    ResponseHelpers.showSnackbar(status.response.toString());
  }

  Future<void> getForgotPasswordSheet() async{

    await Get.bottomSheet(
      ForgotPasswordSheet(),
      backgroundColor: AppTheme.nearlyWhite,
    );
    return;
  }
}
