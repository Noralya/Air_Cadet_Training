import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "mental_math_3_screen.dart";

class MentalMath3Exercise implements Exercise {
	const MentalMath3Exercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy1_numerique_calcul_mental_3",
			name: "Calcul mental 3",
			shortDescription:
				"Resolvez une chaine d'equations et entrez la valeur du dernier parametre.",
			psyType: PsyType.psy1,
			category: ExerciseCategory.numerique,
			timerMode: TimerMode.global,
			timerDuration: Duration(minutes: 15),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return MentalMath3Screen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}
