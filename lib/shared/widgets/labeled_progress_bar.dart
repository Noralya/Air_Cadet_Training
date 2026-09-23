import "package:flutter/material.dart";

class LabeledProgressBar extends StatelessWidget {
	const LabeledProgressBar({
		super.key,
		required this.label,
		required this.value,
		this.color,
	});

	final String label;
	final double value;
	final Color? color;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final percent = (value * 100).round();
		final barColor = color ?? theme.colorScheme.primary;
		return Padding(
		padding: const EdgeInsets.symmetric(vertical: 6),
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
			Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
				Text(label, style: theme.textTheme.bodyMedium),
				Text(
					"$percent %",
					style: theme.textTheme.bodyMedium?.copyWith(
					fontWeight: FontWeight.w600,
					color: barColor,
					),
				),
				],
			),
			const SizedBox(height: 6),
			ClipRRect(
				borderRadius: BorderRadius.circular(8),
				child: LinearProgressIndicator(
				value: value.clamp(0, 1),
				minHeight: 8,
				backgroundColor: theme.dividerColor,
				valueColor: AlwaysStoppedAnimation(barColor),
				),
			),
			],
		),
		);
	}
}
