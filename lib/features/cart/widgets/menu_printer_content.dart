import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/constants/colors.dart';
import 'package:flutter_outlet/features/order/models/order.dart';
import 'package:flutter_outlet/features/printer/blocs/printer/printer_bloc.dart';
import 'package:flutter_outlet/features/printer/models/printer.dart';

class MenuPrinterContent extends StatelessWidget {
  final Printer printer;
  final Order order;
  const MenuPrinterContent({
    super.key,
    required this.printer,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 48.0,
            blurStyle: BlurStyle.outer,
            spreadRadius: 0,
            color: AppColors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.bluetooth),
        title: Text(printer.name),
        subtitle: Text(printer.mac),
        trailing: TextButton.icon(
          label: const Text('Print'),
          icon: const Icon(Icons.print),
          onPressed: () {
            context.read<PrinterBloc>().add(
                  PrintTestPrinterEvent(printer: printer),
                );
          },
        ),
      ),
    );
  }
}
