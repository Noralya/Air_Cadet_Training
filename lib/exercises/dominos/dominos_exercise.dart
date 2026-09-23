import "package:flutter/widgets.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/engine/timer/exercise_timer.dart";
import "dominos_screen.dart";

class DominosExercise implements Exercise {
	const DominosExercise();

	@override
	ExerciseMeta get meta => const ExerciseMeta(
			id: "psy0_numerique_dominos",
			name: "Dominos",
			shortDescription:
				"Trouvez la logique de la suite ou de la grille et reconstruisez le domino manquant.",
			psyType: PsyType.psy0,
			category: ExerciseCategory.numerique,
			timerMode: TimerMode.perQuestion,
			timerDuration: Duration(seconds: 45),
		);

	@override
	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	}) {
		return DominosScreen(
			meta: meta,
			mode: mode,
			onAttempt: onAttempt,
			onCycleComplete: onCycleComplete,
		);
	}
}