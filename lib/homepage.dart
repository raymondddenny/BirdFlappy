import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flappy_bird/mybord.dart';
import 'package:flappy_bird/thewall.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double flappyYAxis = 0;
  double initialHeight = flappyYAxis;
  double height = 0;
  double time = 0;
  bool hasGameStarted = false;
  int score = 0;
  int highScore = 0;
  static double wallXOne = 1.5;
  double wallXTwo = wallXOne + 1.8;
  double wallXOneUpHeight = (Random().nextInt(300) + 50.0) >= 250 ? 200 : Random().nextInt(300) + 50.0;
  double wallXTwoUpHeight = (Random().nextInt(250) + 100.0) >= 250 ? 200 : Random().nextInt(250) + 100.0;

  void updateWallOne() {
    setState(() {
      wallXOneUpHeight = Random().nextDouble() + 150;
    });
  }

  void updateWallTwo() {
    setState(() {
      wallXTwoUpHeight = Random().nextDouble() + 200;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = flappyYAxis;
    });
  }

  void startGame() {
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        flappyYAxis = initialHeight - height;
      });

      setState(() {
        if (wallXOne < -2.5) {
          score++;
          updateWallOne();
          wallXOne += 4.5;
        } else {
          wallXOne -= 0.05;
        }
      });

      setState(() {
        if (wallXTwo < -2.5) {
          score++;
          updateWallTwo();
          wallXTwo += 4.5;
        } else {
          wallXTwo -= 0.05;
        }
      });

      if (flappyYAxis > 2.0) {
        timer.cancel();
        hasGameStarted = false;

        _showDialog();
      }
    });
  }

  void initGameState() {
    flappyYAxis = 0;
    initialHeight = flappyYAxis;
    height = 0;
    time = 0;
    hasGameStarted = false;
    score = 0;
    wallXOne = 1.5;
    wallXTwo = wallXOne + 1.5;
  }

  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Game Over",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          content: Text(
            "Your score is $score",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (score > highScore) {
                  highScore = score;
                }

                setState(() {
                  initGameState();
                });

                Navigator.of(context).pop();
              },
              child: const Text("Play Again",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(-0.3, flappyYAxis),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    color: Colors.amber,
                    child: const MyBird(),
                  ),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(wallXOne, 1.1),
                      child: TheWall(height: wallXOneUpHeight)),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(wallXOne, -1.1),
                      child: TheWall(height: wallXTwoUpHeight)),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(wallXTwo, -1.1),
                      child: TheWall(height: wallXTwoUpHeight)),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      alignment: Alignment(wallXTwo, 1.1),
                      child: TheWall(height: wallXOneUpHeight)),
                  Align(
                    alignment: const Alignment(0, -0.3),
                    child: hasGameStarted
                        ? const Text("")
                        : const Text("PRESS JUMP TO START",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
                            )),
                  ),
                ],
              )),
          Container(
            height: 15,
            color: Colors.brown,
          ),
          Expanded(
              child: Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          if (hasGameStarted) {
                            jump();
                          } else {
                            hasGameStarted = true;
                            startGame();
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber,
                            border: Border.fromBorderSide(BorderSide(color: Colors.brown, width: 10)),
                          ),
                          child: const Center(
                              child: Text(
                            "JUMP",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("SCORE: ",
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              Text("$score ",
                                  style:
                                      const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("BEST: ",
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              Text("$highScore ",
                                  style:
                                      const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
