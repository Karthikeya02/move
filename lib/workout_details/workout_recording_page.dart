import 'package:flutter/material.dart';
import 'package:move/widgets/seconds_input_widget.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/workout_model.dart';
import '../score_widget.dart';
import '../widgets/meters_input_widget.dart';
import '../widgets/numeric_widget.dart';
import 'dart:core';


class WorkoutRecordingPage extends StatefulWidget {
  const WorkoutRecordingPage({super.key});

  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final List<Exercise> exercises = [
    Exercise(name: 'Push-ups', target: 0, unit: 'Reps', type: 'Reps'),
    Exercise(name: 'Squats', target: 0, unit: 'Reps', type: 'Reps'),
    Exercise(name: 'Plank', target: 0, unit: 'Seconds', type: 'Seconds'),
    Exercise(name: 'Running', target: 0, unit: 'Meters', type: 'Meters'),
    Exercise(name: 'Cycling', target: 0, unit: 'Meters', type: 'Meters'),
    Exercise(name: 'Swimming', target: 0, unit: 'Meters', type: 'Meters'),
    Exercise(name: 'Surfing', target: 0, unit: 'Meters', type: 'Meters'),
  ];


  final Map<int, int> exerciseOutputs = {}; // Stores user inputs

  /// **Saves the recorded workout and updates the global state**
  void _saveWorkout() {
    final exerciseResults = exercises.map((exercise) {
    final achievedOutput = exerciseOutputs[exercises.indexOf(exercise)] ?? 0;
    return ExerciseResult(
      name: exercise.name,
      unit: exercise.unit,
      output: achievedOutput,
    );

    }).toList();

    final workout = Workout(
      name: "Recorded Workout", // Provide a name since it's required
      date: DateTime.now().toIso8601String(), // Keep the current date
      exercises: exercises,
      exerciseResults: exerciseResults,
    );


    // Save workout to state
    Provider.of<WorkoutProvider>(context, listen: false).addWorkout(workout);

    // Navigate back
    Navigator.pop(context);
  }

  /// **Displays the ScoreWidget in a bottom sheet**
  void _showScore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(10),
        child: ScoreWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Workout')),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name, style: const TextStyle(fontSize: 18)),
                _buildInputWidget(index, exercise.type),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showScore(context),
            icon: Icon(Icons.bar_chart),
            label: Text("View Score"),
            backgroundColor: Colors.blueAccent,
          ),
          SizedBox(height: 10), // Spacing between buttons
          FloatingActionButton(
            onPressed: _saveWorkout,
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  /// **Returns the appropriate input widget based on exercise type**
  Widget _buildInputWidget(int index, String type) {
    if (type == 'Meters') {
      return MetersInputWidget(
        onInputChanged: (value) => setState(() => exerciseOutputs[index] = value),
      );
    }
    else if (type == 'Seconds'){
      return SecondsInputWidget(
        onInputChanged: (value) => setState(() => exerciseOutputs[index] = value),
      );
    }
    return NumericInputWidget(
      label: type,
      initialValue: 0,
      onInputChanged: (value) => setState(() => exerciseOutputs[index] = value),
    );
  }
}
