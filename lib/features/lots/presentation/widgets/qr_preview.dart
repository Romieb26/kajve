import 'package:flutter/material.dart';

class QrPreview extends StatelessWidget {
  const QrPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "QR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Icon(
              Icons.qr_code_2,
              size: 120,
            ),
          ),
        ),
      ],
    );
  }
}