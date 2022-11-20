String stripMargin(String s) {
  return s.splitMapJoin(
    RegExp(r'^', multiLine: true),
    onMatch: (_) => '\n',
    onNonMatch: (n) => n.trim(),
  );
}
