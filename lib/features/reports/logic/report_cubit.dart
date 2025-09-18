import 'package:ahwa_store_manger_app/features/reports/logic/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/report_model.dart';
import '../data/report_service.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportService service;

  ReportCubit(this.service) : super(ReportInitial());

  Future<void> loadReport() async {
    try {
      emit(ReportLoading());
      final Report report = await service.fetchReport();

      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError("Failed to load reports: $e"));
    }
  }
}
