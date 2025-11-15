import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/general_back_button.dart';

class EventDashboardAttendeesCheckedInPage extends StatefulWidget {
  const EventDashboardAttendeesCheckedInPage({super.key});

  @override
  State<EventDashboardAttendeesCheckedInPage> createState() =>
      _EventDashboardAttendeesCheckedInPageState();
}

class _EventDashboardAttendeesCheckedInPageState
    extends State<EventDashboardAttendeesCheckedInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: GeneralBackButton(
          iconColor: AppColors.secondary,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.eventDashboard,
        title: Text(
          'Attendees Checked-In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
      ),
    );
  }
}
