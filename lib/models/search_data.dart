import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:spaceship_service/models/repair_station.dart';

class SearchData extends ChangeNotifier {
  int? _selectedId;
  final List<RepairStation> _filteredStations = [];
  final List<RepairStation> _repairStations = [
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
      price: 35,
      time: const Duration(minutes: 40),
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
      price: 80,
      time: const Duration(minutes: 35),
      image: 'assets/images/repairStation.jpg',
    ),
  ];

  int? get selectedId => _selectedId;

  UnmodifiableListView<RepairStation> get filteredStations =>
      UnmodifiableListView(_filteredStations);

  UnmodifiableListView<RepairStation> get repairStations =>
      UnmodifiableListView(_repairStations);

  void addFilteredStation(RepairStation repairStation) {
    _filteredStations.add(repairStation);
    notifyListeners();
  }

  void clearFilteredStation() {
    _filteredStations.clear();
    notifyListeners();
  }

  void getStations(String? text) {
    clearFilteredStation();
    if (text != null) {
      for (int i = 0; i < repairStations.length; i++) {
        if (repairStations[i].name.toLowerCase().contains(text.toLowerCase()) &&
            !filteredStations.contains(repairStations[i])) {
          addFilteredStation(repairStations[i]);
        }
      }
    }
    notifyListeners();
  }

  void sortList(value) {
    _selectedId = value;
    List<RepairStation> stations = [];

    if (filteredStations.isNotEmpty) {
      stations = _filteredStations;
    } else {
      stations = _repairStations;
    }

    if (selectedId == 1) {
      // sort by rating
      stations.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (selectedId == 2) {
      // sort by price
      stations.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedId == 3) {
      // sort by time
      stations.sort((a, b) => a.time.compareTo(b.time));
    }
    notifyListeners();
  }
}
