import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../gen/alert/toastification.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/snack_bar.dart';
import '../../../../gen/loading/dialog_screen.dart';
import '../provider/authentication_provider.dart';
import '../widgets/back_button.dart';
import '../widgets/recovery_password_with_label_validation.dart';
import 'login_page.dart';

class RecoveryPasswordPage extends StatefulWidget {
  final bool isWithEmail;
  final String emailOrPhoneNumber;

  const RecoveryPasswordPage({
    super.key,
    required this.emailOrPhoneNumber,
    required this.isWithEmail,
  });

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: AuthenticationCustomBackButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.recoveryPasswordStatus == AuthStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context, true);
              authProvider.resetRecoveryPasswordStatus();

              showCustomToast(
                context: context,
                message: "Password Recovered Successful",
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            });
          }

          if (authProvider.isRecoveryPasswordLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.resetRecoveryPasswordStatus();

              showLoadingDialog(context, text: "Recovering...");
            });
          }

          if (authProvider.recoveryPasswordStatus == AuthStatus.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.resetRecoveryPasswordStatus();

              showCustomToast(
                context: context,
                message: "Password Recovered Successful",
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
            });
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Create New Password",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      text: "Resetting for: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: widget.emailOrPhoneNumber,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Your password should be different from the previous one.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 50),

                  AuthenticationRecoveryPasswordWithLabelValidation(
                    label: "Password",
                    hintText: "Enter new password",
                    prefixIcon: Icons.lock_outline,
                    controller: _newPasswordController,
                    obscureText: !_isNewPasswordVisible,
                    suffixIcon:
                        _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixIconTap: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  AuthenticationRecoveryPasswordWithLabelValidation(
                    label: "Confirm new password",
                    hintText: "Confirm new password",
                    prefixIcon: Icons.lock_outline,
                    controller: _confirmNewPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    suffixIcon:
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixIconTap: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),

                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F7CFF),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed:
                          authProvider.recoveryPasswordStatus ==
                                  AuthStatus.loading
                              ? null
                              : _resetPassword,
                      child:
                          authProvider.recoveryPasswordStatus ==
                                  AuthStatus.loading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Reset Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    final authProvider = context.read<AuthenticationProvider>();

    if (_newPasswordController.text.isEmpty) {
      showCustomToast(
        context: context,
        message: "Please enter new password",
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.white,
        primaryColor: AppColors.white,
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      showCustomToast(
        context: context,
        message: "Password must be at least 6 characters",
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.white,
        primaryColor: AppColors.white,
      );
      return;
    }

    if (_newPasswordController.text != _confirmNewPasswordController.text) {
       showCustomToast(
        context: context,
        message: "Password do not match",
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.white,
        primaryColor: AppColors.white,
      );
      return;
    }

    await authProvider.recoveryPassword(
      isWithEmail: widget.isWithEmail,
      email: widget.isWithEmail ? widget.emailOrPhoneNumber : null,
      phoneNumber: widget.isWithEmail ? null : widget.emailOrPhoneNumber,
      newPassword: _newPasswordController.text,
      newPasswordConfirmation: _confirmNewPasswordController.text,
    );
  }
}
