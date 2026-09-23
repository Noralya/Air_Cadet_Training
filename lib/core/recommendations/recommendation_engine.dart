import "../engine/exercise.dart";
import "../engine/exercise_registry.dart";
import "../engine/psy_category.dart";
import "../statistics/statistics_engine.dart";
import "../statistics/statistics_models.dart";

class WeaknessEntry {
	const WeaknessEntry({required this.category, required this.successRate});

	final ExerciseCategory category;
	final double successRate;
}

class RecommendationEngine {
	const RecommendationEngine(this.statisticsEngine, this.registry);

	final StatisticsEngine statisticsEngine;
	final ExerciseRegistry registry;

	List<WeaknessEntry> weakCategories({int limit = 3}) {
		final entries = <WeaknessEntry>[];
		for (final category in ExerciseCategory.values) {
		final stats = statisticsEngine.computeCategory(category.name);
		if (stats.totalQuestions == 0) continue;
		entries.add(WeaknessEntry(
			category: category,
			successRate: stats.recentSuccessRate,
		));
		}
		entries.sort((a, b) => a.successRate.compareTo(b.successRate));
		return entries.take(limit).toList();
	}

	List<WeaknessEntry> strongCategories({int limit = 3}) {
		final entries = <WeaknessEntry>[];
		for (final category in ExerciseCategory.values) {
		final stats = statisticsEngine.computeCategory(category.name);
		if (stats.totalQuestions == 0) continue;
		entries.add(WeaknessEntry(
			category: category,
			successRate: stats.recentSuccessRate,
		));
		}
		entries.sort((a, b) => b.successRate.compareTo(a.successRate));
		return entries.take(limit).toList();
	}

	List<Exercise> buildPersonalizedSelection({int maxExercises = 4}) {
		final all = registry.all;
		if (all.isEmpty) return [];

		final scored = <MapEntry<Exercise, double>>[];
		for (final exercise in all) {
		final ExerciseStatistics stats =
			statisticsEngine.computeExercise(exercise.meta.id);
		final categoryStats =
			statisticsEngine.computeCategory(exercise.meta.category.name);

		double weaknessScore;
		if (stats.attemptCount == 0) {
			weaknessScore = 0.15;
		} else if (categoryStats.totalQuestions < 10) {
			weaknessScore = 0.3;
		} else {
			weaknessScore = categoryStats.recentSuccessRate;
		}
		scored.add(MapEntry(exercise, weaknessScore));
		}

		scored.sort((a, b) => a.value.compareTo(b.value));
		final selected = scored.take(maxExercises).map((e) => e.key).toList();
		return selected.isEmpty ? all.take(maxExercises).toList() : selected;
	}
}
