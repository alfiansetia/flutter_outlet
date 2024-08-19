import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/assets/assets.gen.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/core/components/menu_button.dart';
import 'package:flutter_outlet/core/components/spaces.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/features/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_outlet/features/cart/blocs/cart/cart_bloc.dart';
import 'package:flutter_outlet/features/cart/models/cart.dart';
import 'package:flutter_outlet/features/cart/pages/checkout_page.dart';
import 'package:flutter_outlet/features/cart/widgets/cart_card.dart';
import 'package:flutter_outlet/features/cart/widgets/payment_cash_dialog.dart';
import 'package:flutter_outlet/features/cart/widgets/process_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final indexValue = ValueNotifier(0);

  List<Cart> carts = [];

  @override
  void initState() {
    context.read<CartBloc>().add(const FetchAllCartEvent());
    context.read<AuthBloc>().add(const FethAuthEven());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
    final cartState = context.watch<CartBloc>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Assets.icons.delete.svg(),
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.error) {
            Alert(
              context: context,
              status: AlertStatus.error,
              message: state.message,
            ).show();
          }
          if (state.status == CartStatus.success) {
            context.read<CartBloc>().add(const FetchAllCartEvent());
          }
        },
        builder: (context, state) {
          if (state.data.isEmpty) {
            return const Center(
              child: Text('No Data'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemCount: state.data.length,
            separatorBuilder: (context, index) => const SpaceHeight(20.0),
            itemBuilder: (context, index) => CartCard(
              padding: paddingHorizontal,
              data: state.data[index],
              onDeleteTap: () {},
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: indexValue,
              builder: (context, value, _) => Row(
                children: [
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.cash.path,
                    label: 'Cash',
                    isActive: value == 1,
                    onPressed: () {
                      indexValue.value = 1;
                    },
                  ),
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.qrCode.path,
                    label: 'Transfer',
                    isActive: value == 2,
                    onPressed: () {
                      indexValue.value = 2;
                    },
                  ),
                  const SpaceWidth(10.0),
                ],
              ),
            ),
            const SpaceHeight(20.0),
            ProcessButton(
              price: cartState.totalPriceIncart,
              onPressed: () async {
                if (cartState.data.isEmpty) {
                  Alert(
                          status: AlertStatus.error,
                          message: 'Keranjang Kosong!',
                          context: context)
                      .show();
                } else {
                  if (indexValue.value == 0) {
                    Alert(
                            status: AlertStatus.error,
                            message: 'Pilih Payment!',
                            context: context)
                        .show();
                  } else if (indexValue.value == 1) {
                    // context.push(CheckoutPage(
                    //     payment: Payment.cash,
                    //     total: cartState.totalPriceIncart));
                    showDialog(
                      context: context,
                      builder: (context) => PaymentCashDialog(
                        price: cartState.totalPriceIncart,
                      ),
                    );
                  } else if (indexValue.value == 2) {
                    context.push(CheckoutPage(
                        payment: Payment.transfer,
                        total: cartState.totalPriceIncart));
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible: false,
                    //   builder: (context) => PaymentCashDialog(
                    //     price: cartState.totalPriceIncart,
                    //   ),
                    // );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
