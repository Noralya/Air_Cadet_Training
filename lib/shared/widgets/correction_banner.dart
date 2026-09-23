import "package:flutter/material.dart";
import "../../core/theme/app_colors.dart";

class CorrectionBanner extends StatelessWidget {
	const CorrectionBanner({
		super.key,
		required this.isCorrect,
		this.message,
	});

	final bool isCorrect;
	final String? message;

	@override
	Widget build(BuildContext context) {
		final color = isCorrect ? AppColors.success : AppColors.error;
		return AnimatedContainer(
		duration: const Duration(milliseconds: 200),
		padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
		decoration: BoxDecoration(
			color: color.withOpacity(0.15),
			borderRadius: BorderRadius.circular(14),
			border: Border.all(color: color),
		),
		child: Row(
			children: [
			Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: color),
			const SizedBox(width: 10),
			Expanded(
				child: Text(
				message ?? (isCorrect ? "Bonne reponse" : "Reponse incorrecte"),
				style: TextStyle(color: color, fontWeight: FontWeight.w600),
				),
			),
			],
		),
		);
	}
}
