import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "angles_screen.dart";

class AnglesExercise implements Exercise {
	const AnglesExercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy1_spatiale_angles",
			name: "Angles",
			shortDescription:
				"Retrouvez l'angle entre l'origine et l'arrivée selon le sens direct de rotation.",
			psyType: PsyType.psy1,
			category: ExerciseCategory.spatiale,
			timerMode: TimerMode.perQuestion,
			timerDuration: Duration(seconds: 12),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return AnglesScreen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}
