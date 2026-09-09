import 'package:flutter/material.dart';

class CameraMrzViewfinder extends StatelessWidget {
  const CameraMrzViewfinder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Placeholder for camera preview
          const Center(
            child: Icon(Icons.camera_alt, color: Colors.white54, size: 48),
          ),
          // Viewfinder overlay
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF059669), width: 2), // Emerald
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  color: const Color(0xFF059669).withValues(alpha: 0.3),
                  child: const Center(
                    child: Text(
                      'Align MRZ here',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Text(
              'Hold steady... MRZ detected',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
