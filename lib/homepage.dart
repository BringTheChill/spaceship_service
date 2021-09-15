import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:spaceship_service/widgets/custom_stepper.dart';

import 'constants.dart';
import 'models/cart_item.dart';
import 'models/product.dart';

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
  // List<Product> selectedProducts = [];
  List<CartItem> cartItems = [];

  addProduct() {
    setState(() {
      if (selectedProduct != null && quantityController.text.isNotEmpty) {
        CartItem alreadyExist = cartItems.firstWhere(
            (element) => element.product == selectedProduct, orElse: () {
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
          cartItems.add(
            CartItem(
              product: availableProducts
                  .firstWhere((element) => element == selectedProduct),
              quantity: int.parse(quantityController.text),
            ),
          );
        }
      }
    });
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 1 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
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
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 40.0,
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
                                Table(
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
                                  children: <TableRow>[
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
                                        i < cartItems.length;
                                        i += 1)
                                      TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              cartItems[i].product.name,
                                              style: kTableCellStyle,
                                            ),
                                          ),
                                          Text(
                                            cartItems[i].quantity.toString(),
                                            textAlign: TextAlign.center,
                                            style: kTableCellStyle,
                                          ),
                                          Text(
                                            '${cartItems[i].product.price}',
                                            textAlign: TextAlign.center,
                                            style: kTableCellStyle,
                                          ),
                                          Text(
                                            '${cartItems[i].quantity * cartItems[i].product.price}',
                                            textAlign: TextAlign.center,
                                            style: kTableCellStyle,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                cartItems.remove(cartItems[i]);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  100) *
                                              30,
                                          child: Autocomplete<Product>(
                                            optionsBuilder: (TextEditingValue
                                                textEditingValue) {
                                              if (textEditingValue
                                                  .text.isEmpty) {
                                                return const Iterable<
                                                    Product>.empty();
                                              } else {
                                                return availableProducts.where(
                                                    (Product element) => element
                                                        .name
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(
                                                            textEditingValue
                                                                .text
                                                                .toLowerCase()));
                                              }
                                            },
                                            onSelected: (Product selection) {
                                              selectedProduct = selection;
                                            },
                                            fieldViewBuilder: (context,
                                                controller,
                                                focusNode,
                                                onEditingComplete) {
                                              return TextField(
                                                controller: controller,
                                                focusNode: focusNode,
                                                onChanged: (text) {
                                                  setState(() {
                                                    if (selectedProduct !=
                                                            null &&
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
                                                  suffixIconConstraints:
                                                      const BoxConstraints
                                                          .tightFor(height: 20),
                                                  hintText: availableProducts
                                                      .first.name,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    100) *
                                                10,
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
                                        onPressed: addProduct,
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                        ),
                                      ),
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
                            content: Column(
                              children: const <Widget>[],
                            ),
                            isActive: _currentStep == 1,
                            state: _currentStep < 1
                                ? StepState.disabled
                                : StepState.indexed,
                          ),
                        ],
                      ),
                    ),
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
