import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryAuth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final RepositoryAuth? repository;
  ProfileCubit({this.repository}) : super(ProfileInitial());

  void getProfile(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString('username');

    emit(ProfileLoading());
    final response = await repository!.getProfile(username, context);
    if (response == null) {
      emit(ProfileFailed(statusCode: 500, message: "NO RESPONSE"));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode;
    print(json);
    if (statusCode == 200) {
      emit(ProfileLoaded(statusCode: statusCode, message: json['message'], username: json['data']['user_name'], email: json['data']['user_email'], foto: json['data']['foto_profil']??""));
    } else {
      emit(ProfileFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
