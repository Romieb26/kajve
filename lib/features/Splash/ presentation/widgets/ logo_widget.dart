import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        Container(

          width: 220,
          height: 220,


          decoration: const BoxDecoration(

            shape: BoxShape.circle,

            color: Color(0xffC88A4A),

          ),

      child: Image.asset(
        'assets/fokin.png',
        width: 110,
        height: 110,
        fit: BoxFit.contain,
          ),

        ),

        const SizedBox(height: 25),

        const Text(

          "KAJVE",

          style: TextStyle(

            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,

          ),

        ),

      ],

    );

  }
}