import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move/main.dart';
import 'package:move/models/workout_model.dart';
import 'package:move/workout_details/workout_history_page.dart';
import 'package:provider/provider.dart';

void main() {
  group('WorkoutHistoryPage Tests', () {
    testWidgets('WorkoutHistoryPage displays workout history correctly',
        (WidgetTester tester) async {
      final mockWorkoutProvider = WorkoutProvider();
      final now = DateTime.now();

      final exercises = [
        Exercise(
            name: 'Push-ups', target: 10, actual: 5, unit: 'Reps', type: 'Reps')
      ];

      await tester.runAsync(() async {
        mockWorkoutProvider.addWorkout(Workout(
          name: "Hardcoded Workout",
          date: now.toIso8601String(),
          exercises: jsonEncode(exercises.map((e) => e.toJson()).toList()),
        ));
      });

      // ✅ Wrap the page in the provider BEFORE building the UI
      await tester.pumpWidget(
        ChangeNotifierProvider<WorkoutProvider>.value(
          value: mockWorkoutProvider,
          child: MaterialApp(
            home: WorkoutHistoryPage(),
          ),
        ),
      );

      await tester.pumpAndSettle(); // ✅ Wait for UI updates

      final formattedDate = now.toIso8601String().split('T')[0];

      // ✅ Verify workout is displayed
      expect(find.text("Hardcoded Workout"), findsOneWidget);
      expect(find.text("Date: $formattedDate"), findsOneWidget);
    });
  });
}
