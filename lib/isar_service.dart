import 'package:isar/isar.dart';
import 'package:isar_db_tutorial/entities/course.dart';
import 'package:isar_db_tutorial/entities/student.dart';
import 'package:isar_db_tutorial/entities/teacher.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveCourse(Course newCourse) async {
    // Save a course
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.courses.putSync(newCourse));
  }

  Future<void> saveStudent(Student newStudent) async {
    // Save a Student
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.students.putSync(newStudent));
  }

  Future<void> saveTeacher(Teacher newTeacher) async {
    // Save a Teacher
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.teachers.putSync(newTeacher));
  }

  Future<List<Course>> getAllCourses() async {
    // Get all courses
    final isar = await db;
    return await isar.courses.where().findAll();
  }

  Stream<List<Course>> listenToCourses() async* {
    // Listen to courses to show actual information
    final isar = await db;
    yield* isar.courses.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    // Clean the database
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<List<Student>> getStudentsFor(Course course) async {
    // Find all students that are part of the given course
    final isar = await db;
    final students = await isar.students.filter().courses((q) => q.idEqualTo(course.id)).findAll();
    return students;
  }

  Future<Teacher?> getTeacherFor(Course course) async {
    // Find the teacher of the course
    final isar = await db;
    final teacher = await isar.teachers.filter().course((q) => q.idEqualTo(course.id)).findFirst();
    return teacher;
  }

  Future<Isar> openDB() async {
    // Setup the DB at the beginning of the app start
    final dir = await getApplicationSupportDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [CourseSchema, StudentSchema, TeacherSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
