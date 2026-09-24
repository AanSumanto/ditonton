import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('constants and text themes should be properly defined',
      (WidgetTester tester) async {
    expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    expect(kRichBlack, const Color(0xFF000814));
    expect(kOxfordBlue, const Color(0xFF001D3D));
    expect(kPrussianBlue, const Color(0xFF003566));
    expect(kMikadoYellow, const Color(0xFFffc300));
    expect(kDavysGrey, const Color(0xFF4B5358));
    expect(kGrey, const Color(0xFF303030));

    expect(kHeading5.fontSize, 23);
    expect(kHeading6.fontSize, 19);
    expect(kSubtitle.fontSize, 15);
    expect(kBodyText.fontSize, 13);

    expect(kTextTheme.headlineMedium, kHeading5);
    expect(kTextTheme.headlineSmall, kHeading6);
    expect(kTextTheme.labelMedium, kSubtitle);
    expect(kTextTheme.bodyMedium, kBodyText);

    expect(kDrawerTheme.backgroundColor, Colors.grey.shade700);
    expect(kColorScheme.primary, kMikadoYellow);
  });
}
