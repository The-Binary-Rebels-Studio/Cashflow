import 'package:injectable/injectable.dart';
import '../../../../core/models/bug_report_model.dart';
import '../repositories/feedback_repository.dart';

/// Use case for getting current device information
/// Encapsulates the business logic for device info retrieval
@injectable
class GetDeviceInfo {
  final FeedbackRepository _repository;

  GetDeviceInfo(this._repository);

  /// Execute the device info retrieval use case
  /// 
  /// Returns [DeviceInfo] containing current device details
  Future<DeviceInfo> call() async {
    return await _repository.getCurrentDeviceInfo();
  }
}