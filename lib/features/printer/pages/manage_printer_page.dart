import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/features/printer/blocs/printer/printer_bloc.dart';
import 'package:flutter_outlet/features/printer/widgets/menu_printer_content.dart';

import '../../../core/components/spaces.dart';

class ManagePrinterPage extends StatelessWidget {
  const ManagePrinterPage({super.key});

  Future<void> _refresh(BuildContext context) async {
    context.read<PrinterBloc>().add(const FetchAllPrinterEvent());
  }

  @override
  Widget build(BuildContext context) {
    _refresh(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Printer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _refresh(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: SafeArea(
          child: BlocConsumer<PrinterBloc, PrinterState>(
            listener: (context, state) {
              if (state.status == PrinterStatus.error ||
                  state.status == PrinterStatus.success) {
                Alert(
                  status: state.status == PrinterStatus.success
                      ? AlertStatus.success
                      : AlertStatus.error,
                  message: state.message,
                  context: context,
                ).show();
              }
            },
            builder: (context, state) {
              if (state.status == PrinterStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.data.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('No data available'),
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.data.length,
                  separatorBuilder: (context, index) => const SpaceHeight(16.0),
                  itemBuilder: (context, index) => MenuPrinterContent(
                    data: state.data[index],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
