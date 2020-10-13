class Detection {
  final String label;
  final double score;

  final double left;
  final double top;
  final double right;
  final double bottom;

  Detection(
      this.label, this.score, this.left, this.top, this.right, this.bottom);

  factory Detection.fromJson(dynamic json) {
    return Detection(json[0], json[1], json[2][0][0], json[2][0][1],
        json[2][1][0], json[2][1][1]);
  }
}
