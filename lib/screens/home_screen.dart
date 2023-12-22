import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_fitness_app/models/workout.dart';
import 'add_workout.dart';
import 'edit_workout.dart';

//AI Helped generate code for moving to different screens/page routing & some logic & delete functionality/popup help
//AI Ran through ChatGPT to improve UI appearance


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
    });
  }


  Widget _buildDeleteIcon(BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm"),
            content: Text("Are you sure you want to delete this workout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Yes"),
              ),
            ],
          ),
        ) ?? false;

        if (confirm) {
          await box.deleteAt(index);
          _loadWorkouts();
        }
      },
    );
  }

  Widget _buildWorkoutListTile(Workout workout, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          workout.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Reps: ${workout.reps}, Weight: ${workout.weight} lbs'),
        trailing: _buildDeleteIcon(context, index),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditWorkoutPage(workout: workout, index: index)),
          ).then((_) => _loadWorkouts());
        },
      ),
    );
  }

  Widget _buildWorkoutList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return _buildWorkoutListTile(workout, index);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddWorkoutPage()),
              ).then((_) => _loadWorkouts());
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true, // Center the AppBar title
      ),
      body: ListView(
        children: <Widget>[
          ...workouts.map((workout) {
            int index = workouts.indexOf(workout);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Adjust card margin
              child: _buildWorkoutListTile(workout, index),
            );
          }),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddWorkoutPage()),
                ).then((_) => _loadWorkouts());
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

