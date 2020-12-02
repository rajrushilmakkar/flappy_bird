import 'dart:async';

import 'package:flappy_bird/widgets/barrier.dart';
import 'package:flappy_bird/widgets/bird.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var upperSizes = [120, 150, 130, 145];
  var lowerSizes = [180, 140, 180, 135];
  int count = 0;
  double boxHeight, boxWidth;
  double xRange, yRange;
  bool hittable = true;
  int score = 0;
  int bestScore = 0;
  static double birdYaxis = 0;
  static double barrier1X = 0.0;
  double barrier2X = barrier1X + 1.5;
  bool gameStarted = false;
  double time = 0, height = 0, initialHeight = birdYaxis;
  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void gameOver() {
    gameStarted = false;
    birdYaxis = 0;
    setState(() {
      if (score > bestScore) bestScore = score;
      score = 0;
      barrier1X = 0.0;
      barrier2X = barrier1X + 1.5;
    });
  }

  void startGame() {
    gameStarted = true;
    time = 0;
    initialHeight = 0;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      //print(barrier1X);

      time += 0.04;
      height = 2 * time - 2.8 * time * time;
      setState(() {
        birdYaxis = initialHeight - height;
        // print(birdYaxis);
      });
      setState(() {
        if (barrier1X < -1.4) {
          barrier1X = 1.7;
          hittable = true;
          //score += 1;
        } else {
          barrier1X -= 0.05;
        }
      });
      setState(() {
        if (barrier2X < -1.4) {
          barrier2X = 1.7;
          hittable = true;

          ///score += 1;
        } else {
          barrier2X -= 0.05;
        }
      });
      if (barrier1X < -xRange || barrier2X < -xRange) {
        setState(() {
          if (hittable) score += 1;
          hittable = false;
        });
      }
      if (birdYaxis > 1) {
        timer.cancel();
        gameOver();
      }

      if (barrier1X >= -xRange && barrier1X <= xRange) {
        // print(birdYaxis);
        if (birdYaxis >= (1.1 - (400 / boxHeight)) ||
            birdYaxis <= -(1.1 - (240 / boxHeight))) {
          //print('mara');
          setState(() {
            timer.cancel();
            gameOver();
          });
        }
      }
      if (barrier2X >= -xRange && barrier2X <= xRange) {
        if (birdYaxis >= (1.1 - (480 / boxHeight)) ||
            birdYaxis <= -(1.1 - (180 / boxHeight))) {
          setState(() {
            timer.cancel();
            gameOver();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    boxHeight = MediaQuery.of(context).size.height;
    boxWidth = MediaQuery.of(context).size.width;
    boxHeight = (2 / 3) * (boxHeight - 15);
    xRange = 100 / boxWidth;
    // print("box height" + boxHeight.toString());
    // print(xRange);
    return GestureDetector(
      onTap: () {
        if (gameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: Bird(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gameStarted
                        ? Container()
                        : Text(
                            'T A P  T O  P L A Y',
                            style: TextStyle(fontSize: 30),
                          ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrier1X, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrier1X, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      size: 120.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrier2X, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      size: 90.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrier2X, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Barrier(
                      size: 240.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Score',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          score.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Best',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          bestScore.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
