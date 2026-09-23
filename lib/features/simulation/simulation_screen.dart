import "package:flutter/material.dart";

import "../../core/engine/exercise_registry.dart";
import "../../core/engine/psy_category.dart";
import "../../shared/widgets/responsive.dart";
import "simulation_session_screen.dart";

class SimulationScreen extends StatelessWidget {
	const SimulationScreen({super.key, required this.psyLabel});

	final String psyLabel;

	PsyType get _psyType => psyLabel == "PSY0" ? PsyType.psy0 : PsyType.psy1;

	@override
	Widget build(BuildContext context) {
		final exercises = ExerciseRegistry.instance.byPsyType(_psyType);
		final theme = Theme.of(context);

		return Scaffold(
		appBar: AppBar(title: Text("Simulation $psyLabel")),
		body: SafeArea(
			child: Center(
			child: ConstrainedBox(
				constraints: BoxConstraints(
				maxWidth: Responsive.maxContentWidth(context),
				),
				child: Padding(
				padding: EdgeInsets.symmetric(
					horizontal: Responsive.horizontalPadding(context),
					vertical: 20,
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					Text(
						"Regles de la simulation",
						style: theme.textTheme.titleLarge
							?.copyWith(fontWeight: FontWeight.w800),
					),
					const SizedBox(height: 12),
					_rule(context, "Tous les exercices $psyLabel disponibles sont melanges."),
					_rule(context, "Aucune correction n'est affichee pendant la session."),
					_rule(context, "Le chronometrage est impose et global."),
					_rule(context, "Les resultats et la correction apparaissent uniquement a la fin."),
					const Spacer(),
					if (exercises.isEmpty)
						Text(
						"Aucun exercice $psyLabel disponible pour le moment.",
						style: theme.textTheme.bodyMedium,
						)
					else
						SizedBox(
						width: double.infinity,
						child: ElevatedButton(
							onPressed: () => Navigator.of(context).push(
							MaterialPageRoute(
								builder: (_) => SimulationSessionScreen(
								psyType: _psyType,
								exercises: exercises,
								),
							),
							),
							child: const Text("Commencer la simulation"),
						),
						),
					const SizedBox(height: 12),
					],
				),
				),
			),
			),
		),
		);
	}

	Widget _rule(BuildContext context, String text) {
		return Padding(
			padding: const EdgeInsets.only(bottom: 10),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const Padding(
						padding: EdgeInsets.only(top: 4),
						child: Icon(Icons.circle, size: 6),
					),
					const SizedBox(width: 10),
					Expanded(child: Text(text)),
				],
			),
		);
	}
}
