import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../LandingSearchEvents/presentation/pages/landing_search_events_page.dart';

class EventLandingHead extends StatelessWidget {
  final int tabIndex;

  const EventLandingHead({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 27.0,
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Events",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ],
          ),
          Row(
            children: [
              // CustomHeadIconButton(
              //   iconify: Iconify(Ic.round_bookmark_added),
              //   onTap: () {},
              // ),
              Gap(10),
              CustomHeadIconButton(
                iconify: Iconify(MaterialSymbols.search_rounded),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => LandingSearchEventsPage()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomHeadIconButton extends StatelessWidget {
  final Iconify iconify;
  final VoidCallback onTap;

  const CustomHeadIconButton({
    super.key,
    required this.iconify,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(217, 217, 217, 1000),
          ),
          child: iconify,
        ),
      ),
    );
  }
}
