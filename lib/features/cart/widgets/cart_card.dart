import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/constants/variables.dart';
import 'package:flutter_outlet/core/extensions/int_ext.dart';
import 'package:flutter_outlet/features/cart/blocs/cart/cart_bloc.dart';
import 'package:flutter_outlet/features/cart/models/cart.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class CartCard extends StatelessWidget {
  final Cart data;
  final VoidCallback onDeleteTap;
  final EdgeInsetsGeometry? padding;

  const CartCard({
    super.key,
    required this.data,
    required this.onDeleteTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          margin: padding,
          padding: const EdgeInsets.all(16.0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Color(0xFFC7D0EB)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  child: CachedNetworkImage(
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    imageUrl: data.branchMenu?.menu?.image ??
                        Variables.defaultImageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.food_bank_outlined,
                      size: 80,
                    ),
                  )),
              const SpaceWidth(24.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.branchMenu?.menu?.name ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ((data.branchMenu!.price * data.qty) -
                                  (data.branchMenu!.discountPrice * data.qty))
                              .currencyFormatRp,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SpaceHeight(20.0),
                    StatefulBuilder(
                      builder: (context, setState) => Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (data.qty > 1) {
                                context.read<CartBloc>().add(
                                      UpdateCartEvent(
                                          id: data.id, qty: data.qty - 1),
                                    );
                              }
                            },
                            child: Container(
                              color: AppColors.white,
                              child: const Icon(
                                Icons.remove_circle,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40.0,
                            child: Center(
                              child: Text(data.qty.toString()),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<CartBloc>().add(
                                    UpdateCartEvent(
                                        id: data.id, qty: data.qty + 1),
                                  );
                            },
                            child: Container(
                              color: AppColors.white,
                              child: const Icon(
                                Icons.add_circle,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () {
              context.read<CartBloc>().add(DestroyCartEvent(id: data.id));
            },
            icon: const Icon(
              Icons.highlight_off,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
