import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/constants/variables.dart';
import 'package:flutter_outlet/core/extensions/int_ext.dart';
import 'package:flutter_outlet/features/branch_menu/blocs/branch_menu/branch_menu_bloc.dart';
import 'package:flutter_outlet/features/branch_menu/models/branch_menu.dart';
// import 'package:flutter_outlet/features/cart/blocs/cart/cart_bloc.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class MenuCard extends StatelessWidget {
  final BranchMenu data;
  final VoidCallback onCartButton;

  const MenuCard({
    super.key,
    required this.data,
    required this.onCartButton,
  });

  String _truncateText(String text, int maxLength,
      {String replacement = '..'}) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + replacement;
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.card),
              borderRadius: BorderRadius.circular(19),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.disabled.withOpacity(0.4),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  child: CachedNetworkImage(
                    height: 100,
                    fit: BoxFit.fitWidth,
                    imageUrl: data.menu?.image ?? Variables.defaultImageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.food_bank_outlined,
                      size: 80,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _truncateText(data.menu?.name ?? '-', 15),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SpaceHeight(8.0),
              Text(
                data.menu?.category ?? '-',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
              const SpaceHeight(8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      (data.price - data.discountPrice).currencyFormatRp,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color:
                            data.discountPrice > 0 ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<BranchMenuBloc>()
                          .add(AddToCartEvent(menuId: data.id, qty: 1));
                    },
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          color: AppColors.primary,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ) //Assets.icons.orders.svg(),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        (data.incart ?? 0) > 0
            ? Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    data.incart.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
