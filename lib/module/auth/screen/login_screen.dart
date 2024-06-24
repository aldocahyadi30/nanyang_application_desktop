import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/auth/widget/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _opacity = 0.0; // Initial opacity value

  @override
  void initState() {
    super.initState();
    // Delay setting opacity to 1.0 for the fade-in effect
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _opacity = 1.0; // Set opacity to fully visible
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorTemplate.periwinkle, ColorTemplate.violetBlue],
            stops: [0.3, 0.9],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/login_bg.svg',
                      fit: BoxFit.fill,
                    ),
                    //positioned centered logo
                    Container(
                      padding: dynamicPaddingOnly(0, 160, 160, 0, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'logo',
                            child: SvgPicture.asset(
                              'assets/image/logo-nanyang.png',
                              width: dynamicWidth(250, context),
                              height: dynamicHeight(250, context),
                            ),
                          ),
                          SizedBox(height: dynamicHeight(8, context)),
                          Text(
                            'Nanyang App',
                            style: TextStyle(
                              fontSize: dynamicFontSize(64, context),
                              fontWeight: FontWeight.bold,
                              color: ColorTemplate.violetBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: dynamicPaddingOnly(0, 0, 0, 32, context),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          fontSize: dynamicFontSize(80, context),
                          fontWeight: FontWeight.bold,
                          color: ColorTemplate.violetBlue,
                        ),
                      ),
                      Padding(
                        padding: dynamicPaddingSymmetric(0, 96, context),
                        child: const LoginForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
