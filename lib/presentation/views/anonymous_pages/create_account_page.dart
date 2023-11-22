import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../widgets/outlined_text_form_field.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          customBorder: const CircleBorder(),
          // radius: 5,
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: SvgPicture.asset(Assets.leftArrow, width: 24, height: 24),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 18, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 6, bottom: 8),
              child: Text(
                'Registration',
                style: TextStyle(
                  color: AppColors.black1,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 6, bottom: 12),
              child: Text(
                'Create your account',
                style: TextStyle(
                  color: AppColors.black1,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            OutlinedTextFormField(controller: _emailController, labelText: 'Email'),
            const SizedBox(height: 15),
            OutlinedTextFormField(controller: _usernameController, labelText: 'user name'),
            const SizedBox(height: 15),
            Row(
              children: [
                Flexible(child: OutlinedTextFormField(controller: _genderController, labelText: 'gender')),
                const SizedBox(width: 19),
                Flexible(child: OutlinedTextFormField(controller: _ageController, labelText: 'age')),
              ],
            ),
            const SizedBox(height: 15),
            OutlinedTextFormField(controller: _passwordController, labelText: 'password'),
            const SizedBox(height: 15),
            OutlinedTextFormField(controller: _confirmPasswordController, labelText: 'confirm password'),

          ],
        ),
      ),

    );
  }
}
