import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../config/themes/button_styles.dart';
import '../../../domain/enums/gender_enum.dart';
import '../../../utils/extensions/validate_string_input.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/resources/message_utils.dart';
import '../../blocs/anonymous_pages/create_account_cubit.dart';
import '../../states/data_payload_state.dart';
import '../../widgets/outlined_text_form_field.dart';
import 'login_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _createAccountCubit = CreateAccountCubit();

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
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }

                  if (!value.isValidEmail) {
                    return 'Enter valid email address';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              OutlinedTextFormField(
                controller: _usernameController,
                labelText: 'user name',
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }

                  return null;
                },
              ),
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
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a password';
                  }

                  if (value.length < 6) {
                    return 'Password should contain at least 6 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              OutlinedTextFormField(
                controller: _confirmPasswordController,
                labelText: 'confirm password',
                keyboardType: TextInputType.visiblePassword,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter confirm password';
                  }

                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: BlocProvider<CreateAccountCubit>(
          create: (context) => _createAccountCubit,
          child: BlocListener<CreateAccountCubit, DataPayloadState>(
            bloc: _createAccountCubit,
            listener: (context, state) {
              if (state is ErrorState) {
                // show error message on login error
                MessageUtils.showSnackBarOverBarrier(context, state.errorMessage, isErrorMessage: true);
              } else if (state is SuccessState) {
                // Replace route to login page after creating account
                MessageUtils.showSnackBarOverBarrier(context, 'User registered successfully');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            child: BlocBuilder<CreateAccountCubit, DataPayloadState>(
                bloc: _createAccountCubit,
                builder: (context, state) {
                  if (state is RequestingState) {
                    return Lottie.asset(Assets.loadingDots, height: 70);
                  }

                  return ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState!.validate()) {
                        _createAccountCubit.createAccount(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                          gender: _selectedGender.dtoValue,
                        );
                      }
                    },
                    style: ButtonStyles.primaryElevatedButtonStyle(context),
                    child: const Text('Create Account'),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
