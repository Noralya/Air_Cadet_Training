import "../core/engine/exercise_registry.dart";
import "angles/angles_exercise.dart";
import "dominos/dominos_exercise.dart";
import "memory_back_colors/memory_back_colors_exercise.dart";
import "pair_ou_impair/pair_ou_impair_exercise.dart";

void registerAllExercises() {
	final registry = ExerciseRegistry.instance;
	registry.register(const PairOuImpairExercise());
	registry.register(const MemoryBackColorsExercise());
	registry.register(const AnglesExercise());
	registry.register(const DominosExercise());
}