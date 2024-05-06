import 'package:isar/isar.dart';

import 'course.dart';

part 'student.g.dart';

// Create a Student Collection with id, name and courses
@Collection()
class Student {
  Id id = Isar.autoIncrement;
  late String name;
  final courses = IsarLinks<Course>();
}