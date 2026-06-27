import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ providers/splash_provider.dart';
import '../widgets/ logo_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SplashProvider>().iniciar(context);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [

              Color(0xff6B2E18),
              Color(0xffC96A00),

            ],

          ),

        ),

        child: const Center(
          child: LogoWidget(),
        ),

      ),

    );
  }
}