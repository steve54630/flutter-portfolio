import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextSpan parseMarkdown(String text, BuildContext context) {
  final List<TextSpan> spans = [];
  // Regex pour isoler ce qui est entre **
  final RegExp regExp = RegExp(r'\*\*(.*?)\*\*');
  int lastIndex = 0;

  for (final Match match in regExp.allMatches(text)) {
    // Texte avant le gras
    if (match.start > lastIndex) {
      spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
    }
    // Texte en gras
    spans.add(
      TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    lastIndex = match.end;
  }

  // Reste du texte
  if (lastIndex < text.length) {
    spans.add(TextSpan(text: text.substring(lastIndex)));
  }

  return TextSpan(children: spans, style: GoogleFonts.poppins(height: 1.5));
}
