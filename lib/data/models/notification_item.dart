class NotificationItem {
  final String title;
  final String expiryDate;
  final String type;
  final bool hasBlueHighlight;
  final String detail; // Added field for detailed reason

  NotificationItem({
    required this.title,
    required this.expiryDate,
    required this.type,
    required this.detail,

    this.hasBlueHighlight = false,
  });
}
