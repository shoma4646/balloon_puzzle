import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_puzzle/features/game/domain/entities/balloon_type.dart';

void main() {
  group('BalloonType.random()', () {
    test('レベル1から5の風船タイプを返すこと', () {
      final results = <BalloonType>{};
      // 十分な回数実行して全てのレベルが出現することを確認
      for (var i = 0; i < 100; i++) {
        results.add(BalloonType.random());
      }

      // Lv.1-5のいずれかが含まれることを確認
      expect(results.every((b) => b.level >= 1 && b.level <= 5), isTrue);

      // 統計的に複数の異なるレベルが出現することを確認(真のランダム性の検証)
      expect(results.length, greaterThan(1));
    });

    test('レベル6-8を返さないこと', () {
      for (var i = 0; i < 50; i++) {
        final balloon = BalloonType.random();
        expect(balloon.level, lessThanOrEqualTo(5));
      }
    });

    test('連続して呼び出しても異なる値を返すこと', () {
      final results = <BalloonType>[];
      for (var i = 0; i < 20; i++) {
        results.add(BalloonType.random());
      }

      // 20回の呼び出しで少なくとも2つの異なる値が出現することを確認
      final uniqueResults = results.toSet();
      expect(uniqueResults.length, greaterThan(1));
    });
  });
}
