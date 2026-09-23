import "package:flutter/widgets.dart";

class Responsive {
	Responsive._();

	static bool isTablet(BuildContext context) =>
		MediaQuery.sizeOf(context).shortestSide >= 600;

	static double horizontalPadding(BuildContext context) =>
		isTablet(context) ? 48 : 20;

	static int gridColumns(BuildContext context) {
		final width = MediaQuery.sizeOf(context).width;
		if (width >= 900) return 3;
		if (width >= 600) return 2;
		return 1;
	}

	static double maxContentWidth(BuildContext context) =>
		isTablet(context) ? 720 : double.infinity;
}
