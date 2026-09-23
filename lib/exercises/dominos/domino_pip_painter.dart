import "package:flutter/material.dart";

class DominoPipPainter extends CustomPainter {
	const DominoPipPainter({required this.value, required this.color});

	final int value;
	final Color color;

	static const Map<int, List<List<double>>> _layouts = {
		0: [],
		1: [
		[0.5, 0.5]
		],
		2: [
		[0.25, 0.25],
		[0.75, 0.75]
		],
		3: [
		[0.25, 0.25],
		[0.5, 0.5],
		[0.75, 0.75]
		],
		4: [
		[0.25, 0.25],
		[0.75, 0.25],
		[0.25, 0.75],
		[0.75, 0.75]
		],
		5: [
		[0.25, 0.25],
		[0.75, 0.25],
		[0.5, 0.5],
		[0.25, 0.75],
		[0.75, 0.75]
		],
		6: [
		[0.25, 0.2],
		[0.75, 0.2],
		[0.25, 0.5],
		[0.75, 0.5],
		[0.25, 0.8],
		[0.75, 0.8]
		],
	};

	@override
	void paint(Canvas canvas, Size size) {
		if (size.isEmpty) return;
		final positions = _layouts[value] ?? const [];
		final radius = size.shortestSide * 0.11;
		final paint = Paint()..color = color;
		for (final position in positions) {
		canvas.drawCircle(
			Offset(position[0] * size.width, position[1] * size.height),
			radius,
			paint,
		);
		}
	}

	@override
	bool shouldRepaint(covariant DominoPipPainter oldDelegate) =>
		oldDelegate.value != value || oldDelegate.color != color;
}
