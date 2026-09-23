import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "memory_back_colors_screen.dart";

class MemoryBackColorsExercise implements Exercise {
	const MemoryBackColorsExercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy0_memorisation_memory_back_colors",
			name: "Memory Back Colors",
			shortDescription:
				"Retenez la couleur affichee deux etapes plus tôt et indiquez si elle correspond.",
			psyType: PsyType.psy0,
			category: ExerciseCategory.memorisation,
			timerMode: TimerMode.perQuestion,
			timerDuration: Duration(milliseconds: 4000),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return MemoryBackColorsScreen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}
