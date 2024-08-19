import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/core/components/buttons.dart';
import 'package:flutter_outlet/core/components/custom_text_field.dart';
import 'package:flutter_outlet/core/components/spaces.dart';
import 'package:flutter_outlet/core/constants/colors.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/core/extensions/int_ext.dart';
import 'package:flutter_outlet/core/extensions/string_ext.dart';
import 'package:flutter_outlet/features/cart/blocs/cart/cart_bloc.dart';
import 'package:flutter_outlet/features/cart/widgets/payment_success_dialog.dart';
import 'package:flutter_outlet/features/order/blocs/order/order_bloc.dart';

enum Payment { cash, transfer }

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.payment, required this.total});
  final Payment payment;
  final int total;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final inputvalue = ValueNotifier(0);

  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    inputvalue.value = widget.total;
    priceController.text = widget.total.currencyFormatRp;
    nameController.text = 'Umum';
    super.initState();
  }

  @override
  void dispose() {
    priceController.dispose();
    nameController.dispose();
    inputvalue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Order'),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.error ||
              state.status == OrderStatus.success) {
            Alert(
              status: state.status == OrderStatus.error
                  ? AlertStatus.error
                  : AlertStatus.success,
              message: state.message,
              context: context,
            ).show();
          }
          if (state.status == OrderStatus.success) {
            context.read<CartBloc>().add(const FetchAllCartEvent());
            // context.pop();
            context.push(PaymentSuccessDialog(
                order: context.watch<OrderBloc>().state.order));
          }
        },
        builder: (context, state) {
          if (state.status == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceHeight(8.0),
                  CustomTextField(
                    maxlength: 20,
                    controller: nameController,
                    label: 'Nama Pemesan',
                    showLabel: false,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {},
                  ),
                  const SpaceHeight(16.0),
                  CustomTextField(
                    controller: priceController,
                    label: '',
                    showLabel: false,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final int priceValue = value.toIntegerFromText;
                      inputvalue.value = priceValue;
                      priceController.text = priceValue.currencyFormatRp;
                      priceController.selection = TextSelection.fromPosition(
                          TextPosition(offset: priceController.text.length));
                    },
                  ),
                  const SpaceHeight(16.0),
                  ValueListenableBuilder<int>(
                    valueListenable: inputvalue,
                    builder: (context, value, child) {
                      if (value < 1 || value < widget.total) {
                        value = 0;
                      } else {
                        value = value - widget.total;
                      }
                      return Text('Kembali : ${value.currencyFormatRp}');
                    },
                  ),
                  const SpaceHeight(16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button.filled(
                        onPressed: () {
                          priceController.text = widget.total.currencyFormatRp;
                          inputvalue.value = widget.total;
                        },
                        label: 'Uang Pas',
                        disabled: false,
                        textColor: AppColors.white,
                        fontSize: 13.0,
                        width: 112.0,
                        height: 50.0,
                      ),
                      const SpaceWidth(4.0),
                      Flexible(
                        child: Button.filled(
                          onPressed: () {},
                          label: widget.total.currencyFormatRp,
                          disabled: true,
                          textColor: AppColors.primary,
                          fontSize: 13.0,
                          height: 50.0,
                        ),
                      ),
                    ],
                  ),
                  const SpaceHeight(30.0),
                  Button.filled(
                    onPressed: () {
                      String name = nameController.text;
                      if (name.isNotEmpty) {
                        context.read<OrderBloc>().add(
                              StoreOrderEvent(
                                name: name,
                                payment: widget.payment.name,
                                bill: inputvalue.value,
                                ppn: 0,
                              ),
                            );
                      } else {
                        // context.pop();
                        Alert(
                                status: AlertStatus.error,
                                message: 'Nama harus diisi',
                                context: context)
                            .show();
                      }
                    },
                    label: 'Proses',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
