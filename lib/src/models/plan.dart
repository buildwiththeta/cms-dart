enum TetaPlan {
  free,
  individual,
  startup,
}

class TetaPlanResponse {
  const TetaPlanResponse({
    required this.isPremium,
    required this.plan,
    this.downgradedStillActive,
  });

  TetaPlanResponse fromJson(final Map<String, dynamic> json) {
    final _isPremium = json['isPremium'] as bool? ?? false,
        plan = (json['premiumPlan'] as int?) == 1 ||
            (json['premiumPlan'] as int?) == 99;
    final _plan = (json['premiumPlan'] as int?) == 1 ||
            (json['premiumPlan'] as int?) == 99
        ? TetaPlan.individual
        : (json['premiumPlan'] as int?) == 2 ||
                (json['premiumPlan'] as int?) == 199
            ? TetaPlan.startup
            : TetaPlan.free;
    final _downgradedStillActive = !isPremium && plan != TetaPlan.free;
    return TetaPlanResponse(
      isPremium: _isPremium,
      plan: _plan,
      downgradedStillActive: _downgradedStillActive,
    );
  }

  final bool isPremium;
  final TetaPlan plan;
  final bool? downgradedStillActive;
}
