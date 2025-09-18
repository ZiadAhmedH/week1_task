import '../../../core/models/report_model.dart';

abstract class ReportService {
  Future<Report> fetchReport();
}
