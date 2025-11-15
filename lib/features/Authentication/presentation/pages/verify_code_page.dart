import 'dart:async';

import 'package:custom_numeric_pad/custom_numpad_package.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/toastification.dart';
import '../../../../gen/loading/dialog_screen.dart';
import '../provider/authentication_provider.dart';
import '../widgets/back_button.dart';
import 'recovery_password_page.dart';

class VerifyCodePage extends StatefulWidget {
  final bool isEmail;
  final String emailOrPhoneNumber;

  const VerifyCodePage({
    super.key,
    required this.isEmail,
    required this.emailOrPhoneNumber,
  });

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  String verificationCode = '';
  final int codeLength = 4;
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // state for reset functionality
  bool _canResend = true;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  // dration countdown (sec)
  static const int _resendCooldownDuration = 120;

  @override
  void initState() {
    super.initState();
    _focusNode.canRequestFocus = false;

    // validasi, listener memastikan biar ga lebih dari 4
    _pinController.addListener(() {
      // Remove invalid characters: ./'][] and others you want to restrict
      final invalidChars = RegExp(r"[./'\]\[]");
      String filtered = _pinController.text.replaceAll(invalidChars, '');

      // Limit to codeLength
      if (filtered.length > codeLength) {
        filtered = filtered.substring(0, codeLength);
      }

      if (_pinController.text != filtered) {
        _pinController.text = filtered;
        _pinController.selection = TextSelection.fromPosition(
          TextPosition(offset: _pinController.text.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define pinput theme
    final defaultPinTheme = PinTheme(
      width: 75,
      height: 85,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        color: Colors.grey.shade50,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF3F7CFF), width: 2),
      // ignore: deprecated_member_use
      color: const Color(0xFF3F7CFF).withOpacity(0.1),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF3F7CFF), width: 2),
      // ignore: deprecated_member_use
      color: const Color(0xFF3F7CFF).withOpacity(0.1),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AuthenticationCustomBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isVerifyCodeLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.resetVerifyCodeStatus();

              showLoadingDialog(context, text: "Verifying...");
            });
          }

          if (authProvider.verifyCodeStatus == AuthStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pop();
              authProvider.resetVerifyCodeStatus();

              showCustomToast(
                context: context,
                message: "Successfully Verified!",
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder:
                      (context) => RecoveryPasswordPage(
                        emailOrPhoneNumber: widget.emailOrPhoneNumber,
                        isWithEmail: widget.isEmail,
                      ),
                ),
                (route) => route.isFirst,
              );
            });
          }

          if (authProvider.verifyCodeStatus == AuthStatus.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pop();
              authProvider.resetVerifyCodeStatus();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  dismissDirection: DismissDirection.up,
                  content: Row(
                    children: [
                      Iconify(Ic.round_warning, color: Colors.white),
                      SizedBox(width: 10),

                      Text(
                        // "Wrong Verification Code",
                        authProvider.cleanErrorMessage,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 100,
                    left: 10,
                    right: 10,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            });
          }

          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),

                      // Header
                      const Text(
                        'Verify Code',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'Please enter the verification code\nsent to ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            TextSpan(
                              text:
                                  widget.isEmail
                                      ? widget.emailOrPhoneNumber
                                      : '+62 ${widget.emailOrPhoneNumber.substring(3, 6)}-${widget.emailOrPhoneNumber.substring(6, 10)}-${widget.emailOrPhoneNumber.substring(10)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(
                                  255,
                                  146,
                                  181,
                                  255,
                                ), // Blue color
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Code Display
                      Center(
                        child: Pinput(
                          controller: _pinController,
                          focusNode: _focusNode,
                          length: codeLength,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          showCursor: false,
                          readOnly: true,
                          onChanged: (value) {
                            setState(() {
                              verificationCode = value;
                            });
                          },
                          onCompleted: (pin) {
                            // Auto verify when completed
                            print('Completed: $pin');
                            _verifyCode();
                          },
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Resend Code
                      Text.rich(
                        TextSpan(
                          text: "If you didn't receive a code? ",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  _canResend
                                      ? 'Resend'
                                      : 'Resend in ${_formatCountdown(_resendCountdown)}',
                              style: const TextStyle(
                                color: Color(0xFF3F7CFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              recognizer:
                                  TapGestureRecognizer()..onTap = _resendCode,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Custom Numeric Pad dengan styling yang lebih baik
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,

                  decoration: BoxDecoration(color: const Color(0xFF3F7CFF)),
                  child: CustomNumPad(
                    controller: _pinController,
                    buttonHeight: 80,
                    buttonWidth: 80,
                    rowSpacing: 15,
                    columnSpacing: 50,
                    cornerRadius: 10,
                    bgColor: Colors.transparent,

                    buttonColor: Colors.transparent,
                    buttonBorderColor: Colors.transparent,
                    buttonTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _verifyCode() async {
    if (verificationCode.length == codeLength) {
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.verifyCode(
        otp: verificationCode,
        email: widget.isEmail ? widget.emailOrPhoneNumber : null,
        phoneNumber: widget.isEmail ? null : widget.emailOrPhoneNumber,
        isWithEmail: widget.isEmail,
      );
    }
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _resendCountdown = _resendCooldownDuration;
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() async {
    if (!_canResend) return;
    print('Resend!');

    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    _startCountdown();

    await authProvider.sendForgotPassword(
      isWithEmail: widget.isEmail,
      phoneNumber: widget.isEmail ? null : widget.emailOrPhoneNumber,
      email: widget.isEmail ? widget.emailOrPhoneNumber : null,
    );

    authProvider.resetForgotPasswordStatus();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification code sent to ${widget.emailOrPhoneNumber}',
          ),
          backgroundColor: Color(0xFF3F7CFF),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 10,
            right: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  String _formatCountdown(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pinController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
