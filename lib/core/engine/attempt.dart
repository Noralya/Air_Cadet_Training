class Attempt {
	Attempt({
		required this.exerciseId,
		required this.categoryKey,
		required this.psyType,
		required this.isCorrect,
		required this.responseTime,
		required this.timedOut,
		DateTime? timestamp,
	}) : timestamp = timestamp ?? DateTime.now();

	final String exerciseId;
	final String categoryKey;
	final String psyType;
	final bool isCorrect;
	final Duration responseTime;
	final bool timedOut;
	final DateTime timestamp;

	Map<String, dynamic> toJson() => {
			"exerciseId": exerciseId,
			"categoryKey": categoryKey,
			"psyType": psyType,
			"isCorrect": isCorrect,
			"responseTimeMs": responseTime.inMilliseconds,
			"timedOut": timedOut,
			"timestamp": timestamp.toIso8601String(),
		};

	factory Attempt.fromJson(Map<String, dynamic> json) => Attempt(
			exerciseId: json["exerciseId"] as String,
			categoryKey: json["categoryKey"] as String,
			psyType: json["psyType"] as String,
			isCorrect: json["isCorrect"] as bool,
			responseTime: Duration(milliseconds: json["responseTimeMs"] as int),
			timedOut: json["timedOut"] as bool,
			timestamp: DateTime.parse(json["timestamp"] as String),
		);
}
