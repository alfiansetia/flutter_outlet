import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/assets/assets.gen.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/core/components/buttons.dart';
import 'package:flutter_outlet/core/components/spaces.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/core/extensions/int_ext.dart';
import 'package:flutter_outlet/core/extensions/string_ext.dart';
import 'package:flutter_outlet/features/cart/widgets/label_value.dart';
import 'package:flutter_outlet/features/order/blocs/order/order_bloc.dart';

import 'package:flutter_outlet/features/order/models/order.dart';

class DetailOrderPage extends StatelessWidget {
  final Order order;
  const DetailOrderPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    bool isCancel = order.status == 'cancel';
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders ${order.number}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                label: 'ORDER NUMBER',
                value: order.number,
              ),
              const Divider(height: 20.0),
              labelValue(
                label: 'WAKTU',
                value: order.date,
              ),
              const Divider(height: 20.0),
              labelValue(
                label: 'KASIR',
                value: order.user?.name ?? '-',
              ),
              const Divider(height: 20.0),
              labelValue(
                label: 'STATUS ORDER',
                value: order.status.toUpperCase(),
              ),
              const Divider(height: 20.0),
              if (isCancel)
                labelValue(
                  label: 'CANCEL REASON',
                  value: order.cancleReason ?? '-',
                ),
              if (isCancel) const Divider(height: 20.0),
              labelValue(
                label: 'METODE PEMBAYARAN',
                value: order.payment.toUpperCase(),
              ),
              const Divider(height: 20.0),
              labelValue(
                label: 'TRX ID',
                value: order.trxId ?? '-',
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
              const Divider(height: 20.0),
              const Text(
                'ITEMS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SpaceHeight(10.0),
              ...order.orderItem.map(
                (item) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.qty}x ${item.branchMenu?.menu?.name ?? '-'}'
                          .truncateTo(18),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SpaceHeight(5.0),
                    Text(
                      item.subtotal.currencyFormatRp,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              if (order.orderItem.isNotEmpty) const Divider(height: 20.0),
              const SpaceHeight(20.0),
              BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state.status == OrderStatus.successPrint) {
                    Alert(
                      status: AlertStatus.success,
                      message: state.message,
                      context: context,
                    ).show();
                  }
                  if (state.status == OrderStatus.error) {
                    Alert(
                      status: AlertStatus.error,
                      message: state.message,
                      context: context,
                    ).show();
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
                        child: Button.outlined(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            context.pop();
                          },
                          label: 'Kembali',
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
                      )
                    ],
                  );
                },
              ),
              const SpaceHeight(10.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Button.outlined(
                      icon: const Icon(Icons.picture_as_pdf),
                      onPressed: () {
                        //
                      },
                      label: 'PDF',
                      fontSize: 13,
                    ),
                  ),
                  const SpaceWidth(10.0),
                  Flexible(
                    child: Button.outlined(
                      onPressed: () async {
                        //
                      },
                      label: 'WA',
                      icon: const Icon(Icons.chat),
                      fontSize: 13,
                    ),
                  )
                ],
              ),
              const SpaceHeight(10.0),
            ],
          ),
        ),
      ),
    );
  }
}
