part of 'printer_bloc.dart';

abstract class PrinterEvent extends Equatable {
  const PrinterEvent();

  @override
  List<Object> get props => [];
}

class FetchAllPrinterEvent extends PrinterEvent {
  const FetchAllPrinterEvent();

  @override
  List<Object> get props => [];
}

class PrintTestPrinterEvent extends PrinterEvent {
  const PrintTestPrinterEvent({required this.printer});

  final Printer printer;

  @override
  List<Object> get props => [printer];
}

class SetDefaultPrinterEvent extends PrinterEvent {
  const SetDefaultPrinterEvent({required this.printer});

  final Printer printer;

  @override
  List<Object> get props => [printer];
}
