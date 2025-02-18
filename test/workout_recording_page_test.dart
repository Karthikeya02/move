import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move/main.dart'; // Assuming this is the entry point
import 'package:move/models/workout_model.dart';
import 'package:move/widgets/meters_input_widget.dart';
import 'package:move/widgets/numeric_widget.dart';
import 'package:move/widgets/seconds_input_widget.dart';
import 'package:move/workout_details/workout_recording_page.dart'; // Assuming the page is here
import 'package:provider/provider.dart';

void main() {
  group('WorkoutRecordingPage Tests', () {
    testWidgets('Shows input fields for each exercise in the workout plan',
        (WidgetTester tester) async {
      // Set up mock workout data with exercises
      final mockWorkoutProvider = WorkoutProvider();
      final now = DateTime.now();
      mockWorkoutProvider.addWorkout(Workout(
        date: now.toString(),
        exerciseResults: [
          ExerciseResult('Push-ups', 'Reps', 7),
          ExerciseResult('Plank', 'Seconds', 4),
          ExerciseResult('Cycling', 'Meters', 1),
          ExerciseResult('Running', 'Meters', 1),
          ExerciseResult('Swimming', 'Meters', 1),
          ExerciseResult('Squats', 'Reps', 1),
        ],
        exercises: [],
      ));

      // Render the page with the mock provider
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkoutProvider>.value(
            value: mockWorkoutProvider,
            child: Scaffold(
              body:
                  WorkoutRecordingPage(), // The page containing the input fields for exercises
            ),
          ),
        ),
      );

      // Wait for the widget to build and settle
      await tester.pumpAndSettle();

      // Check for the exercise names to ensure they are displayed
      expect(find.text('Push-ups'), findsOneWidget);
      expect(find.text('Plank'), findsOneWidget);
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Cycling'), findsOneWidget);
      expect(find.text('Squats'), findsOneWidget);

      // Check for the input widgets
      expect(find.byType(NumericInputWidget), findsNWidgets(2));
      expect(find.byType(SecondsInputWidget), findsNWidgets(1));
      expect(find.byType(MetersInputWidget), findsNWidgets(2));
    });
  });
}
