import 'package:more/collection.dart';

extension StringExtensions on String {
  String removeHtml() => replaceAll(RegExp(r'<.*?>'), '');

  String toMarkdown() {
    final mappings = <({String regexp, String Function(List<String>) replace})>[
      // Block elements.
      for (var i = 1; i <= 6; i++)
        (
          regexp: '<h$i.*?>[- ]*(.*?)[- ]*</h$i>',
          replace: (v) => '\n${'#' * i} ${v[1].trim()}\n',
        ),
      (regexp: r'<p>(.*?)</p>', replace: (v) => '\n${v[1]}\n'),
      (regexp: r'\s*<li>(.*?)</li>', replace: (v) => '\n- ${v[1]}\n'),
      (regexp: r'<ul>(.*?)</ul>', replace: (v) => v[1]),
      (regexp: r'<ol>(.*?)</ol>', replace: (v) => v[1]),
      (
        regexp: r'<pre><code>(.*?)</code></pre>',
        replace: (v) => '```\n${v[1].removeHtml().trim()}\n```\n',
      ),
      // Inline elements.
      (regexp: r'<code>(.*?)</code>', replace: (v) => '`${v[1].removeHtml()}`'),
      (regexp: r'<em>(.*?)</em>', replace: (v) => '*${v[1]}*'),
      (regexp: r'<em class="star">(.*?)</em>', replace: (v) => '**${v[1]}**'),
      (regexp: r'<span .*?>(.*?)</span>', replace: (v) => v[1]),
      (
        regexp: r'<a .*?href="(.*?)".*?>(.*?)</a>',
        replace: (v) => '[${v[2]}](${v[1]})',
      ),
      // Cleanup.
      (regexp: r'(\n\n-)', replace: (v) => '\n-'),
      (regexp: r'(\n\n\n+)', replace: (v) => '\n\n'),
      (regexp: r'&gt;', replace: (v) => '>'),
      (regexp: r'&lt;', replace: (v) => '<'),
      (regexp: r'&amp;', replace: (v) => '&'),
    ];
    var result = this;
    for (final mapping in mappings) {
      result = result.replaceAllMapped(
        RegExp(mapping.regexp, dotAll: true),
        (match) => mapping.replace(
          0.to(match.groupCount + 1).map((i) => match.group(i) ?? '').toList(),
        ),
      );
    }
    return result.trim();
  }
}
