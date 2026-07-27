import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../../core/routes/app_routes.dart';

import '../providers/auth_provider.dart';
import '../widgets/logo_login.dart';
import '../widgets/login_form.dart';
import '../widgets/login_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

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

                      LoginForm(state: state, controller: controller),

                      SizedBox(height: 25.h),

                      LoginButton(state: state, controller: controller),

                      SizedBox(height: 30.h),

                      if (state.cargando)
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),

                      SizedBox(height: 20.h),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.register,
                          );
                        },
                        child: const Text(
                          "¿No tienes cuenta? Regístrate",
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
