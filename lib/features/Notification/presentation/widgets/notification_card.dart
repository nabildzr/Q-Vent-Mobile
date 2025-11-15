import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../core/theme/app_colors.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),

      //  right side
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          Gap(10),

          SlidableAction(
            flex: 1,
            onPressed: (context) {},
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(20),
            icon: Icons.archive,
            label: 'Archive',
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(color: AppColors.secondary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primaryLight,
                ),
                child: Iconify(
                  MaterialSymbols.assignment_add_rounded,
                  color: AppColors.primary,
                ),
              ),

              Gap(10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "You're assigned to ",
                        style: TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                            text: "Example Event",
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
