class SuggestionDto {
  final String title;
  final String description;
  final String useCase;

  const SuggestionDto({
    required this.title,
    required this.description,
    required this.useCase,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'use_case': useCase,
    };
  }
}