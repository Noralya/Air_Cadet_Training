import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "pair_ou_impair_screen.dart";

class PairOuImpairExercise implements Exercise {
	const PairOuImpairExercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy0_numerique_pair_ou_impair",
			name: "Pair ou impair",
			shortDescription:
				"Cliquez alternativement sur des nombres pairs et impairs, dans l'ordre croissant.",
			psyType: PsyType.psy0,
			category: ExerciseCategory.numerique,
			timerMode: TimerMode.global,
			timerDuration: Duration(minutes: 2),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return PairOuImpairScreen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}
