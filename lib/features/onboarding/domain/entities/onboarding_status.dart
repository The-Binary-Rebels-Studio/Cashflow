class OnboardingStatus {
  final bool isCompleted;
  
  const OnboardingStatus({
    required this.isCompleted,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingStatus &&
          runtimeType == other.runtimeType &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => isCompleted.hashCode;

  @override
  String toString() => 'OnboardingStatus(isCompleted: $isCompleted)';
}