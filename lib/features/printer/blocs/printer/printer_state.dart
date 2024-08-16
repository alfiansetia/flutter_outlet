part of 'printer_bloc.dart';

enum PrinterStatus {
  initial,
  loading,
  loaded,
  error,
  success,
}

class PrinterState extends Equatable {
  const PrinterState({
    required this.data,
    required this.message,
    required this.status,
    required this.defaultMac,
  });

  factory PrinterState.initial() => const PrinterState(
        data: [],
        status: PrinterStatus.initial,
        message: '',
        defaultMac: '',
      );

  final List<Printer> data;
  final String message;
  final PrinterStatus status;
  final String defaultMac;

  @override
  List<Object?> get props => [data, status, message];

  PrinterState copyWith({
    List<Printer>? data,
    String? message,
    PrinterStatus? status,
    String? defaultMac,
  }) {
    return PrinterState(
      data: data ?? this.data,
      message: message ?? this.message,
      status: status ?? this.status,
      defaultMac: defaultMac ?? this.defaultMac,
    );
  }

  @override
  String toString() {
    return 'PrinterState(data: $data, message: $message, status: $status, defaultMac: $defaultMac)';
  }
}
