enum PsyType { psy0, psy1 }

enum ExerciseCategory {
	numerique,
	attention,
	spatiale,
	verbale,
	psychomoteur,
	anglais,
	intellectuelle,
	connaissancesAeronautiques,
	memorisation,
}

extension ExerciseCategoryLabel on ExerciseCategory {
	String get label {
		switch (this) {
		case ExerciseCategory.numerique:
			return "Numerique";
		case ExerciseCategory.attention:
			return "Attention";
		case ExerciseCategory.spatiale:
			return "Spatiale";
		case ExerciseCategory.verbale:
			return "Verbale";
		case ExerciseCategory.psychomoteur:
			return "Psychomoteur";
		case ExerciseCategory.anglais:
			return "Anglais";
		case ExerciseCategory.intellectuelle:
			return "Intellectuelle";
		case ExerciseCategory.connaissancesAeronautiques:
			return "Connaissances aeronautiques";
		case ExerciseCategory.memorisation:
			return "Memorisation";
		}
	}
}

const Map<PsyType, List<ExerciseCategory>> psyCategoryLayout = {
	PsyType.psy0: [
		ExerciseCategory.numerique,
		ExerciseCategory.attention,
		ExerciseCategory.spatiale,
		ExerciseCategory.verbale,
		ExerciseCategory.psychomoteur,
		ExerciseCategory.anglais,
		ExerciseCategory.intellectuelle,
		ExerciseCategory.connaissancesAeronautiques,
		ExerciseCategory.memorisation,
	],
	PsyType.psy1: [
		ExerciseCategory.numerique,
		ExerciseCategory.intellectuelle,
		ExerciseCategory.attention,
		ExerciseCategory.psychomoteur,
		ExerciseCategory.spatiale,
		ExerciseCategory.verbale,
		ExerciseCategory.memorisation,
	],
};
