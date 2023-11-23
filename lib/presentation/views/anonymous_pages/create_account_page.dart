import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/themes/button_styles.dart';
import '../../../domain/enums/gender_enum.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../widgets/outlined_text_form_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  GenderEnum _selectedGender = GenderEnum.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
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
        padding: EdgeInsets.only(left: 18, right: 30, bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Form(
          key: _formKey,
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
              OutlinedTextFormField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              OutlinedTextFormField(controller: _usernameController, labelText: 'user name'),
              const SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColors.grey3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<GenderEnum>(
                          value: _selectedGender,
                          items: GenderEnum.values
                              .map((item) => DropdownMenuItem<GenderEnum>(
                                    value: item,
                                    child: Text(
                                      item.text,
                                      style: const TextStyle(
                                        color: AppColors.black1,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          dropdownColor: AppColors.grey1,
                          style: const TextStyle(
                            color: AppColors.black1,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(16),
                            label: Text('gender'),
                            labelStyle: TextStyle(fontSize: 16, color: AppColors.grey2),
                            border: UnderlineInputBorder(borderSide: BorderSide.none),
                          ),
                          borderRadius: BorderRadius.circular(8),
                          onChanged: (GenderEnum? value) {
                            setState(() {
                              _selectedGender = value ?? GenderEnum.male;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 19),
                  Flexible(
                    child: OutlinedTextFormField(
                      controller: _ageController,
                      labelText: 'age',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              OutlinedTextFormField(
                controller: _passwordController,
                labelText: 'password',
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 15),
              OutlinedTextFormField(
                controller: _confirmPasswordController,
                labelText: 'confirm password',
                keyboardType: TextInputType.visiblePassword,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyles.primaryElevatedButtonStyle(context),
          child: const Text('Create Account'),
        ),
      ),
    );
  }
}
