import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/history/history_page.dart';
import 'package:jogging/pages/settings/settings_page.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

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
                  onTap: () {
                    Navigator.push(context, HistoryPage.page());
                  },
                  icon: Assets.icons.runner,
                  name: "History"),
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