import 'package:equatable/equatable.dart';

/// Public-facing user profile domain model.
///
/// Persisted profile fields (wins, battles, etc.) will live in Firestore later.
/// This model is intentionally complete for the foundation layer.
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.createdAt,
    this.email,
    this.photoUrl,
    this.username,
    this.bio,
    this.battlesPlayed = 0,
    this.battlesWon = 0,
  });

  final String id;
  final String displayName;
  final String? email;
  final String? photoUrl;
  final String? username;
  final String? bio;
  final int battlesPlayed;
  final int battlesWon;
  final DateTime createdAt;

  double get winRate {
    if (battlesPlayed == 0) {
      return 0;
    }
    return battlesWon / battlesPlayed;
  }

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    String? username,
    String? bio,
    int? battlesPlayed,
    int? battlesWon,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      battlesPlayed: battlesPlayed ?? this.battlesPlayed,
      battlesWon: battlesWon ?? this.battlesWon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Builds a starter profile from authenticated identity.
  factory UserProfile.fromAuth({
    required String id,
    required String? email,
    String? displayName,
    String? photoUrl,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName?.trim().isNotEmpty == true
          ? displayName!.trim()
          : (email?.split('@').first ?? 'Arena Fighter'),
      email: email,
      photoUrl: photoUrl,
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    email,
    photoUrl,
    username,
    bio,
    battlesPlayed,
    battlesWon,
    createdAt,
  ];
}
