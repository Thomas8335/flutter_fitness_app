import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_fitness_app/models/workout.dart';

class AddWorkoutPage extends StatefulWidget {
  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> writeWorkout(Workout workout) async {
    var box = Hive.box<Workout>('workouts');
    int key = await box.add(workout);

  }

  void _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      Workout newWorkout = Workout(
        name: _nameController.text,
        reps: int.parse(_repsController.text),
        weight: int.parse(_weightController.text),
      );

      await writeWorkout(newWorkout);

      _nameController.clear();
      _repsController.clear();
      _weightController.clear();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Workout Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _repsController,
                decoration: InputDecoration(labelText: 'Number of Reps'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of reps';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (lbs)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              child: Text('Add Workout'),
              onPressed: _addWorkout,
            ),
          ],
        ),
      ),
    );
  }

}

