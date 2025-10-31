class FareCalculator {
  static double calculateFare(double distanceKm, double durationMin) {
    return 0.5 * distanceKm + 0.2 * durationMin;
  }
}
