import "dart:math";
import "domino_value.dart";

class DominosQuestion {
	DominosQuestion({
		required this.grid,
		required this.maskedIndex,
		required this.correctAnswer,
		required this.logicLabel,
	});

	final DominoGrid grid;
	final int maskedIndex;
	final DominoValue correctAnswer;
	final String logicLabel;
}

class _GridResult {
	_GridResult({required this.grid, required this.label, this.maskExclusions});

	final DominoGrid grid;
	final String label;
	final List<int>? maskExclusions;
}

typedef _GridBuilder = _GridResult Function(Random rng);

class DominosGenerator {
	static final List<_GridBuilder> _builders = [
		_lineConstantStepFlip,
		_lineConstantGap,
		_lineGapIncreasing,
		_rowUniqueDigits,
		_rowFrequency,
		_lineCommonNeighbor,
		_rowsSumFibonacci,
		_rowsDifference,
		_rowsMultiply,
		_rowsConstantStep,
		_symmetryCentralRow,
		_symmetryRotational,
		_symmetryDiagonal,
		_chainConstantStepGrid,
		_chainAlternatingGaps,
		_columnConstantStep,
		_rowAndColumnConstantStep,
		_rowSumConstant,
		_rowGapConstant,
	];

	static DominosQuestion generate({Random? random}) {
		final rng = random ?? Random();
		final builder = _builders[rng.nextInt(_builders.length)];
		final result = builder(rng);
		final excluded = result.maskExclusions?.toSet() ?? const <int>{};
		final candidates = [
		for (var i = 0; i < result.grid.cells.length; i++)
			if (!excluded.contains(i)) i
		];
		final maskedIndex = candidates[rng.nextInt(candidates.length)];

		return DominosQuestion(
			grid: result.grid,
			maskedIndex: maskedIndex,
			correctAnswer: result.grid.cells[maskedIndex],
			logicLabel: result.label,
		);
	}

	static DominoGrid _grid(int rows, int cols, List<DominoValue> cells) =>
		DominoGrid(rows: rows, columns: cols, cells: cells);

	// A1 - Progression constante, un domino sur deux retourne.
	static _GridResult _lineConstantStepFlip(Random rng) {
		const cols = 6;
		final startTop = rng.nextInt(7);
		final startBottom = rng.nextInt(7);
		final stepTop = 1 + rng.nextInt(5);
		final stepBottom = 1 + rng.nextInt(5);
		final cells = List.generate(cols, (i) {
		final top = mod7(startTop + stepTop * i);
		final bottom = mod7(startBottom + stepBottom * i);
		final flipped = i.isOdd;
		return flipped ? DominoValue(bottom, top) : DominoValue(top, bottom);
		});
		return _GridResult(
			grid: _grid(1, cols, cells),
			label: "Progression constante (un domino sur deux retourne)",
		);
	}

	// A2 - Ecart constant entre haut et bas.
	static _GridResult _lineConstantGap(Random rng) {
		const cols = 6;
		final gap = rng.nextInt(7);
		final cells = List.generate(cols, (_) {
		final top = rng.nextInt(7);
		return DominoValue(top, mod7(top - gap));
		});
		return _GridResult(grid: _grid(1, cols, cells), label: "Ecart constant");
	}

	// A3 - Ecart qui augmente de 1 a chaque domino.
	static _GridResult _lineGapIncreasing(Random rng) {
		const cols = 6;
		final gap0 = rng.nextInt(7);
		final cells = List.generate(cols, (i) {
		final top = rng.nextInt(7);
		return DominoValue(top, mod7(top - mod7(gap0 + i)));
		});
		return _GridResult(grid: _grid(1, cols, cells), label: "Ecart croissant");
	}

	// B4 - Chaque chiffre 0-6 une seule fois en haut, une seule fois en bas.
	static _GridResult _rowUniqueDigits(Random rng) {
		const cols = 7;
		final tops = List.generate(7, (i) => i)..shuffle(rng);
		final bottoms = List.generate(7, (i) => i)..shuffle(rng);
		final cells = List.generate(cols, (i) => DominoValue(tops[i], bottoms[i]));
		return _GridResult(
			grid: _grid(1, cols, cells),
			label: "Chiffres uniques par ligne",
		);
	}

	// B5 - Quelques chiffres reviennent le meme nombre de fois.
	static _GridResult _rowFrequency(Random rng) {
		const cols = 6;
		final digits = List.generate(7, (i) => i)..shuffle(rng);
		final topDigits = digits.sublist(0, 2);
		final bottomDigits = digits.sublist(2, 5);
		final tops = [...topDigits, ...topDigits, ...topDigits]..shuffle(rng);
		final bottoms = [...bottomDigits, ...bottomDigits]..shuffle(rng);
		final cells = List.generate(cols, (i) => DominoValue(tops[i], bottoms[i]));
		return _GridResult(
			grid: _grid(1, cols, cells),
			label: "Frequence egale des chiffres",
		);
	}

