class BugReportDto {
  final String title;
  final String description;
  final String stepsToReproduce;
  final String expectedBehavior;
  final String actualBehavior;

  const BugReportDto({
    required this.title,
    required this.description,
    required this.stepsToReproduce,
    required this.expectedBehavior,
    required this.actualBehavior,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'steps_to_reproduce': stepsToReproduce,
      'expected_behavior': expectedBehavior,
      'actual_behavior': actualBehavior,
    };
  }
}