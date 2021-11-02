class DrinkRecord {
  final String image;
  final String time;
  final double defaultAmount;
  final int cupDivisionIndex;

  const DrinkRecord({
    required this.image,
    required this.time,
    required this.defaultAmount,
    this.cupDivisionIndex = 3,
  });

  get dividedCapacity => (defaultAmount * (cupDivisionIndex + 1)) / 4;
}
