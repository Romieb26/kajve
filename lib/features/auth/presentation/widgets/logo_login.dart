import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoLogin extends StatelessWidget {
  const LogoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          width: 140.r,
          height: 140.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/fokin2.png',
            width: 80.r,
            height: 80.r,
          ),
        ),

        SizedBox(height: 20.h),

        Text(
          "KAJVE",
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        SizedBox(height: 10.h),

        Text(
          "Sistema Inteligente para el Monitoreo del Secado del Café",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15.sp,
          ),
        ),

      ],
    );
  }
}
