import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/features/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_outlet/features/branch_menu/blocs/branch_menu/branch_menu_bloc.dart';
import 'package:flutter_outlet/features/cart/blocs/cart/cart_bloc.dart';
import 'package:flutter_outlet/features/home/widgets/menu_card.dart';
import 'package:flutter_outlet/features/home/widgets/menu_empty.dart';
// import 'package:flutter_outlet/presentation/home/bloc/product/product_bloc.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/search_input.dart';
import '../../../core/components/spaces.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final indexValue = ValueNotifier(0);
  List<String> categoryName = ['', 'drink', 'food', 'other'];

  @override
  void initState() {
    super.initState();
    context.read<BranchMenuBloc>().add(const FetchAllBranchMenuEvent());
    context.read<AuthBloc>().add(const FethAuthEven());
  }

  void onCategoryTap(int index) {
    searchController.clear();
    indexValue.value = index;
    String category = '';
    switch (index) {
      case 0:
        category = '';
        break;
      case 1:
        category = 'drink';
        break;
      case 2:
        category = 'food';
        break;
      case 3:
        category = 'other';
        break;
    }
    context
        .read<BranchMenuBloc>()
        .add(FetchAllBranchMenuEvent(query: 'category=$category'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Menu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SearchInput(
              controller: searchController,
              onChanged: (value) {
                if (value.length > 3) {
                  context.read<BranchMenuBloc>().add(FetchAllBranchMenuEvent(
                      query:
                          'category=${categoryName[indexValue.value]}&name=${searchController.text}'));
                }
                if (value.isEmpty) {
                  context
                      .read<BranchMenuBloc>()
                      .add(const FetchAllBranchMenuEvent());
                }
              },
            ),
            const SpaceHeight(20.0),
            ValueListenableBuilder(
              valueListenable: indexValue,
              builder: (context, value, _) => Row(
                children: [
                  MenuButton(
                    iconPath: Assets.icons.allCategories.path,
                    label: 'Semua',
                    isActive: value == 0,
                    onPressed: () => onCategoryTap(0),
                  ),
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.drink.path,
                    label: 'Minuman',
                    isActive: value == 1,
                    onPressed: () => onCategoryTap(1),
                  ),
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.food.path,
                    label: 'Makanan',
                    isActive: value == 2,
                    onPressed: () => onCategoryTap(2),
                  ),
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.snack.path,
                    label: 'Snack',
                    isActive: value == 3,
                    onPressed: () => onCategoryTap(3),
                  ),
                ],
              ),
            ),
            const SpaceHeight(35.0),
            BlocConsumer<BranchMenuBloc, BranchMenuState>(
              listener: (context, state) {
                if (state.status == BranchMenuStatus.loaded) {
                  context.read<CartBloc>().add(const FetchAllCartEvent());
                }
                if (state.status == BranchMenuStatus.error) {
                  Alert(
                    context: context,
                    status: AlertStatus.error,
                    message: state.error.message,
                  ).show();
                }
              },
              builder: (context, state) {
                if (state.model.isEmpty) {
                  return const MenuEmpty();
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.model.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.65,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemBuilder: (context, index) => MenuCard(
                      data: state.model[index],
                      onCartButton: () {},
                    ),
                  );
                }
              },
            ),
            const SpaceHeight(30.0),
          ],
        ),
      ),
    );
  }
}
