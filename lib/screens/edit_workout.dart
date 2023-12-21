import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_fitness_app/models/workout.dart';

//AI helped generate updateWorkout async and saving function & some formatting & debugging state management issues

class EditWorkoutPage extends StatefulWidget {
  final Workout workout;
  final int index;

  EditWorkoutPage({required this.workout, required this.index});

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _repsController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout.name);
    _repsController = TextEditingController(text: widget.workout.reps.toString());
    _weightController = TextEditingController(text: widget.workout.weight.toString());
  }

  Future<void> updateWorkout(Workout updatedWorkout, int index) async {
    var box = Hive.box<Workout>('workouts');
    box.putAt(index, updatedWorkout);

  }

  void _saveUpdatedWorkout() async {
    if (_formKey.currentState!.validate()) {
      Workout updatedWorkout = Workout(
        name: _nameController.text,
        reps: int.parse(_repsController.text),
        weight: int.parse(_weightController.text),
      );

      await updateWorkout(updatedWorkout, widget.index);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Workout'),
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
              child: Text('Save Changes'),
              onPressed: _saveUpdatedWorkout,
            ),
          ],
        ),
      ),
    );
  }
}
