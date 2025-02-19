import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:move/main.dart'; // Import the main app to access the page
import 'package:move/models/workout_model.dart'; // Assuming the WorkoutProvider uses Workout model
import 'package:move/workout_details/workout_history_page.dart';
import 'package:provider/provider.dart';

void main() {
  group('WorkoutHistoryPage Tests', () {
    testWidgets('WorkoutHistoryPage', (WidgetTester tester) async {
      final mockWorkoutProvider = WorkoutProvider();
      final now = DateTime.now();
      mockWorkoutProvider.addWorkout(Workout(
        name: "Your Workout",
        date: now.toString(),
      ));

      // Render the page with the mock provider
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WorkoutProvider>.value(
            value: mockWorkoutProvider,
            child: Scaffold(
              body:
                  WorkoutHistoryPage(), // Page that shows the list of workouts
            ),
          ),
        ),
      );

      await tester.pump();

      final formattedTimestamp1 = DateFormat('yyyy-MM-dd h:mm a').format(now);

      expect(find.text(formattedTimestamp1), findsOneWidget);
    });
  });
}
