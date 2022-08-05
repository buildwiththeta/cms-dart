enum TetaPlan {
  free,
  dev,
  pro,
}

class TetaPlanResponse {
  TetaPlanResponse({
    required this.isPremium,
    required this.plan,
  });

  TetaPlanResponse.fromJson(final Map<String, dynamic> json)
      : isPremium = json['isPremium'] as bool? ?? false,
        plan = (json['premiumPlan'] as int?) == 1 ||
                (json['premiumPlan'] as int?) == 99
            ? TetaPlan.dev
            : (json['premiumPlan'] as int?) == 2 ||
                    (json['premiumPlan'] as int?) == 199
                ? TetaPlan.pro
                : TetaPlan.free;

  final bool isPremium;
  final TetaPlan plan;
}
