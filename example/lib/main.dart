import 'package:flutter/material.dart';
import 'package:rotating_carousel/rotating_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: RotatingCarousel(
              panels: [
                Container(
                  // height: 100,
                  decoration: const BoxDecoration(color: Colors.red),
                ),
                Image.asset(
                  "assets/images/person.jpeg",
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/person1.jpeg",
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/person2.jpeg",
                  fit: BoxFit.fill,
                ),
                Container(
                  // height: 100,
                  decoration: const BoxDecoration(color: Colors.green),
                ),
                Image.asset(
                  "assets/images/person.jpeg",
                  fit: BoxFit.fill,
                ),
                // Image.asset(
                //   "assets/images/she.jpeg",
                //   fit: BoxFit.fill,
                // )
              ],
              height: 250,
              width: 350,
              minFactor: 0.9,
              overlapRatio: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
