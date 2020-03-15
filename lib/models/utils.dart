List<String> toLines(String text) {
  return text
      .split('\n')
      .map((line) => line.replaceAll('\t', '').trim())
      .toList();
}
