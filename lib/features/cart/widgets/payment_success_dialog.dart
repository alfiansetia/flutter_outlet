import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/assets/assets.gen.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/core/components/buttons.dart';
import 'package:flutter_outlet/core/components/spaces.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/features/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_outlet/features/cart/widgets/label_value.dart';
import 'package:flutter_outlet/features/order/blocs/order/order_bloc.dart';
import 'package:flutter_outlet/features/order/models/order.dart';
import 'package:flutter_outlet/core/extensions/int_ext.dart';

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Assets.icons.done.svg()),
          const SpaceHeight(24.0),
          Text(
            order.status == 'done'
                ? 'Order berhasil dibuat!'
                : 'Order Dibatalkan!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceHeight(12.0),
          labelValue(
            label: 'NAMA PEMESAN',
            value: order.name,
          ),
          const Divider(height: 20.0),
          labelValue(
            label: 'WAKTU',
            value: order.date,
          ),
          const Divider(height: 20.0),
          labelValue(
            label: 'KASIR',
            value: context.watch<AuthBloc>().state.user.name,
          ),
          const Divider(height: 20.0),
          labelValue(
            label: 'METODE PEMBAYARAN',
            value: order.payment.toUpperCase(),
          ),
          const Divider(height: 20.0),
          labelValue(
            label: 'TOTAL PEMBELIAN',
            value: order.total.currencyFormatRp,
          ),
          const Divider(height: 20.0),
          labelValue(
            label: 'NOMINAL BAYAR',
            value: order.bill.currencyFormatRp,
          ),
          const Divider(height: 20.0),
          labelValue(
            label: 'KEMBALI',
            value: order.returN.currencyFormatRp,
          ),
          const SpaceHeight(40.0),
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state.status == OrderStatus.error) {
                Alert(
                        status: AlertStatus.error,
                        message: state.message,
                        context: context)
                    .show();
                context.pop();
              }
              if (state.status == OrderStatus.successGetDetail) {
                context
                    .read<OrderBloc>()
                    .add(PrintOrderEvent(order: state.order));
              }
              if (state.status == OrderStatus.successPrint) {
                context.pop();
                Alert(
                        status: AlertStatus.success,
                        message: state.message,
                        context: context)
                    .show();
              }
            },
            builder: (context, state) {
              if (state.status == OrderStatus.loadingPrint) {
                return const Center(child: CircularProgressIndicator());
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Button.filled(
                      onPressed: () {
                        context.pop();
                      },
                      label: 'Selesai',
                      fontSize: 13,
                    ),
                  ),
                  const SpaceWidth(10.0),
                  Flexible(
                    child: Button.outlined(
                      onPressed: () async {
                        context
                            .read<OrderBloc>()
                            .add(PrintOrderEvent(order: order));
                      },
                      label: 'Print',
                      icon: Assets.icons.print.svg(),
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
