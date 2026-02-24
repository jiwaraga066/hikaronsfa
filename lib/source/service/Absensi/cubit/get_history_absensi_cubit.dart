import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Absensi/modelHistoryAbsensi.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_history_absensi_state.dart';

class GetHistoryAbsensiCubit extends Cubit<GetHistoryAbsensiState> {
  final RepositoryAbsensi? repository;
  GetHistoryAbsensiCubit({this.repository}) : super(GetHistoryAbsensiInitial());

  void initial() {
    emit(GetHistoryAbsensiInitial());
  }

  void getHistory(tahun, bulan, type, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesId = pref.getString("user_as_sales_id");
    var body = {
      "tahun": tahun, "bulan": bulan,
      // "tipe_customer": type,
      "sales_id": salesId,
    };
    print(body);
    emit(GetHistoryAbsensiLoading());
    final response = await repository!.getHistoryAbsensi(body, context);
    if (response == null) {
      emit(GetHistoryAbsensiFailed(statusCode: 500, message: "NO RESPONSE"));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      emit(GetHistoryAbsensiLoaded(statusCode: statusCode, message: json['message'], model: modelHistoryAbsensiFromJson(jsonEncode(json['data']))));
    } else {
      emit(GetHistoryAbsensiFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
