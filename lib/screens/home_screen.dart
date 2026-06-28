import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int water = 1200;
  int goal = 2500;
  int streak = 4;

  List<String> badges = [];
  String aiMessage = "Stay hydrated 💧";

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    updateAI();
  }

  void updateAI() {
    if (water < 1000) {
      aiMessage = "💧 You are dehydrated!";
    } else if (water < 2000) {
      aiMessage = "👍 Good progress!";
    } else {
      aiMessage = "🔥 Perfect hydration!";
    }
  }

  void addWater(int ml) {
    setState(() {
      water = (water + ml).clamp(0, goal);
      updateAI();

      if (water >= 500 && !badges.contains("Beginner")) {
        badges.add("Beginner 💧");
      }
      if (water >= 1500 && !badges.contains("Hydrated")) {
        badges.add("Hydrated 💦");
      }
      if (water >= goal && !badges.contains("Master")) {
        badges.add("Hydration Master 👑");
      }
    });

    NotificationService.showWaterNotification();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = water / goal;

    return Scaffold(
      backgroundColor: const Color(0xffEAF8FF),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "AquaNova 💧",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                // 💎 GLASS CARD
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [

                          const Text(
                            "💧 Today's Progress",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // PROGRESS CIRCLE
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation(Colors.blue),
                                ),
                              ),

                              Column(
                                children: [
                                  const Icon(Icons.water_drop,
                                      size: 35, color: Colors.blue),
                                  Text(
                                    "$water ml",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Goal $goal ml",
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Text(
                            "🔥 Streak: $streak days",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // QUICK ADD BUTTONS
                Wrap(
                  spacing: 10,
                  children: [
                    waterBtn(100),
                    waterBtn(250),
                    waterBtn(500),
                    waterBtn(1000),
                  ],
                ),

                const SizedBox(height: 25),

                // AI CARD
                glassCard(
                  icon: "🤖",
                  text: aiMessage,
                ),

                const SizedBox(height: 15),

                // BADGES
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🏆 Achievements",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      badges.isEmpty
                          ? const Text("No badges yet 💧")
                          : Wrap(
                              spacing: 8,
                              children: badges
                                  .map((e) => Chip(label: Text(e)))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 💧 BUTTON WIDGET
  Widget waterBtn(int ml) {
    return ElevatedButton(
      onPressed: () => addWater(ml),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text("+$ml ml"),
    );
  }

  // 💎 GLASS CARD
  Widget glassCard({required String icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}