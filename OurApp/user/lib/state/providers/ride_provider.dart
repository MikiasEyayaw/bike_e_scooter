import 'package:flutter/foundation.dart';

class RideProvider with ChangeNotifier {
  bool isRiding = false;

  void startRide() {
    isRiding = true;
    notifyListeners();
  }

  void endRide() {
    isRiding = false;
    notifyListeners();
  }
}
