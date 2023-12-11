import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int reps;

  @HiveField(2)
  late int weight;

  Workout({required this.name, required this.reps, required this.weight});
}
