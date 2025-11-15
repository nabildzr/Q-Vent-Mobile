import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/helper/convert_to_formatted_phone.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/loading/wave_loading.dart';
import '../../../../widgets/text_fields.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../Authentication/presentation/widgets/back_button.dart';

class ProfileDataPage extends StatefulWidget {
  const ProfileDataPage({super.key});

  @override
  State<ProfileDataPage> createState() => _ProfileDataPageState();
}

class _ProfileDataPageState extends State<ProfileDataPage> {
  final TextEditingController _nameController = TextEditingController(
    text: "Nabil Dzikrika",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "nabildzikrika@gmail.com",
  );
  final TextEditingController _phoneNumberController = TextEditingController(
    text: "+62 878-1403-7811",
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

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthenticationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Your Profile Data',
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
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
                          decoration: BoxDecoration(color: AppColors.secondary),
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
                          decoration: BoxDecoration(color: AppColors.secondary),
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
              ),
              Gap(40),
              Consumer<AuthenticationProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.getUserFromApiStatus == AuthStatus.loading) {
                    return WaveLoading();
                  } else if (authProvider.getUserFromApiStatus ==
                      AuthStatus.error) {
                    return Center(child: WaveLoading());
                  } else {
                    return Column(
                      children: [
                        GeneralTextField(
                          controller: _nameController,
                          hintText: 'Nabil Dzikrika',
                          prefixIcon: Icons.verified_user_outlined,
                          readOnly: true,
                        ),
                        Gap(20),
                        GeneralTextField(
                          controller: _emailController,
                          hintText: 'Nabil Dzikrika',
                          prefixIcon: Icons.email_outlined,
                          readOnly: true,
                        ),
                        Gap(20),
                        GeneralTextField(
                          controller: _phoneNumberController,
                          hintText: 'Nabil Dzikrika',
                          prefixIcon: Icons.phone_outlined,
                          readOnly: true,
                        ),
                        Gap(20),
                        GeneralTextField(
                          controller: _roleController,
                          hintText: 'Nabil Dzikrika',
                          prefixIcon: Icons.supervised_user_circle_outlined,
                          readOnly: true,
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
