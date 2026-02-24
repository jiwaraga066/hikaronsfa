import 'package:hikaronsfa/Widget/customDialog.dart';
import 'package:hikaronsfa/source/env/internetCheck.dart';
import 'package:hikaronsfa/source/network/Auth/apiAuth.dart';
import 'package:hikaronsfa/source/network/network.dart';

class RepositoryAuth {
  Future login(body, context) async {
    // if (await internetChecker()) {
    var json = await network(url: ApiAuth.login(), method: "POST", body: body, context: context);
    return json;
    // } else {
    //   MyDialog.dialogAlert(context, "Maaf, Ada Kesalahan Jaringan !");
    // }
  }

  Future changePassword(body, context) async {
    // if (await internetChecker()) {
    var json = await network(url: ApiAuth.changePassword(), method: "POST", body: body, context: context);
    return json;
    // } else {
    //   MyDialog.dialogAlert(context, "Maaf, Ada Kesalahan Jaringan !");
    // }
  }
  Future updateFotoProfil(body, context) async {
    // if (await internetChecker()) {
    var json = await network(url: ApiAuth.updateFotoProfil(), method: "POST", body: body, context: context);
    return json;
    // } else {
    //   MyDialog.dialogAlert(context, "Maaf, Ada Kesalahan Jaringan !");
    // }
  }
  Future getProfile(username, context) async {
    // if (await internetChecker()) {
    var json = await network(url: ApiAuth.getProfile(username), method: "GET", body: null, context: context);
    return json;
    // } else {
    //   MyDialog.dialogAlert(context, "Maaf, Ada Kesalahan Jaringan !");
    // }
  }
}
