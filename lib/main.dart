import 'package:flutter/material.dart';
import 'pages/workout_history_page.dart'; // Update import path

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WorkoutHistoryPage(), // Entry point updated to use the new structure
  ));
}
