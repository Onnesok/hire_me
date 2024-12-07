import 'package:flutter/material.dart';
import 'package:hire_me/model/banner_model.dart' as custom_model;
import 'package:hire_me/controller/banner_controller.dart';

class BannerListView extends StatefulWidget {
  const BannerListView({
    required this.callBack,
    super.key,
  });

  final Function() callBack;

  @override
  State<BannerListView> createState() => _BannerListViewState();
}

class _BannerListViewState extends State<BannerListView> with TickerProviderStateMixin {
  late final BannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BannerController();
    _controller.initController(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        height: 134,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: Future.delayed(const Duration(milliseconds: 50), () => true),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                controller: _controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _controller.banners.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = _controller.banners.length > 10
                      ? 10
                      : _controller.banners.length;
                  final Animation<double> animation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller.animationController,
                      curve: Interval(
                        (1 / count) * index,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  );

                  return BannerView(
                    banner: _controller.banners[index],
                    animation: animation,
                    animationController: _controller.animationController,
                    callback: widget.callBack,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class BannerView extends StatelessWidget {
  const BannerView({
    required this.banner,
    required this.animationController,
    required this.animation,
    required this.callback,
    super.key,
  });

  final VoidCallback callback;
  final custom_model.Banner banner;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              100 * (1.0 - animation.value), 0.0, 0.0,
            ),
            child: GestureDetector(
              onTap: callback,
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(banner.imagePath),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
