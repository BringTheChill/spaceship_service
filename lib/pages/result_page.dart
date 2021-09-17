import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaceship_service/constants.dart';
import 'package:spaceship_service/models/appointment_data.dart';
import 'package:spaceship_service/models/car.dart';
import 'package:spaceship_service/models/repair_station.dart';
import 'package:spaceship_service/models/user.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  User user = User(
    cars: [
      Car(
        manufacturer: 'SEAT',
        year: '2007',
        model: 'Ibiza',
        image: 'assets/images/ibiza.jpg',
      ),
      Car(
        manufacturer: 'HYUNDAI',
        year: '2021',
        model: 'Bayon',
        image: 'assets/images/bayon.jpeg',
      ),
    ],
  );
  List<RepairStation> repairStations = [
    RepairStation(
      name: 'EasyRepair',
      rating: 3.5,
      price: 30,
      time: const Duration(minutes: 30),
      image: 'assets/images/repairStation.jpg',
    ),
    RepairStation(
      name: 'FixAndGO',
      rating: 5,
      price: 50,
      time: const Duration(hours: 1),
      image: 'assets/images/repairStation.jpg',
    ),
    RepairStation(
      name: 'BetterMotorWorks',
      rating: 1,
      price: 60,
      time: const Duration(minutes: 10),
      image: 'assets/images/repairStation.jpg',
    ),
    RepairStation(
      name: 'GalaxySRL',
      rating: 4,
      price: 30,
      time: const Duration(minutes: 30),
      image: 'assets/images/repairStation.jpg',
    ),
    RepairStation(
      name: 'StarService',
      rating: 2,
      price: 20,
      time: const Duration(hours: 1, minutes: 30),
      image: 'assets/images/repairStation.jpg',
    ),
    RepairStation(
      name: 'SpaceshipDone',
      rating: 3,
      price: 30,
      time: const Duration(minutes: 30),
      image: 'assets/images/repairStation.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Programarea P1',
                  style: kBoldStyle,
                ),
              ),
              Consumer<AppointmentData>(
                builder: (context, appointment, child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      DateFormat('dd.MM.yyyy hh:mm').format(appointment.date),
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              Consumer<AppointmentData>(
                builder: (context, appointment, child) {
                  return SizedBox(
                    height: 80,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 10),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: user.cars.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            appointment.changeCar(user.cars[i]);
                          },
                          child: Card(
                            color: appointment.car == user.cars[i]
                                ? Colors.green
                                : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  user.cars[i].image,
                                  height: 80,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 20, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${user.cars[i].manufacturer} ${user.cars[i].model}'),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          user.cars[i].year,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  'Ofertanți',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 30),
                  shrinkWrap: true,
                  itemCount: repairStations.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) => GestureDetector(
                    child: SizedBox(
                      height: 150,
                      child: Card(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    repairStations[index].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  RatingBarIndicator(
                                    rating: repairStations[index].rating,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 15.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Text(
                                    'Timp Estimat: ${repairStations[index].time.inHours} h ${repairStations[index].time.inMinutes.remainder(60)} min.',
                                  ),
                                  Text(
                                    'Cost Estimat: ${repairStations[index].price} RON',
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Image.asset(repairStations[index].image)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
