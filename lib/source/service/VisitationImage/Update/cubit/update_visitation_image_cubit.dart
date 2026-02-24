import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitImage.dart';
import 'package:meta/meta.dart';

part 'update_visitation_image_state.dart';

class UpdateVisitationImageCubit extends Cubit<UpdateVisitationImageState> {
  final RepositoryVisitImage? repository;
  UpdateVisitationImageCubit({this.repository}) : super(UpdateVisitationImageInitial());
  void updateImage(context) async {
    final formData = FormData();
    print("LAMPIRAN: ${modelEntryImage}");

    for (int i = 0; i < modelEntryImage.length; i++) {
      final a = modelEntryImage[i];
      print("IMAGE TYPE: ${a.visitationdImages.runtimeType}");
      formData.fields.addAll([
        MapEntry('$i[visitationd_oid]', a.visitationdOid ?? ''),
        MapEntry('$i[visitationd_visitation_oid]', a.visitationdVisitationOid ?? ''),
        MapEntry('$i[visitationd_remarks]', a.visitationdRemarks ?? ''),
      ]);

      if (a.visitationdImages is XFile) {
        final XFile imageFile = a.visitationdImages as XFile;
        formData.files.add(MapEntry('$i[visitationd_image]', await MultipartFile.fromFile(imageFile.path, filename: imageFile.name)));
      } else if (a.visitationdImages is String) {
        formData.fields.add(MapEntry('$i[visitationd_image]', a.visitationdImages));
      }
    }

    emit(UpdateVisitationImageLoading());

    final response = await repository!.editVisitImage(formData, context);
    var json = response.data;
    var statusCode = response.statusCode;
    print("FILES : $json");
    if (response == null) {
      emit(UpdateVisitationImageFailed(statusCode: 500, json: {"message": "No Response"}));
      return;
    }

    if (statusCode == 200) {
      emit(UpdateVisitationImageLoaded(statusCode: statusCode, json: json));
    } else {
      emit(UpdateVisitationImageFailed(statusCode: statusCode ?? 500, json: json));
    }
  }
}
