import 'package:injectable/injectable.dart';
import '../../../../core/models/api_response.dart';
import '../repositories/feedback_repository.dart';


@injectable
class TestConnection {
  final FeedbackRepository _repository;

  TestConnection(this._repository);

  
  
  
  Future<ApiResponse<Map<String, dynamic>>> call() async {
    return await _repository.testConnection();
  }
}