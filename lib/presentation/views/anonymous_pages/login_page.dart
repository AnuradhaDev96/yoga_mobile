import 'package:flutter/material.dart';

import '../../../config/themes/button_styles.dart';
import '../../../config/themes/default_text_styles.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../widgets/outlined_text_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage(Assets.loginScreenImage), fit: BoxFit.fitWidth),
                ),
              ),
              Opacity(
                opacity: 0.69,
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.08, 0.25, 1],
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.8783),
                        const Color(0xFF170A5A).withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 33, left: 17, right: 17, bottom: MediaQuery.viewInsetsOf(context).bottom),
              child: Column(
                children: [
                  OutlinedTextFormField(
                    controller: _emailController,
                    labelText: 'Email',
                  ),
                  const SizedBox(height: 14),
                  OutlinedTextFormField(
                    controller: _passwordController,
                    labelText: 'password',
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {

                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColors.indigo1,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: DefaultTextStyles.defaultFontFamily,
                            color: AppColors.black1,
                            fontSize: 12,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: 'By continuing, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.indigo1,
                              ),
                            ),
                            TextSpan(
                              text: ' and\n',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.indigo1,
                              ),
                            ),
                            TextSpan(
                              text: '.',
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyles.primaryElevatedButtonStyle(context),
                    child: const Text('Log in'),
                  ),
                  const SizedBox(height: 38),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
