import "package:flutter/material.dart";

class TimerBar extends StatelessWidget {
	const TimerBar({super.key, required this.progress});

	final double progress;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final color = progress < 0.2
			? theme.colorScheme.error
			: theme.colorScheme.primary.withOpacity(0.6);
		return ClipRRect(
			borderRadius: BorderRadius.circular(4),
			child: LinearProgressIndicator(
				value: progress.clamp(0, 1),
				minHeight: 4,
				backgroundColor: theme.dividerColor,
				valueColor: AlwaysStoppedAnimation(color),
			),
		);
	}
}
