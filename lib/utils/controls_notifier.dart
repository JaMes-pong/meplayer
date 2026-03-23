import 'package:flutter/foundation.dart';

class ControlsNotifier extends ValueNotifier<bool> {
  static final ControlsNotifier instance = ControlsNotifier._();
  ControlsNotifier._() : super(true);
}