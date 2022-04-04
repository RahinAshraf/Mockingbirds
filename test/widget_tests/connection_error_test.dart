import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/widgets/connection_error_widget.dart';

void main() {
  final connectionError = ConnectionError();
  group("Widget displays a connection error", () {
    testWidgets("Display connection error image", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: connectionError));
      final Image bubbleImageWidget = Image.asset(
        'assets/images/right_bubbles_shapes.png',
        package: 'test_package',
      );
      assert(bubbleImageWidget.image is AssetImage);
      final AssetImage assetBubbleImage = bubbleImageWidget.image as AssetImage;

      final Image errorImageWidget = Image.asset(
        'assets/images/no_connection.png',
        package: 'test_package',
      );
      assert(errorImageWidget.image is AssetImage);
      final AssetImage assetErrorImage = errorImageWidget.image as AssetImage;

      expect(assetBubbleImage.keyName,
          'packages/test_package/assets/images/right_bubbles_shapes.png');
      expect(assetErrorImage.keyName,
          'packages/test_package/assets/images/no_connection.png');
    });

    testWidgets("Display connection error text", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: connectionError));
      expect(
          find.text(
              "No Internet Connection Found!  \n \n Please check your internet connection."),
          findsOneWidget);
      expect(find.text("Ooops!"), findsOneWidget);
    });

    testWidgets("Display circular spanner", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: connectionError));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
