import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hikaronsfa/source/repository/RepositoryAuth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'change_foto_profile_state.dart';

class ChangeFotoProfileCubit extends Cubit<ChangeFotoProfileState> {
  final RepositoryAuth? repository;
  ChangeFotoProfileCubit({this.repository}) : super(ChangeFotoProfileInitial());
  void updateFotoProfil(foto, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("user_id");
    var body = FormData.fromMap({"user_id": userId, "foto_profile": await MultipartFile.fromFile(foto!.path, filename: foto!.name)});
    emit(ChangeFotoProfileLoading());
    final response = await repository!.updateFotoProfil(body, context);
    if (response == null) {
      emit(ChangeFotoProfileFailed(statusCode: 500, message: "NO RESPONSE"));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      emit(ChangeFotoProfileLoaded(statusCode: statusCode, message: json['message']));
      pref.setString("foto_profil", json['data']['file']);
    } else {
      emit(ChangeFotoProfileFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
