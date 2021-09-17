import 'package:spaceship_service/models/appointment_data.dart';
import 'package:spaceship_service/models/car.dart';

class User {
  final List<Car> cars;
  List<AppointmentData>? appointments;

  User({required this.cars});
}
