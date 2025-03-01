import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move/main.dart';
import 'package:move/models/workout_model.dart';
import 'package:move/widgets/numeric_widget.dart';
import 'package:move/workout_details/workout_recording_page.dart';
import 'package:provider/provider.dart';

void main() {
  group('WorkoutRecordingPage Tests', () {
    testWidgets('Shows input fields for each exercise in the workout plan',
        (WidgetTester tester) async {
      // Set up mock workout data with exercises
      final mockWorkoutProvider = WorkoutProvider();
      final now = DateTime.now();

      final exercises = [
        Exercise(
            name: 'Push-ups',
            target: 10,
            actual: 0,
            unit: 'Reps',
            type: 'Reps'),
      ];

      mockWorkoutProvider.addWorkout(Workout(
        name: "Test Workout",
        date: now.toIso8601String(),
        exercises: jsonEncode(exercises.map((e) => e.toJson()).toList()),
      ));

      // Render the page with the mock provider
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkoutProvider>.value(
            value: mockWorkoutProvider,
            child: Scaffold(
              body: WorkoutRecordingPage(
                workoutPlan: WorkoutPlan(
                  id: 1,
                  name: "Test Workout Plan",
                  exercises:
                      jsonEncode(exercises.map((e) => e.toJson()).toList()),
                  duration: "30 mins",
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for the exercise names
      expect(find.text('Push-ups'), findsOneWidget);

      // Check for the input widgets
      expect(find.byType(NumericInputWidget), findsNWidgets(1));
    });
  });
}
