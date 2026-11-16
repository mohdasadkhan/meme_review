import 'package:flutter_test/flutter_test.dart';
import 'package:meme_review/features/profile/domain/entities/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('fromAuth uses display name when present', () {
      final profile = UserProfile.fromAuth(
        id: 'uid-1',
        email: 'fighter@arena.app',
        displayName: 'Arena Ace',
        photoUrl: 'https://example.com/a.png',
      );

      expect(profile.id, 'uid-1');
      expect(profile.displayName, 'Arena Ace');
      expect(profile.email, 'fighter@arena.app');
      expect(profile.battlesPlayed, 0);
      expect(profile.winRate, 0);
    });

    test('fromAuth falls back to email local-part', () {
      final profile = UserProfile.fromAuth(
        id: 'uid-2',
        email: 'shadow@arena.app',
        displayName: null,
      );

      expect(profile.displayName, 'shadow');
    });

    test('winRate calculates correctly', () {
      final profile = UserProfile(
        id: 'uid-3',
        displayName: 'Rival',
        createdAt: DateTime.utc(2026, 1, 1),
        battlesPlayed: 4,
        battlesWon: 1,
      );

      expect(profile.winRate, 0.25);
    });
  });
}
