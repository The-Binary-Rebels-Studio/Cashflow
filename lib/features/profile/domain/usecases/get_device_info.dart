import 'package:injectable/injectable.dart';
import '../../../../core/models/bug_report_model.dart';
import '../repositories/feedback_repository.dart';


@injectable
class GetDeviceInfo {
  final FeedbackRepository _repository;

  GetDeviceInfo(this._repository);

  
  
  
  Future<DeviceInfo> call() async {
    return await _repository.getCurrentDeviceInfo();
  }
}