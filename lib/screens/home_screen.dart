import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int water = 1200;
  int goal = 3000;

  late AnimationController _controller;
  late Animation<double> _progressAnim;

  late ConfettiController _confettiController;

  List<String> badges = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _progressAnim = Tween<double>(begin: 0, end: water / goal).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  void _animateProgress(double newProgress) {
    _progressAnim = Tween<double>(
      begin: _progressAnim.value,
      end: newProgress,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward(from: 0);
  }

  void addWater(int ml) {
    setState(() {
      water += ml;

      double progress = water / goal;
      _animateProgress(progress);

      // 🏆 BADGES FIXED LOGIC
      if (water >= 500 && !badges.contains("Beginner")) {
        badges.add("Beginner");
        _confettiController.play();
      }
      if (water >= 1500 && !badges.contains("Hydrated")) {
        badges.add("Hydrated");
        _confettiController.play();
      }
      if (water >= 3000 && !badges.contains("Master")) {
        badges.add("Master");
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white24),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget waterButton(int ml) {
    return ElevatedButton(
      onPressed: () => addWater(ml),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.withOpacity(0.15),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text("+$ml ml"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF8FF),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // 💧 HEADER
                glassCard(
                  child: Column(
                    children: [
                      const Text(
                        "💧 AquaNova",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      AnimatedBuilder(
                        animation: _progressAnim,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 190,
                                width: 190,
                                child: CircularProgressIndicator(
                                  value: _progressAnim.value.clamp(0.0, 1.0),
                                  strokeWidth: 12,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation(Colors.blue),
                                ),
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.water_drop,
                                      size: 45, color: Colors.blue),
                                  Text(
                                    "$water ml",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Goal: $goal ml",
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 💧 BUTTONS
                Wrap(
                  spacing: 10,
                  children: [
                    waterButton(100),
                    waterButton(250),
                    waterButton(500),
                    waterButton(1000),
                  ],
                ),

                const SizedBox(height: 20),

                // 🏆 BADGES (FIXED ALIGNMENT)
                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "🏆 Badges",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: badges.map((e) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🎉 CONFETTI
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}