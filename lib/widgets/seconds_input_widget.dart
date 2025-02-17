import 'package:flutter/material.dart';

class SecondsInputWidget extends StatefulWidget {
  final Function(int) onInputChanged;
  final int minSeconds;
  final int maxSeconds;

  const SecondsInputWidget({
    required this.onInputChanged,
    this.minSeconds = 0,
    this.maxSeconds = 300, // Default max to 5 minutes
  });

  @override
  _SecondsInputWidgetState createState() => _SecondsInputWidgetState();
}

class _SecondsInputWidgetState extends State<SecondsInputWidget> {
  int _currentValue = 15; // Default value

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select duration in seconds', style: TextStyle(fontSize: 16)),
        Slider(
          value: _currentValue.toDouble(),
          min: widget.minSeconds.toDouble(),
          max: widget.maxSeconds.toDouble(),
          divisions: (widget.maxSeconds - widget.minSeconds) ~/ 5, // Adjust granularity. Can be adjusted to 1 if needed. Kept 5 for simplicity
          label: '$_currentValue sec',
          activeColor: Colors.orange,
          inactiveColor: Colors.orange.shade200,
          onChanged: (value) {
            setState(() {
              _currentValue = value.round();
            });
            widget.onInputChanged(_currentValue);
          },
        ),
        Text('$_currentValue sec', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
