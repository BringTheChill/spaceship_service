import 'package:flutter/material.dart';
import 'package:spaceship_service/widgets/custom_stepper.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

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
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: kPrimaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
            ),
          ),
          child: CustomStepper(
            type: stepperType,
            physics: const ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            steps: <Step>[
              Step(
                title: const Text(
                  'Crează \ndeviz',
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'Task1',
                      style: kBoldStyle,
                    ),
                  ],
                ),
                isActive: _currentStep == 0,
                state:
                    _currentStep == 0 ? StepState.indexed : StepState.complete,
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
                state:
                    _currentStep >= 1 ? StepState.indexed : StepState.disabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
