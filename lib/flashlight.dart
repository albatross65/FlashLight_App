import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class FlashLightApp extends StatefulWidget {
  const FlashLightApp({super.key});

  @override
  State<FlashLightApp> createState() => _FlashLightAppState();
}

class _FlashLightAppState extends State<FlashLightApp> with TickerProviderStateMixin {
  late AnimationController animationController;
  Color color = Colors.white;
  double fontsize = 20;
  bool isClicked = true;
  final TorchController controller = TorchController();

  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(1.0),
          spreadRadius: 15,
          blurRadius: 30,
          offset: Offset(0.0, 0.0),
        ),
      ],
      border: Border.all(color: Colors.black),
    ),
    end: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.red.withOpacity(1.0),
          spreadRadius: 30,
          blurRadius: 60,
          offset: Offset(0.0, 0.0),
        ),
      ],
      border: Border.all(color: Colors.black),
    ),
  );

  @override
  void initState() {
    super.initState();
    _requestPermission();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> _requestPermission() async {
    if (await Permission.camera.request().isGranted) {
      // Permission granted
    } else {
      // Handle permission denied
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff03012c),Color(0xff302b63),Color(0xff03012c)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (isClicked) {
                  animationController.forward();
                  fontsize = 50;
                  color = Color(0xffdd1818);
                } else {
                  animationController.reverse();
                  fontsize = 25;
                  color = Colors.white;
                }
                isClicked = !isClicked;
                controller.toggle();
                setState(() {});
              },
              child: Center(
                child: DecoratedBoxTransition(
                  position: DecorationPosition.background,
                  decoration: decorationTween.animate(animationController),
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.power_settings_new,
                            color: isClicked ? Colors.black : Color(0xffdd1818),
                            size: 60,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: isClicked ? Color(0xffdd1818) : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.3,
              alignment: Alignment.bottomCenter,
              child: AnimatedDefaultTextStyle(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 200),
                child: Text(isClicked ? 'OFF' : 'ON'),
                style: TextStyle(
                  color: color,
                  fontSize: fontsize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
