enum TetaPlan {
  free,
  individual,
  startup,
}

class TetaPlanResponse {
  TetaPlanResponse({
    required this.isPremium,
    required this.plan,
    this.downgradedStillActive,
  });

  TetaPlanResponse.fromJson(final Map<String, dynamic> json)
      : isPremium = json['isPremium'] as bool? ?? false,
        plan = (json['premiumPlan'] as int?) == 1 ||
                (json['premiumPlan'] as int?) == 99
            ? TetaPlan.individual
            : (json['premiumPlan'] as int?) == 2 ||
                    (json['premiumPlan'] as int?) == 199
                ? TetaPlan.startup
                : TetaPlan.free {
    downgradedStillActive = !isPremium && plan != TetaPlan.free;
  }

  final bool isPremium;
  final TetaPlan plan;
  bool? downgradedStillActive;
}
