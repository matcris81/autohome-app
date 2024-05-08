import 'package:flutter/material.dart';

class ControlWidget extends StatelessWidget {
  final String controlType;

  const ControlWidget({
    Key? key,
    required this.controlType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (controlType) {
      case 'Toggle':
        return Switch(value: true, onChanged: (newValue) {});
      case 'Slider':
        return Slider(value: 0.5, onChanged: (newValue) {});
      // Add other cases for your control types
      default:
        return SizedBox(); // Fallback for unknown control types
    }
  }
}
