import "package:flutter/material.dart";

class StatTile extends StatelessWidget {
	const StatTile({
		super.key,
		required this.label,
		required this.value,
		this.icon,
	});

	final String label;
	final String value;
	final IconData? icon;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Container(
		padding: const EdgeInsets.all(12),
		decoration: BoxDecoration(
			color: theme.cardTheme.color,
			borderRadius: BorderRadius.circular(16),
			border: Border.all(
			color: theme.dividerColor,
			),
		),
		child: Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
			if (icon != null)
				Icon(icon, size: 20, color: theme.colorScheme.primary),
			const SizedBox(height: 4),
			Text(
				value,
				style: theme.textTheme.headlineSmall?.copyWith(
				fontWeight: FontWeight.w700,
				),
			),
			const SizedBox(height: 2),
			Text(
				label,
				style: theme.textTheme.bodySmall?.copyWith(
				color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
				),
			),
			],
		),
		);
	}
}