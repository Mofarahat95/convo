import 'dart:ui';
import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blurred Background Image
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Image.asset(
                'lib/images/callImage.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Call UI Content

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'lib/images/callImage.jpg'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Basem Faisl',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Incoming call',
                style: TextStyle(fontSize: 17, color: Colors.white70),
              ),
              const SizedBox(
                height: 200,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Icon(Icons.access_time, color: Colors.white, size: 30),
                      const SizedBox(height: 5),
                      Text('Remind me', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(Icons.message, color: Colors.white, size: 30),
                      SizedBox(height: 5),
                      Text('Message', style: TextStyle(color: Colors.white))
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {

                  },
                  child: Container(
                    width: 285,
                    height: 65,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.green,
                          size: 25,
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Slide to answer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
