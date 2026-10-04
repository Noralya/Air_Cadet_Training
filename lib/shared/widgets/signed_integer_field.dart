import "package:flutter/material.dart";
import "package:flutter/services.dart";

class SignedIntegerField extends StatelessWidget {
	const SignedIntegerField({
		super.key,
		required this.controller,
		this.enabled = true,
		this.autofocus = false,
		this.onSubmitted,
	});

	final TextEditingController controller;
	final bool enabled;
	final bool autofocus;
	final ValueChanged<String>? onSubmitted;

	@override
	Widget build(BuildContext context) {
		return TextField(
			controller: controller,
			enabled: enabled,
			autofocus: autofocus,
			textAlign: TextAlign.center,
			keyboardType: const TextInputType.numberWithOptions(signed: true),
			inputFormatters: [
				FilteringTextInputFormatter.allow(RegExp(r"^-?\d*")),
			],
			style: Theme.of(context)
				.textTheme
				.headlineSmall
				?.copyWith(fontWeight: FontWeight.w700),
			decoration: const InputDecoration(
				border: OutlineInputBorder(),
				hintText: "Resultat",
			),
			onSubmitted: onSubmitted,
		);
	}
}
