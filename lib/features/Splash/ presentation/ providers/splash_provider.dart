import 'dart:async';

import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {

  Future<void> iniciar(BuildContext context) async {

    await Future.delayed(const Duration(seconds: 3));

    //Aquí después irá el Login

  }

}