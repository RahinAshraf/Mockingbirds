import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:veloplan/styles/colors.dart';

/// Creates a custom carousel that must be populated with a list of cards on instantiation.
/// Author: Tayyibah
class CustomCarousel extends StatefulWidget {
  final List<Widget> cards;

  const CustomCarousel({Key? key, required this.cards}) : super(key: key);

  @override
  CustomCarouselState createState() => CustomCarouselState();
}

class CustomCarouselState extends State<CustomCarousel>
    with TickerProviderStateMixin {
  late List<Widget> cards;
  late PageController _pageController;
  late TabController _tabController;
  int _position = 0;

  @override
  void initState() {
    super.initState();
    cards = widget.cards;
    _pageController = PageController(initialPage: 0, viewportFraction: .9);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: PageView.builder(
              controller: _pageController,
              itemCount: cards.length,
              pageSnapping: true,
              onPageChanged: (int position) {
                setState(() {
                  _position = position;
                  _tabController.index = 1;
                });
              },
              itemBuilder: (BuildContext context, int position) {
                return imageSlider(position);
              }),
        ),
        buildIndicator()
      ],
    );
  }

  Widget imageSlider(int position) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Center(child: widget);
      },
      child: Container(child: cards[position]),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: _position,
        count: cards.length,
        effect: ScrollingDotsEffect(
          fixedCenter: true,
          activeDotColor: CustomColors.green,
          dotHeight: 8,
          dotWidth: 8,
        ),
      );
}
