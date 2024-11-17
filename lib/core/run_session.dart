import 'package:jogging/auth/user.dart';

class RunSession {
  final List<String> values = [];
  final User user;
  late String name;
  late DateTime start;
  int noStage = 0;

  RunSession({
    required this.user,
    required this.start,
  }) {
    name = "run_${user.numberOfRuns}";
  }
}
