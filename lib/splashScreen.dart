import 'package:cat_dog_classification_using_tflite/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _iconAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeOut,
    );

    _iconAnimation.addListener(() => setState(() {}));
    _iconAnimationController.forward();

    // Add a delay before navigating to the login page
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("asset/logo.png"),
                height: _iconAnimation.value * 300,
              ),
            ],
          )
        ],
      ),
    );
  }
}
