import "package:flutter/material.dart";
import "domino_tile.dart";
import "domino_value.dart";

class DominoGridView extends StatelessWidget {
	const DominoGridView({
		super.key,
		required this.grid,
		required this.maskedIndex,
		this.previewTop,
		this.previewBottom,
	});

	final DominoGrid grid;
	final int maskedIndex;
	final int? previewTop;
	final int? previewBottom;

	Widget _buildTile(BuildContext context, int index) {
		final theme = Theme.of(context);
		final isMasked = index == maskedIndex;
		final domino = grid.cells[index];
		return DominoTile(
			top: isMasked ? previewTop : domino.top,
			bottom: isMasked ? previewBottom : domino.bottom,
			highlighted: isMasked,
			pipColor: isMasked ? theme.colorScheme.primary : null,
		);
	}

	@override
	Widget build(BuildContext context) {
		if (grid.rows == 1) {
		return SizedBox(
			height: 116,
			child: ListView.separated(
				scrollDirection: Axis.horizontal,
				itemCount: grid.cells.length,
				separatorBuilder: (_, __) => const SizedBox(width: 10),
				itemBuilder: (context, i) => _buildTile(context, i),
			),
		);
		}

		return SingleChildScrollView(
		scrollDirection: Axis.horizontal,
		child: Column(
			mainAxisSize: MainAxisSize.min,
			children: List.generate(grid.rows, (r) {
			return Padding(
				padding: const EdgeInsets.only(bottom: 10),
				child: Row(
				mainAxisSize: MainAxisSize.min,
				children: List.generate(grid.columns, (c) {
					final index = grid.indexOf(r, c);
					return Padding(
						padding: const EdgeInsets.only(right: 10),
						child: _buildTile(context, index),
					);
				}),
				),
			);
			}),
		),
		);
	}
}