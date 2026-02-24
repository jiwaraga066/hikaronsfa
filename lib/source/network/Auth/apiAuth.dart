import 'package:hikaronsfa/source/env/env.dart';

class ApiAuth {
  static login() {
    return "$url/api/login";
  }

  static changePassword() {
    return "$url/api/changePassword";
  }

  static updateFotoProfil() {
    return "$url/api/updateFotoProfil";
  }

  static getProfile(username) {
    return "$url/api/getProfile/$username";
  }
}
