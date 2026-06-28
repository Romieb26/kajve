import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),

      height: 320,

      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Stack(
        alignment: Alignment.center,
        children: [

          const Icon(
            Icons.camera_alt,
            color: Colors.white54,
            size: 90,
          ),

          Container(
            width: 230,
            height: 230,

            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
                width: 4,
              ),

              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}