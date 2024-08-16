import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/assets/assets.gen.dart';
import 'package:flutter_outlet/core/constants/colors.dart';
import 'package:flutter_outlet/features/order/blocs/order/order_bloc.dart';
import 'package:flutter_outlet/features/order/models/order.dart';
import 'package:flutter_outlet/core/extensions/int_ext.dart';

class OrderCard extends StatelessWidget {
  final Order data;
  final EdgeInsetsGeometry? padding;

  const OrderCard({
    super.key,
    required this.data,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding,
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
      child: InkWell(
        onTap: () {
          context.read<OrderBloc>().add(DetailOrderEvent(id: data.id));
        },
        child: ListTile(
          leading: Assets.icons.payments.svg(),
          title: Text('${data.name} [${data.payment.toUpperCase()}]'),
          subtitle: Text(data.date),
          trailing: Text(
            data.total.currencyFormatRp,
            style: TextStyle(
              color: data.status == 'done' ? AppColors.green : AppColors.red,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