	// C6 - Chiffre commun entre voisins, alternant haut/bas.
	static _GridResult _lineCommonNeighbor(Random rng) {
		const cols = 6;
		var top = rng.nextInt(7);
		var bottom = rng.nextInt(7);
		var sharedOnTop = true;
		final cells = <DominoValue>[DominoValue(top, bottom)];
		for (var i = 1; i < cols; i++) {
		if (sharedOnTop) {
			top = bottom;
			bottom = rng.nextInt(7);
		} else {
			bottom = bottom;
			top = rng.nextInt(7);
		}
		cells.add(DominoValue(top, bottom));
		sharedOnTop = !sharedOnTop;
		}
		return _GridResult(
			grid: _grid(1, cols, cells),
			label: "Chiffre commun alterne entre voisins",
		);
	}

	// C7a - Chaque ligne est la somme des deux precedentes.
	static _GridResult _rowsSumFibonacci(Random rng) {
		const rows = 4;
		const cols = 3;
		final grid = List.generate(rows, (_) => List<DominoValue>.filled(cols, const DominoValue(0, 0)));
		for (var c = 0; c < cols; c++) {
		grid[0][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
		grid[1][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
		}
		for (var r = 2; r < rows; r++) {
			for (var c = 0; c < cols; c++) {
				final a = grid[r - 1][c];
				final b = grid[r - 2][c];
				grid[r][c] = DominoValue(mod7(a.top + b.top), mod7(a.bottom + b.bottom));
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, grid.expand((row) => row).toList()),
			label: "Somme des deux lignes precedentes",
		);
	}

	// C7b - Chaque ligne est la difference (precedente - avant-precedente).
	static _GridResult _rowsDifference(Random rng) {
		const rows = 4;
		const cols = 3;
		final grid = List.generate(rows, (_) => List<DominoValue>.filled(cols, const DominoValue(0, 0)));
		for (var c = 0; c < cols; c++) {
		grid[0][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
		grid[1][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
		}
		for (var r = 2; r < rows; r++) {
			for (var c = 0; c < cols; c++) {
				final prev = grid[r - 1][c];
				final beforePrev = grid[r - 2][c];
				grid[r][c] = DominoValue(
				mod7(prev.top - beforePrev.top),
				mod7(prev.bottom - beforePrev.bottom),
				);
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, grid.expand((row) => row).toList()),
			label: "Difference des deux lignes precedentes",
		);
	}

	// C7c - Chaque ligne est le produit de la precedente par un facteur fixe.
	static _GridResult _rowsMultiply(Random rng) {
		const rows = 3;
		const cols = 3;
		final factor = [2, 3][rng.nextInt(2)];
		final grid = List.generate(rows, (_) => List<DominoValue>.filled(cols, const DominoValue(0, 0)));
		for (var c = 0; c < cols; c++) {
			grid[0][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
		}
		for (var r = 1; r < rows; r++) {
			for (var c = 0; c < cols; c++) {
				final prev = grid[r - 1][c];
				grid[r][c] = DominoValue(mod7(prev.top * factor), mod7(prev.bottom * factor));
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, grid.expand((row) => row).toList()),
			label: "Multiplication entre lignes (x$factor)",
		);
	}

	// C8 - Pas constant additif d'une ligne a l'autre.
	static _GridResult _rowsConstantStep(Random rng) {
		const rows = 4;
		const cols = 3;
		final stepTop = 1 + rng.nextInt(5);
		final stepBottom = 1 + rng.nextInt(5);
		final grid = List.generate(rows, (_) => List<DominoValue>.filled(cols, const DominoValue(0, 0)));
		for (var c = 0; c < cols; c++) {
			grid[0][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
		}
		for (var r = 1; r < rows; r++) {
			for (var c = 0; c < cols; c++) {
				final prev = grid[r - 1][c];
				grid[r][c] = DominoValue(mod7(prev.top + stepTop), mod7(prev.bottom + stepBottom));
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, grid.expand((row) => row).toList()),
			label: "Pas constant entre lignes",
		);
	}

	// D9 - Symetrie miroir par rapport a l'axe horizontal central.
	static _GridResult _symmetryCentralRow(Random rng) {
		const rows = 4;
		const cols = 3;
		final grid = List.generate(rows, (_) => List<DominoValue>.filled(cols, const DominoValue(0, 0)));
		for (var c = 0; c < cols; c++) {
			grid[0][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
			grid[1][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
			grid[3][c] = grid[0][c];
			grid[2][c] = grid[1][c];
		}
		return _GridResult(
			grid: _grid(rows, cols, grid.expand((row) => row).toList()),
			label: "Symetrie miroir (lignes)",
		);
	}

	// D10 - Symetrie par rotation de 180 degres.
	static _GridResult _symmetryRotational(Random rng) {
		const rows = 4;
		const cols = 3;
		final total = rows * cols;
		final cells = List<DominoValue>.filled(total, const DominoValue(0, 0));
		for (var i = 0; i < total ~/ 2; i++) {
			final value = DominoValue(rng.nextInt(7), rng.nextInt(7));
			cells[i] = value;
			cells[total - 1 - i] = DominoValue(value.bottom, value.top);
		}
		return _GridResult(
			grid: _grid(rows, cols, cells),
			label: "Symetrie par rotation (180 degres)",
		);
	}

	// D11 - Symetrie par rapport a la diagonale principale.
	static _GridResult _symmetryDiagonal(Random rng) {
		const size = 3;
		final grid = List.generate(size, (_) => List<DominoValue>.filled(size, const DominoValue(0, 0)));
		for (var r = 0; r < size; r++) {
			for (var c = 0; c < size; c++) {
				if (r <= c) {
				grid[r][c] = DominoValue(rng.nextInt(7), rng.nextInt(7));
				} else {
				grid[r][c] = grid[c][r];
				}
			}
		}
		final diagonalIndices = List.generate(size, (i) => i * size + i);
		return _GridResult(
			grid: _grid(size, size, grid.expand((row) => row).toList()),
			label: "Symetrie diagonale",
			maskExclusions: diagonalIndices,
		);
	}

	// E12 - Chaine unique a pas constant, lue ligne par ligne sur la grille.
	static _GridResult _chainConstantStepGrid(Random rng) {
		const rows = 3;
		const cols = 3;
		final step = 1 + rng.nextInt(6);
		var value = rng.nextInt(7);
		final flat = <int>[];
		for (var k = 0; k < rows * cols * 2; k++) {
			flat.add(value);
			value = mod7(value + step);
		}
		final cells = List.generate(
			rows * cols,
			(i) => DominoValue(flat[2 * i], flat[2 * i + 1]),
		);
		return _GridResult(
			grid: _grid(rows, cols, cells),
			label: "Chaine unique a pas constant",
		);
	}

	// E13 - Deux ecarts alternes (interieur du domino / entre dominos).
	static _GridResult _chainAlternatingGaps(Random rng) {
		const cols = 6;
		final insideGap = 1 + rng.nextInt(6);
		final betweenGap = 1 + rng.nextInt(6);
		var top = rng.nextInt(7);
		final cells = List.generate(cols, (_) {
			final bottom = mod7(top + insideGap);
			final domino = DominoValue(top, bottom);
			top = mod7(bottom + betweenGap);
			return domino;
		});
		return _GridResult(
			grid: _grid(1, cols, cells),
			label: "Deux ecarts alternes",
		);
	}

	// F14 - Chaque colonne suit son propre pas constant.
	static _GridResult _columnConstantStep(Random rng) {
		const rows = 4;
		const cols = 3;
		final grid = List.generate(rows, (_) => List<DominoValue>.filled(cols, const DominoValue(0, 0)));
		for (var c = 0; c < cols; c++) {
			final startTop = rng.nextInt(7);
			final startBottom = rng.nextInt(7);
			final stepTop = 1 + rng.nextInt(5);
			final stepBottom = 1 + rng.nextInt(5);
			for (var r = 0; r < rows; r++) {
				grid[r][c] = DominoValue(
					mod7(startTop + stepTop * r),
					mod7(startBottom + stepBottom * r),
				);
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, grid.expand((row) => row).toList()),
			label: "Pas constant par colonne",
		);
	}

	// F15 - Pas constant simultanement en ligne et en colonne.
	static _GridResult _rowAndColumnConstantStep(Random rng) {
		const rows = 3;
		const cols = 3;
		final baseTop = rng.nextInt(7);
		final baseBottom = rng.nextInt(7);
		final rowStepTop = 1 + rng.nextInt(4);
		final rowStepBottom = 1 + rng.nextInt(4);
		final colStepTop = 1 + rng.nextInt(4);
		final colStepBottom = 1 + rng.nextInt(4);
		final cells = <DominoValue>[];
		for (var r = 0; r < rows; r++) {
			for (var c = 0; c < cols; c++) {
				cells.add(DominoValue(
					mod7(baseTop + rowStepTop * r + colStepTop * c),
					mod7(baseBottom + rowStepBottom * r + colStepBottom * c),
				));
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, cells),
			label: "Pas constant lignes et colonnes",
		);
	}

	static _GridResult _rowSumConstant(Random rng) {
		const rows = 2;
		const cols = 4;
		final cells = <DominoValue>[];
		for (var r = 0; r < rows; r++) {
			final sum = 4 + rng.nextInt(7);
			final minTop = max(0, sum - 6);
			final maxTop = min(6, sum);
			for (var c = 0; c < cols; c++) {
				final top = minTop + rng.nextInt(maxTop - minTop + 1);
				cells.add(DominoValue(top, sum - top));
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, cells),
			label: "Somme constante par ligne",
		);
	}

	static _GridResult _rowGapConstant(Random rng) {
		const rows = 2;
		const cols = 4;
		final cells = <DominoValue>[];
		for (var r = 0; r < rows; r++) {
			final gap = rng.nextInt(7);
			for (var c = 0; c < cols; c++) {
				final top = rng.nextInt(7);
				cells.add(DominoValue(top, mod7(top - gap)));
			}
		}
		return _GridResult(
			grid: _grid(rows, cols, cells),
			label: "Ecart constant par ligne",
		);
	}
}