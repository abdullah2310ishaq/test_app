enum MoodKind {
  calm,
  content,
  peaceful,
  happy;

  String get assetPath => switch (this) {
    MoodKind.calm => 'assets/calm.png',
    MoodKind.content => 'assets/content.png',
    MoodKind.peaceful => 'assets/peaceful.png',
    MoodKind.happy => 'assets/happy.png',
  };

  String get label => switch (this) {
    MoodKind.calm => 'Calm',
    MoodKind.content => 'Content',
    MoodKind.peaceful => 'Peaceful',
    MoodKind.happy => 'Happy',
  };
}
