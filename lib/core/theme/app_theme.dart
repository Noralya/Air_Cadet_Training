import "package:flutter/material.dart";
import "app_colors.dart";

class AppTheme {
	AppTheme._();

	static ThemeData light() {
		final colorScheme = ColorScheme.fromSeed(
			seedColor: AppColors.accent,
			brightness: Brightness.light,
		);
		return ThemeData(
		useMaterial3: true,
		brightness: Brightness.light,
		colorScheme: colorScheme,
		scaffoldBackgroundColor: AppColors.lightBackground,
		fontFamily: "Roboto",
		appBarTheme: const AppBarTheme(
			backgroundColor: AppColors.lightBackground,
			foregroundColor: Color(0xFF10182B),
			elevation: 0,
			centerTitle: false,
		),
		cardTheme: CardThemeData(
			color: AppColors.lightSurface,
			elevation: 0,
			shape: RoundedRectangleBorder(
			borderRadius: BorderRadius.circular(16),
			side: const BorderSide(color: AppColors.lightBorder),
			),
		),
		elevatedButtonTheme: ElevatedButtonThemeData(
			style: ElevatedButton.styleFrom(
			backgroundColor: AppColors.accent,
			foregroundColor: Colors.white,
			padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(14),
			),
			textStyle:
				const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
			),
		),
		dividerColor: AppColors.lightBorder,
		);
	}

	static ThemeData dark() {
		final colorScheme = ColorScheme.fromSeed(
		seedColor: AppColors.accent,
		brightness: Brightness.dark,
		surface: AppColors.darkBlueSurface,
		background: AppColors.darkBlue,
		);
		return ThemeData(
		useMaterial3: true,
		brightness: Brightness.dark,
		colorScheme: colorScheme,
		scaffoldBackgroundColor: AppColors.darkBlue,
		fontFamily: "Roboto",
		appBarTheme: const AppBarTheme(
			backgroundColor: AppColors.darkBlue,
			foregroundColor: Colors.white,
			elevation: 0,
			centerTitle: false,
		),
		cardTheme: CardThemeData(
			color: AppColors.darkBlueSurface,
			elevation: 0,
			shape: RoundedRectangleBorder(
			borderRadius: BorderRadius.circular(16),
			side: const BorderSide(color: AppColors.darkBlueSurfaceAlt),
			),
		),
		elevatedButtonTheme: ElevatedButtonThemeData(
			style: ElevatedButton.styleFrom(
			backgroundColor: AppColors.accent,
			foregroundColor: Colors.white,
			padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(14),
			),
			textStyle:
				const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
			),
		),
		dividerColor: AppColors.darkBlueSurfaceAlt,
		);
	}
}
