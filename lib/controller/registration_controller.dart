import 'package:fluttertoast/fluttertoast.dart';
import '../model/registration_model.dart';

class RegistrationController {
  final RegistrationModel _model = RegistrationModel();

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String org,
    required Function onSuccess,
    required Function(String message) onError,
  }) async {
    var response = await _model.registerUser(
      name: name,
      email: email,
      password: password,
      org: org,
    );

    if (response['status'] == 201) {
      Fluttertoast.showToast(msg: "Registration successful");
      onSuccess();
    } else {
      String errorMessage = response['message'] ?? "Server error. Please try again.";
      if (response['data'] != null && response['data'].containsKey('email')) {
        errorMessage = response['data']['email'][0];
      }
      onError(errorMessage);
    }
  }
}
