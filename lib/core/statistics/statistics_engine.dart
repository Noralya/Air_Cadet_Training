import "../engine/attempt.dart";
import "../persistence/session_record.dart";
import "statistics_models.dart";

class StatisticsEngine {
	const StatisticsEngine(this.sessions);

	final List<SessionRecord> sessions;

	List<Attempt> get _allAttempts =>
		sessions.expand((s) => s.attempts).toList();

	GlobalStatistics computeGlobal() {
		final attempts = _allAttempts;
		if (attempts.isEmpty) return GlobalStatistics.empty;

		final totalTime = sessions.fold<Duration>(
			Duration.zero, (sum, s) => sum + s.totalDuration);
		final correct = attempts.where((a) => a.isCorrect).length;
		final totalMs = attempts.fold<int>(
			0, (sum, a) => sum + a.responseTime.inMilliseconds);

		return GlobalStatistics(
			totalQuestions: attempts.length,
			totalSessions: sessions.length,
			totalTrainingTime: totalTime,
			successRate: correct / attempts.length,
			averageResponseTime: Duration(milliseconds: totalMs ~/ attempts.length),
		);
	}

	CategoryStatistics computeCategory(String categoryKey) {
		final attempts =
			_allAttempts.where((a) => a.categoryKey == categoryKey).toList();
		if (attempts.isEmpty) {
		return CategoryStatistics(
			categoryKey: categoryKey,
			successRate: 0,
			averageResponseTime: Duration.zero,
			totalQuestions: 0,
			recentSuccessRate: 0,
		);
		}
		attempts.sort((a, b) => a.timestamp.compareTo(b.timestamp));
		final correct = attempts.where((a) => a.isCorrect).length;
		final totalMs = attempts.fold<int>(
			0, (sum, a) => sum + a.responseTime.inMilliseconds);

		final recent = attempts.length > 20
			? attempts.sublist(attempts.length - 20)
			: attempts;
		final recentCorrect = recent.where((a) => a.isCorrect).length;

		return CategoryStatistics(
			categoryKey: categoryKey,
			successRate: correct / attempts.length,
			averageResponseTime: Duration(milliseconds: totalMs ~/ attempts.length),
			totalQuestions: attempts.length,
			recentSuccessRate: recentCorrect / recent.length,
		);
	}

	ExerciseStatistics computeExercise(String exerciseId) {
		final attempts =
			_allAttempts.where((a) => a.exerciseId == exerciseId).toList();
		if (attempts.isEmpty) {
		return ExerciseStatistics(
			exerciseId: exerciseId,
			successRate: 0,
			averageResponseTime: Duration.zero,
			bestResponseTime: null,
			attemptCount: 0,
		);
		}
		final correct = attempts.where((a) => a.isCorrect).length;
		final totalMs = attempts.fold<int>(
			0, (sum, a) => sum + a.responseTime.inMilliseconds);
		final best = attempts
			.where((a) => a.isCorrect)
			.map((a) => a.responseTime)
			.fold<Duration?>(null, (min, d) => min == null || d < min ? d : min);

		return ExerciseStatistics(
			exerciseId: exerciseId,
			successRate: correct / attempts.length,
			averageResponseTime: Duration(milliseconds: totalMs ~/ attempts.length),
			bestResponseTime: best,
			attemptCount: attempts.length,
		);
	}

	List<String> get knownCategoryKeys =>
		_allAttempts.map((a) => a.categoryKey).toSet().toList();
}
