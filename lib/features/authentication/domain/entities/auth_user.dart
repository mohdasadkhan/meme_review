import 'package:equatable/equatable.dart';

/// Authenticated user identity from the auth provider.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
  });

  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;

  bool get isAuthenticated => !isAnonymous && id.isNotEmpty;

  static const empty = AuthUser(id: '', email: null, isAnonymous: true);

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, isAnonymous];
}
