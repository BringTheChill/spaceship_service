import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spaceship_service/constants.dart';
import 'package:spaceship_service/models/appointment_data.dart';
import 'package:spaceship_service/models/cart_item.dart';
import 'package:spaceship_service/models/product.dart';
import 'package:spaceship_service/pages/result_page.dart';
import 'package:spaceship_service/time_utils.dart';
import 'package:spaceship_service/widgets/custom_stepper.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  List<String> columnNames = ['Produs', 'Cantitate', 'Preț Unitar', 'Total'];

  TextEditingController quantityController = TextEditingController();
  String? productText;
  Product? selectedProduct;
  List<Product> availableProducts = [
    Product(
      name: 'Rulment',
      price: 50,
    ),
    Product(
      name: 'Tobă sport',
      price: 100,
    ),
    Product(
      name: 'Filtru ulei',
      price: 25.50,
    ),
  ];
  List<TimeOfDay> times = [];

  addCartItem() {
    bool isRealProduct =
        availableProducts.any((element) => element.name == productText);
    if (isRealProduct) {
      selectedProduct = availableProducts
          .firstWhere((element) => element.name == productText);
    }
    setState(() {
      if (selectedProduct != null && quantityController.text.isNotEmpty) {
        CartItem alreadyExist =
            Provider.of<AppointmentData>(context, listen: false)
                .cartItems
                .firstWhere((element) => element.product == selectedProduct,
                    orElse: () {
          return CartItem(
            product: Product(
              name: 'noItem',
              price: 0,
            ),
            quantity: 1,
          );
        });
        if (alreadyExist.product.name != 'noItem') {
          alreadyExist.quantity += int.parse(quantityController.text);
        } else {
          Provider.of<AppointmentData>(context, listen: false).addCartItem(
            CartItem(
              product: availableProducts
                  .firstWhere((element) => element == selectedProduct),
              quantity: int.parse(quantityController.text),
            ),
          );
        }
      } else if (quantityController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Adaugă te rog o cantitate.');
      } else {
        Fluttertoast.showToast(msg: 'Acest produs nu este disponibil.');
      }
    });
  }

  DateTime? _selectedDay;
  int selectedIndex = -1;

  // get time slots by saying start time, end time and step
  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  List<TimeOfDay> _getTimeForDay(DateTime day) {
    return kTime[day] ?? [];
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 0 &&
        Provider.of<AppointmentData>(context, listen: false)
            .cartItems
            .isEmpty) {
      Fluttertoast.showToast(
        msg: "Adaugă ceva dacă vrei să continui",
      );
    } else if (_currentStep == 1) {
      if (selectedIndex == -1) {
        Fluttertoast.showToast(
          msg: "Selectează o oră pentru a continua.",
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(),
          ),
        );
      }
    } else {
      productText = null;
      selectedProduct = null;
      _currentStep < 1 ? setState(() => _currentStep += 1) : null;
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    times = getTimes(
      const TimeOfDay(hour: 08, minute: 00),
      const TimeOfDay(hour: 16, minute: 00),
      const Duration(hours: 1),
    ).map((tod) => tod).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: kPrimaryColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomStepper(
                    type: stepperType,
                    physics: const ClampingScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (step) => tapped(step),
                    onStepContinue: continued,
                    onStepCancel: cancel,
                    steps: <Step>[
                      Step(
                        title: const Text(
                          'Crează \ndeviz',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 20, top: 20),
                              child: Text(
                                'Task 1',
                                style: kBoldStyle,
                              ),
                            ),
                            Consumer<AppointmentData>(
                              builder: (context, appointment, child) {
                                return Table(
                                  border: const TableBorder(
                                    horizontalInside:
                                        BorderSide(color: Colors.grey),
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const <int, TableColumnWidth>{
                                    0: FlexColumnWidth(64),
                                    1: FlexColumnWidth(64),
                                    2: FlexColumnWidth(64),
                                    3: FlexColumnWidth(34),
                                    4: FlexColumnWidth(34),
                                  },
                                  children: [
                                    TableRow(
                                      children: <Widget>[
                                        for (int i = 0;
                                            i < columnNames.length;
                                            i += 1)
                                          Padding(
                                            padding: i == 0
                                                ? const EdgeInsets.only(
                                                    left: 10)
                                                : EdgeInsets.zero,
                                            child: Text(
                                              columnNames[i],
                                              textAlign: i != 0
                                                  ? TextAlign.center
                                                  : null,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        const Text(''),
                                      ],
                                    ),
                                    for (int i = 0;
                                        i < appointment.cartItems.length;
                                        i += 1)
                                      TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              appointment
                                                  .cartItems[i].product.name,
                                              style: kTableCellStyle,
                                            ),
                                          ),
                                          Text(
                                            appointment.cartItems[i].quantity
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: kTableCellStyle,
                                          ),
                                          Text(
                                            '${appointment.cartItems[i].product.price}',
                                            textAlign: TextAlign.center,
                                            style: kTableCellStyle,
                                          ),
                                          Text(
                                            '${appointment.cartItems[i].total}',
                                            textAlign: TextAlign.center,
                                            style: kTableCellStyle,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              appointment.removeCartItem(i);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Autocomplete<Product>(
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text.isEmpty) {
                                            return const Iterable<
                                                Product>.empty();
                                          } else {
                                            return availableProducts.where(
                                                (Product element) => element
                                                    .name
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(textEditingValue
                                                        .text
                                                        .toLowerCase()));
                                          }
                                        },
                                        onSelected: (Product selection) {
                                          selectedProduct = selection;
                                        },
                                        fieldViewBuilder: (context, controller,
                                            focusNode, onEditingComplete) {
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            onChanged: (text) {
                                              setState(() {
                                                productText = text;
                                                if (selectedProduct != null &&
                                                    selectedProduct!.name !=
                                                        text) {
                                                  selectedProduct = null;
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: const Icon(
                                                Icons.search,
                                                size: 20,
                                              ),
                                              hintText:
                                                  availableProducts.first.name,
                                              suffixIconConstraints:
                                                  const BoxConstraints.tightFor(
                                                      height: 20),
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: TextField(
                                      controller: quantityController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        hintText: '0',
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: addCartItem,
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        isActive: _currentStep == 0,
                        state: _currentStep == 0
                            ? StepState.indexed
                            : StepState.complete,
                      ),
                      Step(
                        title: const Text(
                          'Stabilește \nora',
                          textAlign: TextAlign.center,
                        ),
                        content: Consumer<AppointmentData>(
                          builder: (context, appointment, child) {
                            return Column(
                              children: <Widget>[
                                TableCalendar<TimeOfDay>(
                                  calendarStyle: const CalendarStyle(
                                    markerSize: 0,
                                    selectedDecoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  focusedDay: appointment.date,
                                  calendarFormat: CalendarFormat.week,
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                  ),
                                  selectedDayPredicate: (day) =>
                                      isSameDay(_selectedDay, day),
                                  eventLoader: _getTimeForDay,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  onDaySelected: (DateTime selectedDay,
                                      DateTime focusedDay) {
                                    if (!isSameDay(_selectedDay, selectedDay)) {
                                      setState(() {
                                        _selectedDay = selectedDay;
                                        selectedIndex = -1;
                                      });
                                      appointment.changeDate(focusedDay);
                                    }
                                  },
                                  onPageChanged: (focusedDay) {
                                    appointment.date = focusedDay;
                                  },
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: times.length,
                                  physics: const ScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.landscape
                                            ? 9
                                            : 3,
                                  ),
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: kTime[appointment.date] != null &&
                                            kTime[appointment.date]!
                                                .contains(times[index])
                                        ? null
                                        : () {
                                            setState(() {
                                              selectedIndex = index;
                                              appointment.date = DateTime(
                                                appointment.date.year,
                                                appointment.date.month,
                                                appointment.date.day,
                                                times[index].hour,
                                                times[index].minute,
                                              );
                                            });
                                          },
                                    child: Card(
                                      color: selectedIndex == index
                                          ? kPrimaryColor
                                          : kTime[appointment.date] != null &&
                                                  kTime[appointment.date]!
                                                      .contains(times[index])
                                              ? Colors.transparent
                                              : null,
                                      child: GridTile(
                                        child: Center(
                                          child: Text(
                                            times[index].format(context),
                                            style: TextStyle(
                                              color: selectedIndex == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        isActive: _currentStep == 1,
                        state: _currentStep < 1
                            ? StepState.disabled
                            : StepState.indexed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
