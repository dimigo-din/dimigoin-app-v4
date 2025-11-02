import 'package:html_unescape/html_unescape.dart';

class TextCleaner {
  static final _unescape = HtmlUnescape();

  /// HTML 엔티티를 디코딩하고 괄호 안의 텍스트를 제거합니다.
  ///
  /// - HTML 엔티티 (&amp;, &lt; 등)를 변환
  /// - (), [], {} 안의 모든 내용 제거
  /// - 연속된 공백을 하나로 합침
  static String cleanText(String text) {
    String cleaned = _unescape.convert(text);

    // 괄호 안의 내용 제거
    cleaned = cleaned.replaceAll(RegExp(r'\([^\)]*\)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\[[^\]]*\]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\{[^\}]*\}'), '');

    // 연속된 공백을 하나로 합치고 trim
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleaned;
  }
}
