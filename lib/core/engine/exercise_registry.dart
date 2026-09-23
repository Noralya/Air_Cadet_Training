import "exercise.dart";
import "psy_category.dart";

class ExerciseRegistry {
	ExerciseRegistry._();

	static final ExerciseRegistry instance = ExerciseRegistry._();

	final List<Exercise> _exercises = [];

	void register(Exercise exercise) {
		_exercises.add(exercise);
	}

	List<Exercise> get all => List.unmodifiable(_exercises);

	List<Exercise> byPsyType(PsyType type) =>
		_exercises.where((e) => e.meta.psyType == type).toList();

	List<Exercise> byCategory(PsyType type, ExerciseCategory category) =>
		_exercises
			.where((e) => e.meta.psyType == type && e.meta.category == category)
			.toList();

	Exercise? byId(String id) {
		for (final e in _exercises) {
			if (e.meta.id == id) return e;
		}
		return null;
	}

	bool categoryHasExercises(PsyType type, ExerciseCategory category) =>
		byCategory(type, category).isNotEmpty;
}
