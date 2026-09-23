import "package:flutter/widgets.dart";

import "attempt.dart";
import "psy_category.dart";
import "timer/exercise_timer.dart";

enum SessionMode { training, simulation }

typedef AttemptCallback = void Function(Attempt attempt);
typedef ExerciseCycleCompleteCallback = void Function();

class ExerciseMeta {
	const ExerciseMeta({
		required this.id,
		required this.name,
		required this.shortDescription,
		required this.psyType,
		required this.category,
		required this.timerMode,
		this.timerDuration,
	});

	final String id;
	final String name;
	final String shortDescription;
	final PsyType psyType;
	final ExerciseCategory category;
	final TimerMode timerMode;
	final Duration? timerDuration;
}

abstract class Exercise {
	ExerciseMeta get meta;

	Widget buildRunner({
		required BuildContext context,
		required SessionMode mode,
		required AttemptCallback onAttempt,
		required ExerciseCycleCompleteCallback onCycleComplete,
	});
}
