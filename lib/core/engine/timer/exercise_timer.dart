import "dart:async";

enum TimerMode { none, perQuestion, global }

class ExerciseTimer {
	ExerciseTimer({required this.mode, this.duration});

	final TimerMode mode;
	final Duration? duration;

	Stopwatch? _stopwatch;
	Timer? _countdownTimer;
	final StreamController<Duration> _remainingController =
		StreamController<Duration>.broadcast();
	final StreamController<void> _expiredController =
		StreamController<void>.broadcast();

	Stream<Duration> get remaining => _remainingController.stream;
	Stream<void> get expired => _expiredController.stream;

	void start() {
		_stopwatch = Stopwatch()..start();
		if (mode == TimerMode.none || duration == null) {
			return;
		}
		Duration left = duration!;
		_remainingController.add(left);
		_countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
		left -= const Duration(milliseconds: 100);
		if (left.isNegative) {
			left = Duration.zero;
		}
		_remainingController.add(left);
		if (left == Duration.zero) {
			t.cancel();
			_expiredController.add(null);
		}
		});
	}

	Duration elapsed() {
		return _stopwatch?.elapsed ?? Duration.zero;
	}

	void stop() {
		_stopwatch?.stop();
		_countdownTimer?.cancel();
	}

	void dispose() {
		_countdownTimer?.cancel();
		_remainingController.close();
		_expiredController.close();
	}
}
