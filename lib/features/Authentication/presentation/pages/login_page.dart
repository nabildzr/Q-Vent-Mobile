import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/helper/validation_helper.dart';
import '../../../../core/provider/validation_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/toastification.dart';
import '../../../Landing/presentation/pages/landing_page.dart';
import '../../../User/presentation/provider/user_provider.dart';
import '../provider/authentication_provider.dart';
import '../widgets/text_field.dart';
import '../widgets/text_field_digits.dart';
import '../widgets/text_field_label.dart';
import 'verify_code_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isForgotPasswordWithEmail = true;
  late TabController _tabController;

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotPasswordWithPhoneNumberController =
      TextEditingController();
  final TextEditingController _forgotPasswordWithEmailController =
      TextEditingController();

  // String? _emailError;
  // String? _passwordError;
  // String? _forgotEmailError;
  // String? _forgotPhoneError;

  // Loading states
  // bool _isLoading = false;

  void _handleLogin() async {
    final validationProvider = context.read<ValidationProvider>();
    final authProvider = context.read<AuthenticationProvider>();

    validationProvider.validateEmail(_emailController.text);
    validationProvider.validatePassword(_passwordController.text);

    if (validationProvider.isFormValid) {
      authProvider.signIn(_emailController.text, _passwordController.text);
    }
  }

  void _handleForgotPassword() {
    final validationProvider = context.read<ValidationProvider>();
    final authProvider = context.read<AuthenticationProvider>();

    if (_isForgotPasswordWithEmail) {
      validationProvider.validateEmail(_forgotPasswordWithEmailController.text);

      if (validationProvider.emailError == null) {
        authProvider.sendForgotPassword(
          isWithEmail: true,
          email: _forgotPasswordWithEmailController.text,
        );
      }
    } else {
      validationProvider.validatePhoneNumber(
        _forgotPasswordWithPhoneNumberController.text,
      );

      if (validationProvider.phoneError == null) {
        String formattedPhone = ValidationHelper.formatPhoneNumber(
          _forgotPasswordWithPhoneNumberController.text,
        );

        print('formatted phone: $formattedPhone');

        authProvider.sendForgotPassword(
          isWithEmail: false,
          phoneNumber: formattedPhone,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _forgotPasswordWithPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<ValidationProvider, AuthenticationProvider, UserProvider>(
        builder: (
          context,
          validationProvider,
          authProvider,
          userProvider,
          child,
        ) {
          // handle login success
          if (authProvider.authStatus == AuthStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.resetAuthStatus();

              // get user after auth success
              authProvider.getUserFromApi(
                token: authProvider.authorization!.token,
              );

              authProvider.resetAuthStatus();

              showCustomToast(
                context: context,
                message: "Login Successful",
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LandingPage()),
              );
            });
          }

          // handle login error
          if (authProvider.authStatus == AuthStatus.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.resetAuthStatus();

              showCustomToast(
                context: context,
                message: authProvider.cleanErrorMessage,
                backgroundColor: AppColors.warning,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
            });
          }

          // handle forgot password success
          if (authProvider.forgotPasswordStatus == AuthStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.resetForgotPasswordStatus();

              showCustomToast(
                context: context,
                message: "Verification sent!",
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => VerifyCodePage(
                        isEmail: _isForgotPasswordWithEmail,
                        emailOrPhoneNumber:
                            _isForgotPasswordWithEmail
                                ? _forgotPasswordWithEmailController.text
                                : _forgotPasswordWithPhoneNumberController.text,
                      ),
                ),
              );
            });
          }

          // handle forgot password error
          if (authProvider.forgotPasswordStatus == AuthStatus.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.resetForgotPasswordStatus();

               showCustomToast(
                context: context,
                message: authProvider.cleanErrorMessage,
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
            });
          }

          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF3F7CFF),
                      Color.fromARGB(255, 180, 206, 255),
                    ],
                  ),
                ),
              ),

              // title
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 75, horizontal: 40),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      _tabController.index == 0
                          ? 'Kindly Sign in to\ncontinue.'
                          : "Recover Your\nAccount.",
                      key: ValueKey(_tabController.index),
                      style: const TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,

                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTabBar(),

                        SizedBox(height: 20),

                        Expanded(
                          child:
                              _tabController.index == 0
                                  ? _buildSignInTab(
                                    validationProvider,
                                    authProvider,
                                  )
                                  : _buildForgotPasswordTab(
                                    validationProvider,
                                    authProvider,
                                  ),
                        ),
                      ],
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

  Widget _buildSignInTab(
    ValidationProvider validationProvider,
    AuthenticationProvider authProvider,
  ) {
    return Column(
      children: [
        AuthenticationCustomTextFieldLabel(text: "Email"),
        SizedBox(height: 8),
        AuthenticationCustomTextField(
          controller: _emailController,
          hintText: "Enter your Email",
          prefixIcon: Icons.email_outlined,
          errorText: validationProvider.emailError,
          keyboardType: TextInputType.emailAddress,
        ),

        Gap(10),

        AuthenticationCustomTextFieldLabel(text: "Password"),
        Gap(8),
        AuthenticationCustomTextField(
          controller: _passwordController,
          hintText: "Enter your Password",
          prefixIcon: Icons.lock_outline,
          obscureText: !_isPasswordVisible,
          errorText: validationProvider.passwordError,
          onSuffixIconTap: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          suffixIcon:
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),

        Gap(15),
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
            onPressed: authProvider.isLoading ? null : _handleLogin,
            child:
                authProvider.isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),

        Gap(15),

        Text.rich(
          TextSpan(
            text: 'By Using Q-Vent you agree to our\n',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),

            children: [
              TextSpan(
                text: 'Terms and Data Policy.',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForgotPasswordTab(
    ValidationProvider validationProvider,
    AuthenticationProvider authProvider,
  ) {
    return Column(
      children: [
        _isForgotPasswordWithEmail
            ? const AuthenticationCustomTextFieldLabel(text: "Email")
            : const AuthenticationCustomTextFieldLabel(text: "Phone Number"),
        const SizedBox(height: 8),
        _isForgotPasswordWithEmail
            ? AuthenticationCustomTextField(
              controller: _forgotPasswordWithEmailController,
              hintText: "Enter your Email",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              errorText: validationProvider.emailError,
            )
            : AuthenticationCustomTextFieldDigits(
              controller: _forgotPasswordWithPhoneNumberController,
              hintText: "Enter your Phone Number",
              prefixIcon: Icons.phone_outlined,

              errorText: validationProvider.phoneError,
            ),
        SizedBox(height: 15),
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
                authProvider.isForgotPasswordLoading
                    ? null
                    : _handleForgotPassword,
            child:
                authProvider.isForgotPasswordLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      "Send Reset Link",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),

        SizedBox(height: 15),

        Text.rich(
          TextSpan(
            text:
                'Not receiving ${_isForgotPasswordWithEmail ? "emails" : "sms verification"}?\n',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            children: [
              TextSpan(
                text:
                    'Try using your ${_isForgotPasswordWithEmail ? "Phone Number" : "Email"}',
                style: TextStyle(color: Colors.blue),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () async {
                        _isForgotPasswordWithEmail
                            ? print(
                              'Forgot Password Method Changed!, Currently with Email  : $_isForgotPasswordWithEmail',
                            )
                            : print(
                              'Forgot Password Method Changed!, Currently with Phone Number : $_isForgotPasswordWithEmail',
                            );

                        await Future.delayed(Duration(milliseconds: 300));
                        setState(() {
                          _isForgotPasswordWithEmail =
                              !_isForgotPasswordWithEmail;
                        });
                      },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFDDE9FF),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        padding: EdgeInsets.all(4),
        indicator: BoxDecoration(
          color: Color(0xFF3F7CFF),
          borderRadius: BorderRadius.circular(25),
        ),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        unselectedLabelColor: Color(0xFF3F7CFF),
        labelColor: Colors.white,
        onTap: (value) {
          setState(() {});
        },
        tabs: [
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text('Sign In'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text('Forgot Password'),
            ),
          ),
        ],
      ),
    );
  }
}
