import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../core/theme/app_colors.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    this.onRefresh,
  });

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!(); 
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropMaterialHeader(
        backgroundColor: AppColors.primary,
        color: Colors.white,
      ),
      footer: ClassicFooter(
        loadingText: "Sedang memuat...",
        idleText: "Tarik untuk memuat lebih banyak",
        canLoadingText: "Lepaskan untuk memuat lebih banyak",
        failedText: "Gagal memuat!",
        noDataText: "Tidak ada data lagi",
        textStyle: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: widget.child,
    );
  }
}
