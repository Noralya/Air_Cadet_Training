import "dart:math";

import "package:flutter/material.dart";

class AngleDialPainter extends CustomPainter {
	AngleDialPainter({
		required this.originDegrees,
		required this.arrivalDegrees,
		required this.color,
	});

	final int originDegrees;
	final int arrivalDegrees;
	final Color color;

	Offset _pointOnCircle(Offset center, double radius, int degrees) {
		final rad = (degrees - 90) * pi / 180;
		return Offset(center.dx + radius * cos(rad), center.dy + radius * sin(rad));
	}

	@override
	void paint(Canvas canvas, Size size) {
		final center = Offset(size.width / 2, size.height / 2);
		final radius = min(size.width, size.height) / 2 - 8;

		final circlePaint = Paint()
		..color = color.withOpacity(0.25)
		..style = PaintingStyle.stroke
		..strokeWidth = 2;
		canvas.drawCircle(center, radius, circlePaint);

		final originPoint = _pointOnCircle(center, radius, originDegrees);
		final arrivalPoint = _pointOnCircle(center, radius, arrivalDegrees);

		final linePaint = Paint()
		..color = color
		..strokeWidth = 3
		..style = PaintingStyle.stroke;

		canvas.drawLine(center, originPoint, linePaint..color = color.withOpacity(0.55));
		canvas.drawLine(center, arrivalPoint, linePaint..color = color);

		canvas.drawCircle(center, 4, Paint()..color = color);
		_drawLabel(canvas, originPoint, "O", color.withOpacity(0.8));
		_drawLabel(canvas, arrivalPoint, "A", color);
	}

	void _drawLabel(Canvas canvas, Offset point, String text, Color color) {
		final painter = TextPainter(
		text: TextSpan(
			text: text,
			style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16),
		),
		textDirection: TextDirection.ltr,
		)..layout();
		painter.paint(canvas, point - Offset(painter.width / 2, painter.height / 2));
	}

	@override
	bool shouldRepaint(covariant AngleDialPainter oldDelegate) =>
		oldDelegate.originDegrees != originDegrees ||
		oldDelegate.arrivalDegrees != arrivalDegrees;
}

class ReferenceWatchPainter extends CustomPainter {
	ReferenceWatchPainter({required this.color});

	final Color color;

	@override
	void paint(Canvas canvas, Size size) {
		final center = Offset(size.width / 2, size.height / 2);
		final radius = min(size.width, size.height) / 2 - 6;

		final circlePaint = Paint()
		..color = color.withOpacity(0.4)
		..style = PaintingStyle.stroke
		..strokeWidth = 2;
		canvas.drawCircle(center, radius, circlePaint);

		const marks = {12: "12", 3: "3", 6: "6", 9: "9"};
		marks.forEach((hour, label) {
		final degrees = hour * 30;
		final rad = (degrees - 90) * pi / 180;
		final point = Offset(
			center.dx + (radius - 12) * cos(rad),
			center.dy + (radius - 12) * sin(rad),
		);
		final painter = TextPainter(
			text: TextSpan(
			text: label,
			style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
			),
			textDirection: TextDirection.ltr,
		)..layout();
		painter.paint(canvas, point - Offset(painter.width / 2, painter.height / 2));
		});

		final arrowPaint = Paint()
		..color = color
		..strokeWidth = 2
		..style = PaintingStyle.stroke;
		final arcRect = Rect.fromCircle(center: center, radius: radius * 0.55);
		canvas.drawArc(arcRect, -pi / 2, pi * 0.7, false, arrowPaint);
	}

	@override
	bool shouldRepaint(covariant ReferenceWatchPainter oldDelegate) => false;
}
