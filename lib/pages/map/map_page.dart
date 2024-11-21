import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/runSession.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/navigation_drawer.dart';
import 'package:jogging/pages/map/map_cubit.dart';

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
                coordinates: [],
                distances: [],
                times: [],
                dateTime: DateTime.now(),
                user: context.read<AppCubit>().state.user!),
          )),
      child: Builder(builder: (context) {
        return BlocListener<MapCubit, MapState>(
          listener: (context, state) async {
            if (state is MapTrack && state.status == MapStatus.sending) {
              context.read<AppCubit>().changeUserInformation(
                  numberOfRuns:
                      context.read<AppCubit>().state.user!.numberOfRuns + 1);
              context.read<MapCubit>().sendRunToDatabase();
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
                        MapStatus.tracking =>
                          context.read<MapCubit>().stopTrackingLocation,
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
                              markerId: const MarkerId('InitialUserLocation'),
                              position:
                                  context.read<MapCubit>().initialLocation,
                              infoWindow:
                                  const InfoWindow(title: 'Initial Location'),
                            ),
                            Marker(
                              markerId: const MarkerId('CurrentUserLocation'),
                              position: context.read<MapCubit>().setMapCenter(),
                              infoWindow:
                                  const InfoWindow(title: 'Current Location'),
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
