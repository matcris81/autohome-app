import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 6.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
        activeTrackColor: Color(0xFF2196F3),
        inactiveTrackColor: Color(0xFFBDBDBD),
        thumbColor: Colors.white,
        overlayColor: Color(0x292196F3),
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 3.5),
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.blueAccent,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
        value: value,
        min: 0,
        max: 100,
        divisions: 100,
        label: '${value.round()}%',
        onChanged: onChanged,
      ),
    );
  }
}
