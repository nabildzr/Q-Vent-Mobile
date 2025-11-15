import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/academicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_event_management/core/theme/app_colors.dart';
import 'package:qr_event_management/widgets/general_back_button.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({super.key});

  @override
  State<VersionPage> createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  String? version;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: AppBar(
        title: Text(
          'Version Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GeneralBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://i.pinimg.com/1200x/68/02/c6/6802c678e1967147cbc43c42b9a620d3.jpg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Q-Vent',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999999999999999),

                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(color: AppColors.grey1),
                      child: Center(child: Text('Q', style: TextStyle(fontSize: 40))),
                    ),
                  ),
                  Gap(15),
                  Text(
                    'Versi ${version ?? "-"}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
