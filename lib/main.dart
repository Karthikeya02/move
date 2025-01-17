import 'package:flutter/material.dart';
import 'workout_data.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: WorkoutHistoryPage(),
  ));
}
