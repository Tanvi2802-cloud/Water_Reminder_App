import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int water = 1850;
  final int goal = 5000;

  void addWater(int ml) {
    setState(() {
      water += ml;
      if (water > goal) water = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = water / goal;

    return Scaffold(
      backgroundColor: const Color(0xffF3FAFF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "AquaNova 💧",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // 💧 WATER WAVE CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.12),
                    blurRadius: 20,
                  ),
                ],
              ),

              child: Column(
                children: [

                  Stack(
                    alignment: Alignment.center,
                    children: [

                      // 🌊 WAVE CIRCLE
                      Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: WaveWidget(
                            config: CustomConfig(
                              gradients: [
                                [Colors.blue, Colors.blueAccent],
                                [Colors.lightBlue, Colors.blue],
                              ],
                              durations: [3500, 19440],
                              heightPercentages: [
                                1 - progress,
                                1 - (progress + 0.02),
                              ],
                            ),
                            size: const Size(double.infinity, double.infinity),
                            waveAmplitude: 0,
                          ),
                        ),
                      ),

                      // 💧 TEXT OVER WAVE
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            "$water ml",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Goal $goal ml",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Today's Progress",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ➕ BUTTONS
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                waterButton(100),
                waterButton(250),
                waterButton(500),
                waterButton(1000),
              ],
            ),

            const SizedBox(height: 30),

            // 💙 MESSAGE CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text("💙", style: TextStyle(fontSize: 28)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Keep drinking water. You're doing amazing!",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget waterButton(int ml) {
    return ElevatedButton(
      onPressed: () => addWater(ml),
      child: Text("+$ml ml"),
    );
  }
}