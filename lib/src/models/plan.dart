enum TetaPlan {
  free,
  pro,
  ultra,
}

class TetaPlanResponse {
  const TetaPlanResponse({
    required this.isPremium,
    required this.plan,
    this.downgradedStillActive,
  });

  static TetaPlanResponse fromJson(final Map<String, dynamic> json) {
    final isPremium = json['isPremium'] as bool? ?? false;
    final plan = (json['premiumPlan'] as int?) == 1 ||
            (json['premiumPlan'] as int?) == 99
        ? TetaPlan.pro
        : (json['premiumPlan'] as int?) == 2 ||
                (json['premiumPlan'] as int?) == 199
            ? TetaPlan.ultra
            : TetaPlan.free;
    final downgradedStillActive = !isPremium && plan != TetaPlan.free;
    return TetaPlanResponse(
      isPremium: isPremium,
      plan: plan,
      downgradedStillActive: downgradedStillActive,
    );
  }

  final bool isPremium;
  final TetaPlan plan;
  final bool? downgradedStillActive;
}
