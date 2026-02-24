import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'calculate_distance_state.dart';

class CalculateDistanceCubit extends Cubit<CalculateDistanceState> {
  CalculateDistanceCubit() : super(CalculateDistanceInitial());

  void initial() {
    emit(CalculateDistanceLoaded(meterPlace: 0));
  }

  void checkMeter({double? latitudePlace, double? mylatitude, double? longitudePlace, double? mylongitude}) {
    num distanceInMeters = Geolocator.distanceBetween(mylatitude!, mylongitude!, latitudePlace!, longitudePlace!);
    emit(CalculateDistanceLoading());
    emit(CalculateDistanceLoaded(meterPlace: distanceInMeters.toDouble()));
  }
}
