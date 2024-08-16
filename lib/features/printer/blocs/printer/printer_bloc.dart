import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/models/custom_error.dart';

import 'package:flutter_outlet/features/printer/models/printer.dart';
import 'package:flutter_outlet/features/printer/services/printer_services.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  List<Printer> data = [
    Printer(name: 'name1', mac: '00-B0-D0-63-C2-26', isDefault: false),
    Printer(name: 'name', mac: '00-B0-D0-63-C2-27', isDefault: false)
  ];

  PrinterBloc() : super(PrinterState.initial()) {
    on<FetchAllPrinterEvent>(_getAll);
    on<PrintTestPrinterEvent>(_testPrint);
    on<SetDefaultPrinterEvent>(_setDefault);
  }
  Future<String> _getDefaultMac() async {
    try {
      String mac = await PrinterServices().getDefaultMac();
      return mac;
    } catch (e) {
      return '';
    }
  }

  Future<void> _getAll(
      FetchAllPrinterEvent event, Emitter<PrinterState> emit) async {
    String mac = await _getDefaultMac();
    // print(mac);
    emit(state.copyWith(
      status: PrinterStatus.loading,
      data: data,
      defaultMac: mac,
    ));

    try {
      final List<Printer> model = await PrinterServices().getAll();
      data = model;
      emit(
        state.copyWith(
          status: PrinterStatus.loaded,
          data: data,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: PrinterStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: PrinterStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _testPrint(
      PrintTestPrinterEvent event, Emitter<PrinterState> emit) async {
    emit(state.copyWith(status: PrinterStatus.loading, data: data));

    try {
      // final bool model =
      await PrinterServices().printTest(printer: event.printer);
      emit(
        state.copyWith(
          status: PrinterStatus.success,
          message: 'Success Print Test!',
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: PrinterStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: PrinterStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _setDefault(
      SetDefaultPrinterEvent event, Emitter<PrinterState> emit) async {
    emit(state.copyWith(status: PrinterStatus.loading, data: data));

    try {
      // final bool model =
      await PrinterServices().setDefault(printer: event.printer);
      emit(
        state.copyWith(
          status: PrinterStatus.success,
          message: 'Success Set Printer Default!',
          defaultMac: event.printer.mac,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: PrinterStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: PrinterStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
