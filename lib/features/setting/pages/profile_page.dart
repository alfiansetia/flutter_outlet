import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/components/buttons.dart';
import 'package:flutter_outlet/core/components/spaces.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/features/cart/widgets/label_value.dart';
import 'package:flutter_outlet/features/setting/blocs/profile/profile_bloc.dart';

import 'package:flutter_outlet/models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    User user = context.watch<ProfileBloc>().state.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile ${user.name}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(const FetchProfileEvent());
        },
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.error) {
              context.pop();
            }
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceHeight(12.0),
                    labelValue(
                      label: 'NAMA',
                      value: user.name,
                    ),
                    const SpaceHeight(12.0),
                    labelValue(
                      label: 'EMAIL',
                      value: user.email,
                    ),
                    const SpaceHeight(12.0),
                    labelValue(
                      label: 'PHONE',
                      value: user.phone ?? '-',
                    ),
                    const SpaceHeight(12.0),
                    labelValue(
                      label: 'BRANCH',
                      value: user.branch?.name ?? '-',
                    ),
                    const SpaceHeight(12.0),
                    labelValue(
                      label: 'ROLE',
                      value: user.role,
                    ),
                    const Divider(height: 20.0),
                    const SpaceHeight(20.0),
                    Row(
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
                              // context
                              //     .read<OrderBloc>()
                              //     .add(PrintOrderEvent(order: order));
                            },
                            label: 'Save',
                            icon: const Icon(Icons.save),
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                    const SpaceHeight(10.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
