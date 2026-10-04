import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "mental_math_2_screen.dart";

class MentalMath2Exercise implements Exercise {
	const MentalMath2Exercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy1_numerique_calcul_mental_2",
			name: "Calcul mental 2",
			shortDescription:
				"Calculez le résultat puis trouvez le plus petit intervalle qui le contient.",
			psyType: PsyType.psy1,
			category: ExerciseCategory.numerique,
			timerMode: TimerMode.global,
			timerDuration: Duration(minutes: 6),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return MentalMath2Screen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}
