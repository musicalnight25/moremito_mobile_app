class FlyerInteraction {
  final String? interactionType;
  final String? interactionValue;
  final String? timestamp;

  FlyerInteraction({
    this.interactionType,
    this.interactionValue,
    this.timestamp,
  });

  factory FlyerInteraction.fromJson(Map<String, dynamic> json) {
    return FlyerInteraction(
      interactionType: json['InteractionType'],
      interactionValue: json['InteractionValue'],
      timestamp: json['Timestamp'],
    );
  }
}
