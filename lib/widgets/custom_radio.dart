import 'package:flutter/material.dart';

class CustomRadio extends StatelessWidget {
  const CustomRadio({
    Key? key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    this.style,
    this.activeColor,
  }) : super(key: key);

  final String label;
  final int? groupValue;
  final int value;
  final Function onChanged;
  final TextStyle? style;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 30,
            child: Radio<int>(
              groupValue: groupValue,
              value: value,
              activeColor: activeColor,
              onChanged: (int? newValue) {
                onChanged(newValue);
              },
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
