import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gif/gif.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/login/login_page.dart';
import 'package:jogging/pages/register_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const LandingPage());

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late final GifController _gifController;
  @override
  void initState() {
    _gifController = GifController(vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Enable Location", style: AppTextStyle.alert),
          content: Text("We need your location for computing multiple things.",
              style: AppTextStyle.alert),
          actions: <Widget>[
            TextButton(
              child: Text("Enable location", style: AppTextStyle.button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Refuse", style: AppTextStyle.button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.red, Colors.blue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Its jogging time!'),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
              totalRepeatCount: 30,
              pause: const Duration(milliseconds: 2000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            const Spacer(),
            Gif(
              width: 150,
              height: 150,
              fps: 10,
              placeholder: (context) =>
                  const Text('Hello but without the kitty!'),
              autostart: Autostart.no,
              image: AssetImage(Assets.gifs.hello.path),
            ),
            const Spacer(),
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.red.shade800, width: 3),
                    ),
                    backgroundColor: Colors.green.shade400,
                  ),
                  onPressed: () {
                    Navigator.push(context, RegisterPage.page());
                  },
                  child:
                      const Text('Register', style: TextStyle(fontSize: 30))),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 150,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.red.shade800, width: 3),
                  ),
                  backgroundColor: Colors.green.shade400,
                ),
                onPressed: () {
                  Navigator.push(context, LoginPage.page());
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
