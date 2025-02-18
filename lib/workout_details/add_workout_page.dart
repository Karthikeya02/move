import 'package:flutter/material.dart';

class AddWorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Workout Plan")),
      body: Column(
        children: [
          ListTile(
            title: Text("Default Plan"),
            subtitle: Text("Predefined workout exercises"),
            onTap: () {
              Navigator.pushNamed(context, '/workout_recording');
            },
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/download_workout');
              },
              child: Text("Download Workout Plan"),
            ),
          ),
        ],
      ),
    );
  }
}
