import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/helper/convert_to_formatted_phone.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/toastification.dart';
import '../../../../gen/loading/dialog_screen.dart';
import '../../../../gen/loading/wave_loading.dart';
import '../../../../widgets/text_fields.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../Authentication/presentation/widgets/back_button.dart';
import '../provider/user_provider.dart';

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final TextEditingController _nameController = TextEditingController(
    text: "Example User",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "example@gmail.com",
  );
  final TextEditingController _phoneNumberController = TextEditingController(
    text: "+62 878-8888-9999",
  );
  final TextEditingController _roleController = TextEditingController(
    text: "Administrator",
  );

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthenticationProvider>();

    final token = authProvider.authorization!.token;

    authProvider.getUserFromApi(token: token);

    _nameController.text = authProvider.userProfile?.name ?? '';
    _emailController.text = authProvider.userProfile?.email ?? '';
    _phoneNumberController.text = convertToFormattedPhone(
      authProvider.userProfile?.phoneNumber ?? '',
    );
    _roleController.text = authProvider.userProfile?.role ?? '';
  }

  void editProfile() async {
    final authProvider = context.read<AuthenticationProvider>();
    final phoneNumber = _phoneNumberController.text.replaceAll(
      RegExp(r'[\+\s\-]'),
      '',
    );

    if (_nameController.text.trim().isEmpty) {
      showCustomToast(
        context: context,
        message: "Name cannot be empty",
        primaryColor: AppColors.white,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.error,
      );
      return;
    }

    if (phoneNumber.isEmpty) {
      showCustomToast(
        context: context,
        message: "Phone number cannot be empty",
        primaryColor: AppColors.white,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.error,
      );
      return;
    }

    if (phoneNumber.length > 18) {
      showCustomToast(
        context: context,
        message: "Phone number cannot exceed 18 characters",
        primaryColor: AppColors.white,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.error,
      );
      return;
    }

    print(_nameController.text);
    print(phoneNumber);
    print(authProvider.userProfile!.name);
    print(authProvider.userProfile!.phoneNumber);

    if (phoneNumber == authProvider.userProfile!.phoneNumber &&
        _nameController.text == authProvider.userProfile!.name) {
      showCustomToast(
        context: context,
        message:
            "No changes detected. Please modify your information before saving.",
        primaryColor: AppColors.white,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.error,
      );
      return;
    }

    final userProvider = context.read<UserProvider>();

    await userProvider.editProfile(
      token: authProvider.authorization!.token,
      newName: _nameController.text,
      newPhoneNumber: phoneNumber,
    );
  }

  void _refreshData() async {
    final authProvider = context.read<AuthenticationProvider>();
    await authProvider.getUserFromApi(token: authProvider.authorization!.token);

    _nameController.text = authProvider.userProfile?.name ?? '';
    _emailController.text = authProvider.userProfile?.email ?? '';
    _phoneNumberController.text = convertToFormattedPhone(
      authProvider.userProfile?.phoneNumber ?? '',
    );
    _roleController.text = authProvider.userProfile?.role ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: AppBar(
        title: Text(
          'Edit your Account Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AuthenticationCustomBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer2<AuthenticationProvider, UserProvider>(
        builder: (context, authProvider, userProvider, child) {
          if (userProvider.editProfileStatus == ResponseStatus.loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showLoadingDialog(context, text: "Editing your profile...");
            });
          } else if (userProvider.editProfileStatus == ResponseStatus.success) {
            Navigator.of(context, rootNavigator: true).pop();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomToast(
                context: context,
                message: 'Success, your profile has been updated!',
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
            });

            _refreshData();

            userProvider.resetAllStatus();
          } else if (userProvider.editProfileStatus == ResponseStatus.error) {
            Navigator.of(context, rootNavigator: true).pop();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomToast(
                context: context,
                message: userProvider.errorMessage ?? '',
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                primaryColor: AppColors.white,
              );
            });

            userProvider.resetAllStatus();
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9999),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://ui-avatars.com/api/?name=${authProvider.userProfile?.name ?? ''}&background=7F9CF5&color=ffffff&size=128&rounded=true&bold=true",
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 10,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: AppColors.primary,
                                      size: 100,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        // edit profile
                        // Positioned(
                        //   bottom: 8,
                        //   right: 8,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       print('clicked open photo');
                        //     },
                        //     child: Container(
                        //       width: 48,
                        //       height: 48,
                        //       decoration: BoxDecoration(
                        //         color: Colors.black54,
                        //         shape: BoxShape.circle,
                        //         border: Border.all(color: Colors.white, width: 3),
                        //       ),
                        //       child: const Icon(
                        //         Icons.camera_alt_rounded,
                        //         color: Colors.white,
                        //         size: 24,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // back to normal
                        // Positioned(
                        //   top: 8,
                        //   right: 8,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       print('clicked delete photo');
                        //     },
                        //     child: Container(
                        //       width: 48,
                        //       height: 48,
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         shape: BoxShape.circle,
                        //         border: Border.all(color: Colors.white, width: 3),
                        //       ),
                        //       child: const Iconify(
                        //         SystemUicons.cross,
                        //         color: Colors.red,
                        //         size: 24,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Gap(40),

                  authProvider.getUserFromApiStatus == AuthStatus.loading
                      ? WaveLoading()
                      : authProvider.getUserFromApiStatus == AuthStatus.error
                      ? Center(child: WaveLoading())
                      : Column(
                        children: [
                          GeneralTextField(
                            controller: _nameController,
                            hintText: 'Your Name',
                            prefixIcon: Icons.verified_user_outlined,
                          ),
                          Gap(20),
                          GeneralTextField(
                            controller: _emailController,
                            hintText: 'Your Email',
                            prefixIcon: Icons.email_outlined,
                            readOnly: true,
                          ),
                          Gap(20),
                          GeneralTextField(
                            controller: _phoneNumberController,
                            hintText: 'Your Phone Number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          Gap(20),
                          GeneralTextField(
                            controller: _roleController,
                            hintText: 'Your Role',
                            prefixIcon: Icons.supervised_user_circle_outlined,
                            readOnly: true,
                          ),
                        ],
                      ),

                  Spacer(),
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        minimumSize: Size(100, 55),
                      ),
                      onPressed: editProfile,
                      child: const Text(
                        'Confirm my Editing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCED4FF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
