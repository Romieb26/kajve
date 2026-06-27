import 'package:flutter/material.dart';

class QrCard extends StatelessWidget {
  const QrCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        const Text(
          "QR",
          style: TextStyle(
            fontSize:22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height:10),

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
              size:120,
            ),
          ),
        ),

      ],
    );
  }
}