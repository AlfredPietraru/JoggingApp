import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const MapPage());

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'A creat userul cu succes',
            style: AppTextStyle.body,
          ),
          Text(context.read<AppCubit>().state.user!.email),
          Text(context.read<AppCubit>().state.user!.firstName),
          Text(context.read<AppCubit>().state.user!.lastName),
          Text(context.read<AppCubit>().state.user!.uid),
          Text(context.read<AppCubit>().state.user!.sex.toName()),
        ],
      ),
    );
  }
}
