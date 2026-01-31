import '../../data/auth_repository/auth_repository.dart';
import '../../data/dto/api_response.dart';

/// UseCase: Handles user login flow
/// Abstracts repository implementation and business rules
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Executes login with [username] and [password].
  /// Returns [ApiResponse] containing login data or error message.
  Future<ApiResponse> execute({
    required String username,
    required String password,
  }) async {
    // Business rules or pre-validation could be added here:
    // e.g., trim username, check for empty password, etc.
    final trimmedUsername = username.trim();
    if (trimmedUsername.isEmpty || password.isEmpty) {
      return ApiResponse.failure('Username and password cannot be empty');
    }

    // Call repository to perform API request
    final response = await repository.login(trimmedUsername, password);

    // Post-processing can happen here (e.g., caching token)
    if (response.success) {
      // Example: could save token or handle session here
    }

    return response;
  }
}
