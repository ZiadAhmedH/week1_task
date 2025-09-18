import '../../../core/models/report_model.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final Report report;
  ReportLoaded(this.report);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}
