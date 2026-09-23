import "package:air_cadet_training/core/engine/exercise_registry.dart";
import "package:air_cadet_training/exercises/exercises_bootstrap.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
	test("registers the three initial exercises", () {
		registerAllExercises();
		expect(ExerciseRegistry.instance.all.length, 3);
	});
}
