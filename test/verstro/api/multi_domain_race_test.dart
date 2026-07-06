// MultiDomainRace.isHealthyBillingResponse 纯逻辑测试。
//
// 关键: CF Access 挑战页返回 HTTP 200 + HTML body (见后端订阅服务
// 记录的 P0)。竞速若只判 status==200 会把 Access 登录页当健康后端。必须校验 JSON body ok==true。
import 'package:fl_clash/verstro/api/multi_domain_race.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isHealthyBillingResponse', () {
    test('200 + {ok:true} (dio 已解码为 Map) → true', () {
      expect(isHealthyBillingResponse(200, {'ok': true, 'service': 'billing'}), isTrue);
    });
    test('200 + JSON 字符串 (dio 未解码) → true', () {
      expect(isHealthyBillingResponse(200, '{"ok":true,"service":"billing"}'), isTrue);
    });
    test('200 + Access 登录页 HTML → false (核心防线)', () {
      expect(isHealthyBillingResponse(200, '<!DOCTYPE html><html>Sign in</html>'), isFalse);
    });
    test('200 + {ok:false} → false', () {
      expect(isHealthyBillingResponse(200, {'ok': false}), isFalse);
    });
    test('200 + 无 ok 字段 → false', () {
      expect(isHealthyBillingResponse(200, {'error': 'x'}), isFalse);
    });
    test('非 200 即便 ok:true → false', () {
      expect(isHealthyBillingResponse(503, {'ok': true}), isFalse);
    });
    test('null status / null body → false', () {
      expect(isHealthyBillingResponse(null, {'ok': true}), isFalse);
      expect(isHealthyBillingResponse(200, null), isFalse);
    });
  });
}
