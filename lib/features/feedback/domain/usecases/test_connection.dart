import 'package:injectable/injectable.dart';
import '../../../../core/models/api_response.dart';
import '../repositories/feedback_repository.dart';

/// Use case for testing backend connectivity
/// Encapsulates the business logic for connection testing
@injectable
class TestConnection {
  final FeedbackRepository _repository;

  TestConnection(this._repository);

  /// Execute the connection test use case
  /// 
  /// Returns [ApiResponse<Map<String, dynamic>>] with connection status
  Future<ApiResponse<Map<String, dynamic>>> call() async {
    return await _repository.testConnection();
  }
}