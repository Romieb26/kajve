import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_protector/screen_protector.dart';

import '../providers/register_provider.dart';
import '../widgets/register_button.dart';
import '../widgets/register_form.dart';
import '../../../auth/presentation/widgets/logo_login.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  void initState() {
    super.initState();
    ScreenProtector.preventScreenshotOn();
  }

  @override
  void dispose() {
    ScreenProtector.preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final controller = ref.read(registerControllerProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff6A301A),
              Color(0xffC96A00),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(24.r),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(height: 20.h),

                      const LogoLogin(),

                      SizedBox(height: 30.h),

                      Text(
                        "Crear cuenta",
                        style: TextStyle(
                          fontSize: 26.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 25.h),

                      RegisterForm(state: state, controller: controller),

                      SizedBox(height: 25.h),

                      RegisterButton(state: state, controller: controller),

                      SizedBox(height: 20.h),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "¿Ya tienes cuenta? Inicia sesión",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
