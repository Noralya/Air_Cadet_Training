class GlobalStatistics {
	const GlobalStatistics({
		required this.totalQuestions,
		required this.totalSessions,
		required this.totalTrainingTime,
		required this.successRate,
		required this.averageResponseTime,
	});

	final int totalQuestions;
	final int totalSessions;
	final Duration totalTrainingTime;
	final double successRate;
	final Duration averageResponseTime;

	static const empty = GlobalStatistics(
		totalQuestions: 0,
		totalSessions: 0,
		totalTrainingTime: Duration.zero,
		successRate: 0,
		averageResponseTime: Duration.zero,
	);
}

class CategoryStatistics {
	const CategoryStatistics({
		required this.categoryKey,
		required this.successRate,
		required this.averageResponseTime,
		required this.totalQuestions,
		required this.recentSuccessRate,
	});

	final String categoryKey;
	final double successRate;
	final Duration averageResponseTime;
	final int totalQuestions;
	final double recentSuccessRate;
}

class ExerciseStatistics {
	const ExerciseStatistics({
		required this.exerciseId,
		required this.successRate,
		required this.averageResponseTime,
		required this.bestResponseTime,
		required this.attemptCount,
	});

	final String exerciseId;
	final double successRate;
	final Duration averageResponseTime;
	final Duration? bestResponseTime;
	final int attemptCount;
}
