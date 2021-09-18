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
import 'package:spaceship_service/models/search_data.dart';
import 'package:spaceship_service/models/user.dart';
import 'package:spaceship_service/widgets/custom_radio.dart';

class ResultPage extends StatelessWidget {
  ResultPage({Key? key}) : super(key: key);

  final User user = User(
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

  Widget _buildList(SearchData searchData) {
    List<RepairStation> stations = [];

    if (searchData.filteredStations.isNotEmpty) {
      stations = searchData.filteredStations;
    } else {
      stations = searchData.repairStations;
    }

    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 30),
        shrinkWrap: true,
        itemCount: stations.length,
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
                          stations[index].name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RatingBarIndicator(
                          rating: stations[index].rating,
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
                          'Timp Estimat: ${stations[index].time.inHours} h ${stations[index].time.inMinutes.remainder(60)} min.',
                        ),
                        Text(
                          'Cost Estimat: ${stations[index].price} RON',
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Image.asset(stations[index].image)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onChanged(int? val, SearchData searchData) {
    if (val != null) {
      searchData.sortList(val);
    }
  }

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
                padding: EdgeInsets.only(bottom: 5, top: 20),
                child: Text(
                  'Ofertanți',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Consumer<SearchData>(
                  builder: (context, searchData, child) {
                    return TextField(
                      onSubmitted: (text) {
                        searchData.getStations(text);
                      },
                      onChanged: (text) {
                        searchData.getStations(text);
                      },
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Caută ofertant',
                        suffixIconConstraints:
                            BoxConstraints.tightFor(height: 20),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: Icon(Icons.search),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Consumer<SearchData>(
                  builder: (context, searchData, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'sortare după: ',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                        Flexible(
                          child: CustomRadio(
                            value: 1,
                            groupValue: searchData.selectedId,
                            label: 'Rating',
                            activeColor: kPrimaryColor,
                            onChanged: (int? val) => onChanged(val, searchData),
                          ),
                        ),
                        Flexible(
                          child: CustomRadio(
                            value: 2,
                            groupValue: searchData.selectedId,
                            label: 'Preț',
                            activeColor: kPrimaryColor,
                            onChanged: (int? val) => onChanged(val, searchData),
                          ),
                        ),
                        Flexible(
                          child: CustomRadio(
                            value: 3,
                            groupValue: searchData.selectedId,
                            label: 'Timp',
                            activeColor: kPrimaryColor,
                            onChanged: (int? val) => onChanged(val, searchData),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Consumer<SearchData>(
                builder: (context, searchData, child) => _buildList(searchData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
