class MotorStatus {
  final int direction;
  final double pause;
  final bool running;

  const MotorStatus(this.direction, this.pause, this.running);

  factory MotorStatus.fromJson(Map<String, dynamic> json) {
    return MotorStatus(json['direction'], json['pause'], json['running']);
  }
}
