import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/provider/network_status_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/loading/wave_loading.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../Authentication/presentation/widgets/back_button.dart';
import '../provider/search_event_provider.dart';
import '../widgets/search_event_card.dart';

class LandingSearchEventsPage extends StatefulWidget {
  const LandingSearchEventsPage({super.key});

  @override
  State<LandingSearchEventsPage> createState() =>
      _LandingSearchEventsPageState();
}

class _LandingSearchEventsPageState extends State<LandingSearchEventsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthenticationProvider>();

    final searchProvider = context.read<SearchEventsProvider>();
    searchProvider.searchEvents(
      '',

      token: user.authorization!.token,
      userId: user.userProfile!.id,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.select<NetworkStatusProvider, bool>(
      (p) => p.isOnline,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: AppBar(
        title: Text(
          'Search Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundPage,
        scrolledUnderElevation: 0,
        leading: AuthenticationCustomBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer2<SearchEventsProvider, AuthenticationProvider>(
        builder: (context, searchProvider, authProvider, child) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.blue,
                    onChanged: (value) {
                      searchProvider.searchEvents(
                        value,
                        token: authProvider.authorization!.token,
                        userId: authProvider.userProfile!.id,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Search events',
                      prefixIcon: Icon(Icons.search),
                      fillColor: Color(0xFFF5F5F5),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF5F5F5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),

                  Gap(10),

                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (searchProvider.searchStatus ==
                            ResponseStatus.loading) {
                          return WaveLoading();
                        } else if (!isOnline) {
                          return WaveLoading();
                        } else if (searchProvider.searchStatus ==
                            ResponseStatus.error) {
                          return Center(
                            child: Text(searchProvider.cleanErrorMessage),
                          );
                        } else if (searchProvider.searchResults == null ||
                            searchProvider.searchResults!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(9999),
                                  child: Container(
                                    padding: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                    ),
                                    child: Iconify(
                                      Bi.calendar2_date_fill,
                                      size: 50,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Gap(25),
                                Text(
                                  'No event found matching\nyour search',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(100),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: searchProvider.searchResults!.length,
                            itemBuilder: (context, index) {
                              final event =
                                  searchProvider.searchResults![index];

                              return SearchEventCard(event: event);
                            },
                          );
                        }
                      },
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
