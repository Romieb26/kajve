import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 220.r,
          height: 220.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffC88A4A),
          ),
          child: Image.asset(
            'assets/fokin.png',
            width: 110.r,
            height: 110.r,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 25.h),
        Text(
          "KAJVE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
