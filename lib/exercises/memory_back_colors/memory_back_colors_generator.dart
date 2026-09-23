import "dart:math";

import "package:flutter/material.dart";

class MemoryColorPalette {
	static const List<Color> colors = [
		Color(0xFFE5484D),
		Color(0xFF34C759),
		Color(0xFF2F80ED),
		Color(0xFFF5A623),
		Color(0xFF9B51E0),
		Color(0xFF17C3B2),
	];
}

class MemoryBackColorsGenerator {
	static List<Color> generateSequence({int length = 16, Random? random}) {
		final rng = random ?? Random();
		return List.generate(
			length,
			(_) => MemoryColorPalette.colors[rng.nextInt(MemoryColorPalette.colors.length)],
		);
	}
}
