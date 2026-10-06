import 'package:flutter_test/flutter_test.dart';
import 'package:kikorbo/core/theme/app_themes.dart';

void main() {
  test('All 6 AppThemes are defined with valid properties', () {
    expect(AppThemes.allThemes.length, 6);

    final ids = AppThemes.allThemes.map((t) => t.id).toList();
    expect(ids, contains('minimal'));
    expect(ids, contains('midnight'));
    expect(ids, contains('sakura'));
    expect(ids, contains('forest'));
    expect(ids, contains('arcade'));
    expect(ids, contains('cosmos'));

    for (final theme in AppThemes.allThemes) {
      expect(theme.name.isNotEmpty, isTrue);
      expect(theme.cardRadius, greaterThan(0));
      expect(theme.buttonRadius, greaterThan(0));
    }
  });
}
