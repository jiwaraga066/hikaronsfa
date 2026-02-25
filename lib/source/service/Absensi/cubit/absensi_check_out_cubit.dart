import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hikaronsfa/source/env/address.dart';
import 'package:hikaronsfa/source/env/formatDate.dart';
import 'package:hikaronsfa/source/env/formatTime.dart';
import 'package:hikaronsfa/source/env/watermarkImage.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'absensi_check_out_state.dart';

class AbsensiCheckOutCubit extends Cubit<AbsensiCheckOutState> {
  final RepositoryAbsensi? repository;
  AbsensiCheckOutCubit({this.repository}) : super(AbsensiCheckOutInitial());

  void prosesCheckOut({
    String? oid,
    int? customerId,
    String? customerName,
    String? nonCustomerName,
    String? customerType,
    double? latitudePlace,
    double? mylatitude,
    double? longitudePlace,
    double? mylongitude,
    double? myDistance,
    String? alamatSaya,
    String? attndType,
    XFile? imageFile,
    context,
  }) async {
    emit(AbsensiCheckOutLoading());

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var userAsSalesId = pref.getString("user_as_sales_id");
      var username = pref.getString('username');
      var radius = pref.getString("radius");

      var tanggal = formatDate(DateTime.now());
      var jam = formatDateToTime(DateTime.now());

      final results = await Future.wait([
        addAttendanceWatermark(
          originalXFile: imageFile!,
          status: "Check OUT",
          sales: "$username",
          address: "$alamatSaya",
          latitude: "$mylatitude",
          longitude: "$mylongitude",
          customer: "$customerName",
        ),
      ]);

      // String alamat = results[0] as String;
      File watermarked = results[0] as File;

      if (attndType == "C") {
        if (int.parse(myDistance!.toStringAsFixed(0)) > 3000) {
          emit(AbsensiCheckOutFailed(statusCode: 0, json: {"message": "Anda berada jauh dari radius : ${myDistance.toStringAsFixed(2)} M"}));
          return;
        }
      }

      var body = FormData.fromMap({
        "attnd_date_out": tanggal,
        "attnd_time_out": jam,
        "attnd_latitude_out": "$mylatitude",
        "attnd_longitude_out": "$mylongitude",
        "attnd_image_out": await MultipartFile.fromFile(watermarked.path, filename: watermarked.path.split('/').last),
        "attnd_loc_desc_out": alamatSaya,
        "attnd_current_status": "OUT",
        "user_as_sales_id": userAsSalesId,
        "attnd_oid": oid,
      });
      print("BODY: $body");
      final response = await repository!.checkOUT(body, context);

      if (response == null) {
        emit(AbsensiCheckOutFailed(statusCode: 500, json: {"message": "Response kosong"}));
        return;
      }
      var json = response.data;
      var statusCode = response.statusCode;
      print("CHECK OUT $json");
      if (statusCode == 200 && json?['data'] != null) {
        emit(AbsensiCheckOutLoaded(statusCode: statusCode, json: json));
      } else {
        emit(AbsensiCheckOutFailed(statusCode: statusCode ?? 500, json: json));
      }
    } catch (e) {
      print(e);
      EasyLoading.showError(e.toString());
      emit(AbsensiCheckOutFailed(statusCode: 500, json: {"message": e.toString()}));
    }
  }
}
