import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/octicon.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:provider/provider.dart';
import 'package:qr_event_management/features/Setting/presentation/pages/version_page.dart';

import '../../../../core/provider/network_status_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/toastification.dart';
import '../../../../gen/loading/dialog_screen.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../ChangePasswordInProfile/presentation/pages/change_password_in_profile.dart';
import '../../../Landing/presentation/func/logout.dart';
import '../../../User/presentation/pages/account_details_page.dart';
import '../../../User/presentation/pages/profile_data_page.dart';
import '../widgets/setting_group_head.dart';
import '../widgets/setting_item.dart';
import '../widgets/setting_landing_head.dart';

class SettingView extends StatelessWidget {
  const SettingView({
    super.key,
    required Animation<double> borderRadiusAnimation,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    if (authProvider.logoutStatus == AuthStatus.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authProvider.resetLogoutStatus();

        showLoadingDialog(context, text: "Logouting your account...");
      });
    }

    if (authProvider.logoutStatus == AuthStatus.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authProvider.resetLogoutStatus();
        showCustomToast(
          context: context,
          message: "Cannot Logout your account.",
          backgroundColor: AppColors.warning,
          foregroundColor: AppColors.white,
          primaryColor: AppColors.white,
        );
      });
    }

    final isOnline = context.select<NetworkStatusProvider, bool>(
      (p) => p.isOnline,
    );

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: SettingLandingHead(tabIndex: _tabController.index),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Column(
              children: [
                SettingGroupHead(
                  title: 'ACCOUNT',
                  children: [
                    SettingItem(
                      icon: Uil.user,
                      title: 'Profile Data',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileDataPage()),
                        );
                      },
                    ),
                    SettingItem(
                      icon: Ri.logout_circle_r_line,
                      title: 'Sign Out',
                      color: AppColors.red,
                      isLast: true,
                      onTap: () => logout(context),
                    ),
                  ],
                ),

                SettingGroupHead(
                  title: 'SETTINGS',
                  children: [
                    SettingItem(
                      icon: Octicon.pencil_24,
                      title: 'Account Details',
                      onTap: () {
                        if (!isOnline) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showCustomToast(
                              context: context,
                              message: 'No Connection Available!',
                              backgroundColor: AppColors.warning,
                              foregroundColor: AppColors.white,
                              primaryColor: AppColors.white,
                            );
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AccountDetailsPage(),
                            ),
                          );
                        }
                      },
                    ),
                    SettingItem(
                      icon: Carbon.password,
                      title: 'Change Password',
                      onTap: () {
                        if (!isOnline) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showCustomToast(
                              context: context,
                              message: 'No Connection Available!',
                              backgroundColor: AppColors.warning,
                              foregroundColor: AppColors.white,
                              primaryColor: AppColors.white,
                            );
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangePasswordInProfilePage(),
                            ),
                          );
                        }
                      },
                    ),
                    SettingItem(
                      icon: Bi.info_circle,
                      title: 'Version Information',
                      isLast: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => VersionPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
