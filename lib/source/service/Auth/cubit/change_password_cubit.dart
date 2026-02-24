import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryAuth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final RepositoryAuth? repository;
  ChangePasswordCubit({this.repository}) : super(ChangePasswordInitial());

  void changePassword(password, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("user_id");
    var body = {"userid": userId, "new_password": password};
    emit(ChangePasswordLoading());
    final response = await repository!.changePassword(body, context);
    if (response == null) {
      emit(ChangePasswordFailed(statusCode: 500, message: "NO RESPONSE"));
      return;
    }
    var json = response.data;
    var statusCode= response.statusCode;
    if (statusCode == 200) {
      emit(ChangePasswordLoaded(statusCode: statusCode, message: json['message']));
    } else {
      emit(ChangePasswordFailed(statusCode: statusCode, message: json['message']));

    }
  }
}
