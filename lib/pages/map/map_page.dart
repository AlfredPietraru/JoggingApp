import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/run_session.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/widgets/navigation_drawer.dart';
import 'package:jogging/pages/map/map_cubit.dart';
import 'package:path_provider/path_provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const MapPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => MapCubit(
            userRepository: context.read<AppCubit>().userRepository,
            runSession: RunSession(
                // ignore: prefer_const_literals_to_create_immutables
                coordinates: [],
                // ignore: prefer_const_literals_to_create_immutables
                distances: [],
                // ignore: prefer_const_literals_to_create_immutables
                times: [],
                dateTime: DateTime.now(),
                user: context.read<AppCubit>().state.user!),
          )),
      child: Builder(builder: (context) {
        return BlocListener<MapCubit, MapState>(
          listener: (context, state) async {
            if (state is MapTrack && state.status == MapStatus.sending) {
              final idx = context.read<AppCubit>().state.user!.numberOfRuns + 1;
              context.read<AppCubit>().changeNumberRuns();
              context.read<MapCubit>().sendRunToDatabase(idx);
              return;
            }
          },
          child: const _MapPage(),
        );
      }),
    );
  }
}

class _MapPage extends StatefulWidget {
  const _MapPage();
  @override
  State<_MapPage> createState() => __MapPageState();
}

class __MapPageState extends State<_MapPage> {
  late GoogleMapController mapController;
  final LatLng mockCoordinates = const LatLng(4, 4);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          final oldState = state;
          return Scaffold(
            drawer: const MyNavigationDrawer(),
            appBar: AppBar(
              title: const Text('Jogging Time'),
              actions: [
                ElevatedButton(
                  onPressed: switch (oldState) {
                    MapTrack() => switch ((oldState).status) {
                        MapStatus.ready => oldState.enableButton
                            ? context.read<MapCubit>().startTrackingLocation
                            : null,
                        MapStatus.tracking => () {
                            final mapCubit = context.read<MapCubit>();
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return BlocProvider<MapCubit>.value(
                                  value: mapCubit,
                                  child: const SendRunToDatabaseDialog(),
                                );
                              },
                            );
                          },
                        MapStatus.sending => null,
                        MapStatus.blocked => null,
                      },
                    _ => null,
                  },
                  child: Text(context.read<MapCubit>().displayButtonInfo()),
                ),
              ],
            ),
            body: SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  (oldState is MapInitial)
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: context.read<MapCubit>().setMapCenter(),
                            zoom: 17.0,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('Starting Point'),
                              position: oldState is MapTrack
                                  ? switch (oldState.status) {
                                      MapStatus.tracking => context
                                          .read<MapCubit>()
                                          .initialLocation,
                                      _ =>
                                        context.read<MapCubit>().setMapCenter(),
                                    }
                                  : context.read<MapCubit>().initialLocation,
                              infoWindow:
                                  const InfoWindow(title: 'Starting Point'),
                            ),
                            Marker(
                              markerId: const MarkerId('End point'),
                              position: context.read<MapCubit>().setMapCenter(),
                              infoWindow: const InfoWindow(title: 'End point'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueYellow),
                            ),
                          },
                        ),
                ],
              ),
            ),
          );
        },
      );
}

class SendRunToDatabaseDialog extends StatelessWidget {
  const SendRunToDatabaseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Sending current run to database',
          textAlign: TextAlign.center,
          style:
              AppTextStyle.headline1.copyWith(color: AppColors.textColorBrown),
        ),
      ),
      content: Text(
        'Are you sure you want to proceed?',
        style: AppTextStyle.alert.copyWith(color: AppColors.textColorBrown),
        textAlign: TextAlign.center,
      ),
      elevation: 20,
      backgroundColor: AppColors.buttonInterior,
      actionsPadding: const EdgeInsets.all(AppSpacing.xlg),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        SizedBox(
          width: 120,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.enabledFieldOrange,
              shadowColor: AppColors.costalBlue,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              side: const BorderSide(color: AppColors.eerieBlack, width: 2),
            ),
            onPressed: ()  {
              // save to file the content

              // context.read<MapCubit>().runSession.toJson();
              RunSession session = context.read<MapCubit>().runSession;
              final directory = getApplicationDocumentsDirectory();
              directory.then((directoryPath) {
                print("aiciiiiiii");
                print(directoryPath.path);
                File file = File('${directoryPath.path}/runSession.txt');
                print("path fisier este:");
                print(file.path);
                file.writeAsString(session.toJsonString());
                print("pare sa fi functionat");
              },);
              context.read<MapCubit>().resetToReadyState();
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: AppTextStyle.alert.copyWith(
                color: AppColors.textColorBrown,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.enabledFieldOrange,
              shadowColor: AppColors.costalBlue,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              side: const BorderSide(color: AppColors.eerieBlack, width: 2),
            ),
            onPressed: () {
              context.read<MapCubit>().stopTrackingLocation();
              Navigator.pop(context);
            },
            child: Text(
              "Yes",
              style: AppTextStyle.alert.copyWith(
                color: AppColors.textColorBrown,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
