import 'problem.dart';

/// A group of problems.
class Group {
  Group({
    required this.label,
    this.subgroups = const [],
    this.problems = const [],
  });

  /// The label of the group.
  final String label;

  /// The subgroups of the group.
  final List<Group> subgroups;

  /// The problems of the group.
  final List<Problem> problems;
}
