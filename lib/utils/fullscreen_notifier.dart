import 'package:flutter/foundation.dart';

class FullscreenNotifier extends ValueNotifier<bool> {
  static final FullscreenNotifier instance = FullscreenNotifier._();
  FullscreenNotifier._() : super(false);
}