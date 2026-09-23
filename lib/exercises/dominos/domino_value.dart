class DominoValue {
	const DominoValue(this.top, this.bottom);

	final int top;
	final int bottom;

	@override
	bool operator ==(Object other) =>
		other is DominoValue && other.top == top && other.bottom == bottom;

	@override
	int get hashCode => Object.hash(top, bottom);

	@override
	String toString() => "$top/$bottom";
}

int mod7(int value) => ((value % 7) + 7) % 7;

class DominoGrid {
	DominoGrid({required this.rows, required this.columns, required this.cells})
		: assert(cells.length == rows * columns);

	final int rows;
	final int columns;
	final List<DominoValue> cells;

	int indexOf(int row, int col) => row * columns + col;

	DominoValue at(int row, int col) => cells[indexOf(row, col)];
}