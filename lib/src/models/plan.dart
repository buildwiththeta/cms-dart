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
      : isPremium = json['isPremium'] as bool,
        plan = (json['premiumPlan'] as int) == 0
            ? TetaPlan.free
            : (json['premiumPlan'] as int) == 1
                ? TetaPlan.dev
                : TetaPlan.pro;

  final bool isPremium;
  final TetaPlan plan;
}
