import 'package:flutter/material.dart';

/// Creates a custom carousel that must be populated with a list of cards on instantiation

class CustomCarousel extends StatefulWidget {
  final List<Widget> cards;

  const CustomCarousel({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  CustomCarouselState createState() => CustomCarouselState();
}

class CustomCarouselState extends State<CustomCarousel> {
  List<Widget> cards = [];

  @override
  void initState() {
    super.initState();
    cards = widget.cards;
    _pageController = PageController(initialPage: 0, viewportFraction: .5);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: PageView.builder(
              controller: _pageController,
              itemCount: cards.length,
              onPageChanged: (int position) {
                setState(() {
                  _position = position;
                });
              },
              itemBuilder: (BuildContext context, int position) {
                return imageSlider(position);
              }),
        ),
        Flexible(
            child: AnimatedPageIndicatorFb1(
          currentPage: _position,
          numPages: cards.length,
          gradient: LinearGradient(colors: [
            Colors.blue.withOpacity(.4),
            Colors.purple.withOpacity(.4)
          ]),
          activeGradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        ))
      ],
    );
  }

  Widget imageSlider(int position) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Container(child: Center(child: widget));
      },
      child: Container(child: cards[position]),
    );
  }

  late PageController _pageController;
  int _position = 0;
}

class AnimatedPageIndicatorFb1 extends StatelessWidget {
  const AnimatedPageIndicatorFb1(
      {Key? key,
      required this.currentPage,
      required this.numPages,
      this.dotHeight = 10,
      this.activeDotHeight = 10,
      this.dotWidth = 10,
      this.activeDotWidth = 20,
      this.gradient =
          const LinearGradient(colors: [Color(0xff4338CA), Color(0xff6D28D9)]),
      this.activeGradient =
          const LinearGradient(colors: [Color(0xff4338CA), Color(0xff6D28D9)])})
      : super(key: key);

  final int
      currentPage; //the index of the active dot, i.e. the index of the page you're on
  final int
      numPages; //the total number of dots, i.e. the number of pages your displaying

  final double dotWidth; //the width of all non-active dots
  final double activeDotWidth; //the width of the active dot
  final double activeDotHeight; //the height of the active dot
  final double dotHeight; //the height of all dots
  final Gradient gradient; //the gradient of all non-active dots
  final Gradient activeGradient; //the gradient of the active dot

  double _calcRowSize() {
    //Calculates the size of the outer row that creates spacing that is equivalent to the width of a dot
    final int widthFactor = 2; //assuming spacing is equal to the width of a dot
    return (dotWidth * numPages * widthFactor) + activeDotWidth - dotWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _calcRowSize(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          numPages,
          (index) => AnimatedPageIndicatorDot(
            isActive: currentPage == index,
            gradient: gradient,
            activeGradient: activeGradient,
            activeWidth: activeDotWidth,
            activeHeight: activeDotHeight,
          ),
        ),
      ),
    );
  }
}

class AnimatedPageIndicatorDot extends StatelessWidget {
  const AnimatedPageIndicatorDot(
      {Key? key,
      required this.isActive,
      this.height = 10,
      this.width = 10,
      this.activeWidth = 20,
      this.activeHeight = 10,
      required this.gradient,
      required this.activeGradient})
      : super(key: key);

  final bool isActive;
  final double height;
  final double width;
  final double activeWidth;
  final double activeHeight;
  final Gradient gradient;
  final Gradient activeGradient;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isActive ? activeWidth : width,
      height: isActive ? activeHeight : height,
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
          gradient: isActive ? activeGradient : gradient,
          borderRadius: BorderRadius.all(Radius.circular(30))),
    );
  }
}
