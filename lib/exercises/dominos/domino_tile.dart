import "package:flutter/material.dart";
import "domino_pip_painter.dart";

class DominoTile extends StatelessWidget {
	const DominoTile({
		super.key,
		this.top,
		this.bottom,
		this.highlighted = false,
		this.pipColor,
	});

	final int? top;
	final int? bottom;
	final bool highlighted;
	final Color? pipColor;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final borderColor =
			highlighted ? theme.colorScheme.primary : theme.dividerColor;
		final dotColor = pipColor ?? theme.colorScheme.onSurface;

		return Container(
		width: 64,
		height: 116,
		decoration: BoxDecoration(
			color: theme.cardTheme.color,
			borderRadius: BorderRadius.circular(12),
			border: Border.all(color: borderColor, width: highlighted ? 2 : 1),
		),
		child: Column(
			children: [
			Expanded(child: _Half(value: top, color: dotColor)),
			Divider(height: 1, color: borderColor),
			Expanded(child: _Half(value: bottom, color: dotColor)),
			],
		),
		);
	}
}

class _Half extends StatelessWidget {
	const _Half({required this.value, required this.color});

	final int? value;
	final Color color;

	@override
	Widget build(BuildContext context) {
		if (value == null) {
		return Center(
			child: Text(
			"?",
			style: TextStyle(
				fontSize: 22,
				fontWeight: FontWeight.w800,
				color: color,
			),
			),
		);
		}

		if (value == 0) {
			return const SizedBox.expand();
		}

		return Padding(
			padding: const EdgeInsets.all(6),
			child: SizedBox.expand(
				child: CustomPaint(
				painter: DominoPipPainter(value: value!, color: color),
				),
			),
		);
	}
}