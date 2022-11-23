import 'package:fractal_gold/models/app.dart';

import '../models/slide.dart';

extension Slides4AppFractal on AppFractal {
  List<SlideFractal> get slides => [
        ...(repo['slides'] ?? []).map(
          (m) => SlideFractal.fromMap(m),
        )
      ];
}
