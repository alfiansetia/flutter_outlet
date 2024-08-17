import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/features/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_outlet/features/order/blocs/order/order_bloc.dart';
import 'package:flutter_outlet/features/order/widgets/order_card.dart';

import '../../../core/components/spaces.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> listStatus = ['done', 'cancel'];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const FetchAllOrderEvent(page: 1));
    context.read<AuthBloc>().add(const FethAuthEven());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _getData(listStatus[_tabController.index]);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _getData(String status) async {
    context
        .read<OrderBloc>()
        .add(FetchAllOrderEvent(query: 'status=$status', page: 1));
  }

  void _onScroll() {
    final status = listStatus[_tabController.index];
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final bloc = context.read<OrderBloc>();
    bool next = currentScroll >= (maxScroll * 0.9) &&
        bloc.state.status == OrderStatus.loaded &&
        !bloc.state.hasMax &&
        !(bloc.state.status == OrderStatus.loading);
    if (next) {
      final nextPage = bloc.state.page + 1;
      bloc.add(FetchAllOrderEvent(page: nextPage, query: 'status=${status}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Orders',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          onTap: (value) {},
          controller: _tabController,
          tabs: const [
            Tab(text: 'Done'),
            Tab(text: 'Cancel'),
          ],
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.error) {
            Alert(
              context: context,
              status: AlertStatus.error,
              message: state.message,
            ).show();
          }
          // if (state.status == OrderStatus.successGetDetail) {
          //   context.push(DetailOrderPage(order: state.order));
          // }
        },
        builder: (context, state) {
          if (state.status == OrderStatus.loading && state.data.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  _getData('done');
                },
                child: _buildListView(state),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  _getData('cancel');
                },
                child: _buildListView(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListView(OrderState state) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
    bool isLoading = state.status == OrderStatus.loading;

    if (state.data.isEmpty) {
      return Center(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Center(child: Text('No data')),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.data.length + (isLoading ? 1 : 0),
        separatorBuilder: (context, index) => const SpaceHeight(8.0),
        itemBuilder: (context, index) {
          if (index < state.data.length) {
            return OrderCard(
              padding: paddingHorizontal,
              data: state.data[index],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
