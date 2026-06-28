import 'dart:ui';
import 'package:flutter/material.dart';
import '../notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int water = 1850;
  final int goal = 5000;
  int streak = 3;

  // 🏆 BADGES
  List<String> badges = [];

  // 🤖 AI MESSAGE (NEW)
  String aiMessage = "Stay hydrated 💧";

  // 🧠 AI LOGIC
  void updateAIMessage() {
    if (water < 1000) {
      aiMessage = "💧 You are dehydrated! Drink water now.";
    } else if (water < 2500) {
      aiMessage = "👍 Good progress! Keep drinking water.";
    } else if (water < 4500) {
      aiMessage = "🔥 Great job! You are well hydrated.";
    } else {
      aiMessage = "👑 Excellent! You are a hydration master!";
    }
  }

  void addWater(int ml) {
    setState(() {
      water = (water + ml).clamp(0, goal);

      // 🧠 AI UPDATE
      updateAIMessage();

      // 🏆 BADGES SYSTEM
      if (water >= 500 && !badges.contains("💧 Beginner")) {
        badges.add("💧 Beginner");
      }

      if (water >= 2000 && !badges.contains("💦 Hydrated")) {
        badges.add("💦 Hydrated");
      }

      if (water >= 5000 && !badges.contains("👑 Master")) {
        badges.add("👑 Master");
      }
    });

    NotificationService.showWaterNotification();
  }

  @override
  Widget build(BuildContext context) {
    double progress = water / goal;

    // 🧠 SAFE AI UPDATE
    updateAIMessage();

    return Scaffold(
      backgroundColor: const Color(0xffEAF8FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "AquaNova 💧",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // 💎 GLASS CARD
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [

                        const Text(
                          "💧 Stay Hydrated",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // 🌊 Progress Circle
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 160,
                              width: 160,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 12,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(
                                  Colors.blue,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.water_drop,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "$water ml",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Goal $goal ml",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "🔥 Streak: $streak days",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ➕ WATER BUTTONS
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

              const SizedBox(height: 25),

              // 📊 WEEKLY PROGRESS
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    Text(
                      "📊 Weekly Progress",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(value: 0.7),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 💙 MESSAGE
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

              const SizedBox(height: 20),

              // 🤖 AI CARD (NEW)
              Container(
                padding: const EdgeInsets.all(18),
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
                    const Text("🤖", style: TextStyle(fontSize: 30)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        aiMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🏆 BADGES
              Container(
                padding: const EdgeInsets.all(18),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    badges.isEmpty
                        ? const Text("No badges yet 💧 Keep drinking water!")
                        : Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: badges.map((b) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: Text(b),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ],
          ),
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