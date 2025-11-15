import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/provider/validation_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/toastification.dart';
import '../../../../gen/loading/dialog_screen.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../Authentication/presentation/widgets/back_button.dart';
import '../../../Authentication/presentation/widgets/text_field.dart';
import '../../../Authentication/presentation/widgets/text_field_label.dart';
import '../provider/change_password_provider.dart';

class ChangePasswordInProfilePage extends StatefulWidget {
  const ChangePasswordInProfilePage({super.key});

  @override
  State<ChangePasswordInProfilePage> createState() =>
      _ChangePasswordInProfilePageState();
}

class _ChangePasswordInProfilePageState
    extends State<ChangePasswordInProfilePage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmationController =
      TextEditingController();

  List<String> _currentPasswordErrors = [];
  List<String> _newPasswordErrors = [];
  List<String> _confirmPasswordErrors = [];

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  void _changeMyPassword() async {
    final authProvider = context.read<AuthenticationProvider>();
    final changePasswordProvider = context.read<ChangePasswordProvider>();

    _currentPasswordErrors = [];
    _newPasswordErrors = [];
    _confirmPasswordErrors = [];

    await changePasswordProvider.changePassword(
      token: authProvider.authorization!.token,
      userId: authProvider.userProfile!.id,
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      newPasswordConfirmation: _newPasswordConfirmationController.text,
    );
  }

  void _resetField() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _newPasswordConfirmationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final validationProvider = context.read<ValidationProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AuthenticationCustomBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ChangePasswordProvider>(
        builder: (context, changePasswordProvider, child) {
          if (changePasswordProvider.changePasswordStatus ==
              ResponseStatus.loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showLoadingDialog(context, text: "Changing your password...");
            });
          } else if (changePasswordProvider.changePasswordStatus ==
              ResponseStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pop();

              showCustomToast(
                context: context,
                message: 'Success, your password changed!',
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
            });

            _resetField();
            changePasswordProvider.resetAllStatus();
          } else if (changePasswordProvider.changePasswordStatus ==
              ResponseStatus.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pop();

              showCustomToast(
                context: context,
                message: "Failed to change Password",
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
            });

            if (changePasswordProvider.errorEntity != null) {
              setState(() {
                _currentPasswordErrors =
                    changePasswordProvider.currentPasswordErrors;
                _newPasswordErrors = changePasswordProvider.newPasswordErrors;
                _confirmPasswordErrors =
                    changePasswordProvider.newPasswordConfirmationErrors;
              });
            }

            _resetField();
            changePasswordProvider.resetAllStatus();
          }

          return SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),

                    child: Column(
                      children: [
                        Gap(20),
                        Lottie.asset(
                          'assets/lottie/change_password_nabildzr.json',
                          width: 200,
                        ),
                        Gap(20),
                        AuthenticationCustomTextFieldLabel(
                          text: "Current Password",
                        ),

                        _buildErrorMessages(_currentPasswordErrors),
                        SizedBox(height: 8),
                        AuthenticationCustomTextField(
                          hintText: "Enter your Current Password",
                          prefixIcon: Icons.lock_outline,
                          controller: _currentPasswordController,
                          obscureText: !_isCurrentPasswordVisible,
                          errorText: validationProvider.passwordError,
                          onSuffixIconTap: () {
                            setState(() {
                              _isCurrentPasswordVisible =
                                  !_isCurrentPasswordVisible;
                            });
                          },
                          suffixIcon:
                              _isCurrentPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                        ),
                        Gap(15),
                        AuthenticationCustomTextFieldLabel(
                          text: "New Password",
                        ),
                        _buildErrorMessages(_newPasswordErrors),
                        SizedBox(height: 8),

                        AuthenticationCustomTextField(
                          hintText: "Enter your New Password",
                          prefixIcon: Icons.lock_outline,
                          controller: _newPasswordController,
                          obscureText: !_isNewPasswordVisible,
                          errorText: validationProvider.passwordError,
                          onSuffixIconTap: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                          suffixIcon:
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                        ),
                        Gap(15),
                        AuthenticationCustomTextFieldLabel(
                          text: "New Password Confirmation",
                        ),
                        _buildErrorMessages(_confirmPasswordErrors),
                        SizedBox(height: 8),

                        AuthenticationCustomTextField(
                          hintText: "Enter your New Password Confirmation",
                          prefixIcon: Icons.lock_outline,
                          controller: _newPasswordConfirmationController,
                          obscureText: !_isConfirmPasswordVisible,
                          errorText: validationProvider.passwordError,
                          onSuffixIconTap: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          suffixIcon:
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 20.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          minimumSize: Size(100, 55),
                        ),
                        onPressed: _changeMyPassword,
                        child: const Text(
                          'Change my password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCED4FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildErrorMessages(List<String> errors) {
  if (errors.isEmpty) return SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ...List.generate(errors.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: AuthenticationCustomTextFieldLabel(
            text: errors[index],
            color: AppColors.error,
          ),
        );
      }),
    ],
  );
}
