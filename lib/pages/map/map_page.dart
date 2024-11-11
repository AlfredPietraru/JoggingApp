import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/map/map_cubit.dart';
import 'package:jogging/pages/settings/settings_page.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const MapPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) =>
          MapCubit(userRepository: context.read<AppCubit>().userRepository)),
      child: Builder(builder: (context) {
        return BlocListener<MapCubit, MapState>(
          listener: (context, state) {},
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          final oldState = state;
          return Scaffold(
            drawer: const NavigationDrawer(),
            appBar: AppBar(
              title: const Text('Jogging Time'),
            ),
            body: (oldState is MapLocationSuccesfull)
                ? SizedBox(
                    height: double.infinity,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: oldState.center,
                        zoom: 15.0,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('user_location'),
                          position: oldState.center,
                          infoWindow: const InfoWindow(title: 'Your Location'),
                        ),
                      },
                    ),
                  )
                : (state is MapInitial)
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Text(
                            (state as MapLocationFailed)
                                .mapLocationFailedToString(),
                            style: AppTextStyle.alert.copyWith(fontSize: 40),
                          ),
                        ],
                      ),
          );
        },
      );
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 40),
              ),
              const SizedBox(height: 20),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  Assets.images.ceahlau.path,
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              CustomListTile(
                  onTap: () {}, icon: Assets.icons.home, name: "Home"),
              CustomListTile(
                  onTap: () {
                    Navigator.push(context, SettingsPage.page());
                  },
                  icon: Assets.icons.settings,
                  name: "Settings"),
              CustomListTile(
                  onTap: () {}, icon: Assets.icons.runner, name: "History"),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key, required this.onTap, required this.name, required this.icon});

  final Function() onTap;
  final String name;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.green.shade300,
          onTap: onTap,
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            leading: SvgPicture.asset(
              icon,
              height: 40,
              width: 40,
            ),
            title: Text(name),
          ),
        ),
      ),
    );
  }
}
