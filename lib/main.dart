import 'package:flutter/material.dart';
import 'workout_data.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true, // Enable Material You
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Dynamic theme colors
    ),
    home: WorkoutHistoryPage(),
  ));
}
