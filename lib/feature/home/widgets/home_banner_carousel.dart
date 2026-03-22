import 'dart:async';
import 'package:flutter/material.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  final _controller = PageController(viewportFraction: 1);
  int _index = 0;
  Timer? _timer;
  final int total = 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        int nextIndex = (_index + 1) % total;
        _controller.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 343 / 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: total,
            onPageChanged: (index) {
              setState(() {
                _index = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                'assets/images/banner/Frame2087327902.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            total,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6, // Slimmer indicators
              width: i == _index ? 24 : 6,
              decoration: BoxDecoration(
                color: i == _index
                    ? const Color(0xFF15B34A)
                    : const Color(0xFFD0D0D0), // More subtle grey
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
