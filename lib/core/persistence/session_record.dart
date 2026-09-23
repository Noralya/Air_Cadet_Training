import "package:uuid/uuid.dart";
import "../engine/attempt.dart";

enum SessionKind { training, simulation }

class SessionRecord {
	SessionRecord({
		String? id,
		required this.kind,
		required this.psyType,
		required this.startedAt,
		required this.endedAt,
		required this.attempts,
	}) : id = id ?? const Uuid().v4();

	final String id;
	final SessionKind kind;
	final String? psyType;
	final DateTime startedAt;
	final DateTime endedAt;
	final List<Attempt> attempts;

	int get totalQuestions => attempts.length;

	int get correctCount => attempts.where((a) => a.isCorrect).length;

	double get successRate =>
		attempts.isEmpty ? 0 : correctCount / attempts.length;

	Duration get averageResponseTime {
		if (attempts.isEmpty) return Duration.zero;
		final totalMs = attempts.fold<int>(
			0, (sum, a) => sum + a.responseTime.inMilliseconds);
		return Duration(milliseconds: totalMs ~/ attempts.length);
	}

	Duration get totalDuration => endedAt.difference(startedAt);

	Map<String, dynamic> toJson() => {
			"id": id,
			"kind": kind.name,
			"psyType": psyType,
			"startedAt": startedAt.toIso8601String(),
			"endedAt": endedAt.toIso8601String(),
			"attempts": attempts.map((a) => a.toJson()).toList(),
		};

	factory SessionRecord.fromJson(Map<String, dynamic> json) => SessionRecord(
			id: json["id"] as String,
			kind: SessionKind.values.firstWhere((k) => k.name == json["kind"]),
			psyType: json["psyType"] as String?,
			startedAt: DateTime.parse(json["startedAt"] as String),
			endedAt: DateTime.parse(json["endedAt"] as String),
			attempts: (json["attempts"] as List)
				.map((e) => Attempt.fromJson(e as Map<String, dynamic>))
				.toList(),
		);
}
