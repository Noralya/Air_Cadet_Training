import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "mental_math_1_screen.dart";

class MentalMath1Exercise implements Exercise {
	const MentalMath1Exercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy1_numerique_calcul_mental_1",
			name: "Calcul mental 1",
			shortDescription:
				"Calculez le resultat d'une suite d'additions et de soustractions.",
			psyType: PsyType.psy1,
			category: ExerciseCategory.numerique,
			timerMode: TimerMode.global,
			timerDuration: Duration(minutes: 3, seconds: 30),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return MentalMath1Screen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}
