import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_fitness_app/models/workout.dart';
import 'add_workout.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Workout> workouts = [];
  late Box<Workout> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Workout>('workouts');
    _loadWorkouts();
  }

  void _loadWorkouts() {
    setState(() {
      workouts = box.values.toList();
      print('Loaded workouts: ${workouts.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker'),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return ListTile(
            title: Text(workout.name),
            subtitle: Text('Reps: ${workout.reps}, Weight: ${workout.weight} lbs'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWorkoutPage()),
          ).then((_) => _loadWorkouts());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

