import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hikaronsfa/Widget/customDialog.dart';
import 'package:hikaronsfa/source/env/address.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/env/formatDate.dart';
import 'package:hikaronsfa/source/env/formatTime.dart';
import 'package:hikaronsfa/source/env/watermarkImage.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'absensi_check_in_state.dart';

class AbsensiCheckInCubit extends Cubit<AbsensiCheckInState> {
  final RepositoryAbsensi? repository;
  AbsensiCheckInCubit({this.repository}) : super(AbsensiCheckInInitial());

  void prosesCheckIn({
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
    XFile? imageFile,
    context,
  }) async {
    emit(AbsensiCheckInLoading());

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var radius = pref.getString("radius");
      var userSalesId = pref.getString("user_as_sales_id");
      var username = pref.getString('username');

      var tanggal = formatDate(DateTime.now());
      var jam = formatDateToTime(DateTime.now());

      final uuid = const Uuid().v4();

      /// ===============================
      /// 🚀 AMBIL LOKASI CEPAT
      /// ===============================
      // Position? position;

      // position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation, timeLimit: const Duration(seconds: 5));

      // double lat = position.latitude;
      // double long = position.longitude;

      print("LAT: $mylatitude LONG: $mylongitude");

      /// ===============================
      /// 🚀 PROSES PARALEL (Alamat + Watermark)
      /// ===============================
      // String alamat = await getFullAddress(latitude: lat, longitude: long);
      final results = await Future.wait([
        addAttendanceWatermark(
          originalXFile: imageFile!,
          status: "Check IN",
          sales: "$username",
          address: "$alamatSaya",
          latitude: "$mylatitude",
          longitude: "$mylongitude",
          customer: customerType == "C" ? "$customerName" : "$nonCustomerName",
        ),
      ]);

      // String alamat = results[0] as String;
      File watermarked = results[0] as File;

      /// ===============================
      /// CEK RADIUS (HANYA UNTUK CUSTOMER)
      /// ===============================
      if (customerType == "C") {
        if (int.parse(myDistance!.toStringAsFixed(0)) > 3000) {
          emit(AbsensiCheckInFailed(statusCode: 0, json: {"message": "Anda berada jauh dari radius : ${myDistance.toStringAsFixed(2)} M"}));
          return;
        }
      }

      /// ===============================
      /// BUILD BODY (SATU SAJA)
      /// ===============================
      var body = FormData.fromMap({
        "attnd_oid": uuid,
        "attnd_type": customerType,
        "attnd_sales_id": userSalesId,
        "attnd_cust_id": customerType == "C" ? "$customerId" : "0",
        "attnd_cust_name": customerType == "C" ? "$customerName" : "$nonCustomerName",
        "attnd_date_in": tanggal,
        "attnd_time_in": jam,
        "attnd_latitude_in": "$mylatitude",
        "attnd_longitude_in": "$mylongitude",
        "attnd_image_in": await MultipartFile.fromFile(watermarked.path, filename: watermarked.path.split('/').last),
        "attnd_loc_desc_in": alamatSaya,
        "attnd_current_status": "IN",
      });

      final response = await repository!.checkIN(body, context);
      if (response == null) {
        emit(AbsensiCheckInFailed(statusCode: 500, json: {"message": "Response kosong"}));
        return;
      }
      var json = response.data;
      var statusCode = response.statusCode;
      print("CHECK IN $json");

      if (statusCode == 200) {
        emit(AbsensiCheckInLoaded(statusCode: statusCode, json: json));
      } else {
        emit(AbsensiCheckInFailed(statusCode: statusCode, json: json));
      }
    } catch (e) {
      // EasyLoading.showError(e.toString());
      emit(AbsensiCheckInFailed(statusCode: 500, json: {"message": e.toString()}));
    }
  }
}
