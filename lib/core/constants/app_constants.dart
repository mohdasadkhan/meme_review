/// App-wide constants for Meme Arena.
abstract final class AppConstants {
  static const String appName = 'Meme Arena';
  static const String appTagline = 'Battle memes. Claim the crown.';

  /// Voting window duration after both memes are revealed.
  static const Duration battleVotingDuration = Duration(minutes: 60);

  static const String routeHome = '/';
  static const String routeSignIn = '/sign-in';
  static const String routeProfile = '/profile';
}
