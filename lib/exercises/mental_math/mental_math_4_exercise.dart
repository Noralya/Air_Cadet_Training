import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "mental_math_4_screen.dart";

class MentalMath4Exercise implements Exercise {
	const MentalMath4Exercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy1_numerique_calcul_mental_4",
			name: "Calcul mental 4",
			shortDescription:
				"Calculez le resultat et selectionnez tous les intervalles qui le contiennent.",
			psyType: PsyType.psy1,
			category: ExerciseCategory.numerique,
			timerMode: TimerMode.global,
			timerDuration: Duration(minutes: 4),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return MentalMath4Screen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}
