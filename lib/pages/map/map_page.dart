import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/pages/map/map_cubit.dart';
import 'package:location/location.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const MapPage());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) =>
          MapCubit(userRepository: context.read<AppCubit>().userRepository)),
      child: const _MapPage(),
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
  LatLng? _center;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Jogging Time'),
        ),
        body: _center == null
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: double.infinity,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center!,
                    zoom: 15.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('user_location'),
                      position: _center!,
                      infoWindow: const InfoWindow(title: 'Your Location'),
                    ),
                  },
                ),
              ),
      );
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
