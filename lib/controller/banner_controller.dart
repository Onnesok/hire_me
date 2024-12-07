import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hire_me/model/banner_model.dart' as custom_model;


class BannerController with ChangeNotifier {
  late final AnimationController animationController;
  late final ScrollController scrollController;
  late final Timer timer;
  final double itemWidth = 380;

  List<custom_model.Banner> banners = custom_model.Banner.BannerList;

  void initController(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    )..forward();

    scrollController = ScrollController();

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (scrollController.hasClients) {
        double maxScrollExtent = scrollController.position.maxScrollExtent;
        double currentScrollPosition = scrollController.position.pixels;
        double newPosition = currentScrollPosition + itemWidth - 100;

        if (newPosition > maxScrollExtent) {
          newPosition = 0;
        }

        scrollController.animateTo(
          newPosition,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });

    notifyListeners();
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    timer.cancel();
    super.dispose();
  }
}
