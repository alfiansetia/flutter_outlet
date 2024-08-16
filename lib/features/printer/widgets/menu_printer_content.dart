import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/constants/colors.dart';
import 'package:flutter_outlet/features/printer/blocs/printer/printer_bloc.dart';
import 'package:flutter_outlet/features/printer/models/printer.dart';

class MenuPrinterContent extends StatelessWidget {
  final Printer data;
  const MenuPrinterContent({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    bool defaultMac = context.watch<PrinterBloc>().state.defaultMac == data.mac;
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
        title: Text(
          '${data.name} ${defaultMac ? ' (default)' : ''}',
          style: TextStyle(color: defaultMac ? Colors.green : Colors.black),
        ),
        subtitle: Text(data.mac),
        trailing: PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 0) {
              context.read<PrinterBloc>().add(
                    PrintTestPrinterEvent(printer: data),
                  );
            } else if (value == 1) {
              context.read<PrinterBloc>().add(
                    SetDefaultPrinterEvent(printer: data),
                  );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<int>(
              value: 0,
              child: ListTile(
                leading: Icon(Icons.print),
                title: Text('Print Test'),
              ),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Set Default'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
