import 'package:frac/frac.dart';
import 'package:fractals/mixins/named.dart';
import 'package:fractals/models/fractal.dart';

class SlideFractal extends Fractal with NamedFract {
  final description = Frac<String>('');
  String text = '';
  String backgroundUrl = '';

  SlideFractal.fromMap(Map m) : super(m) {
    namedFromMap(m);
    description.value = m['description'];
    text = m['text'] ?? '';
    backgroundUrl = m['background'] ?? '';
  }
}
