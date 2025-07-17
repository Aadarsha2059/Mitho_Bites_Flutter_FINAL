import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:fooddelivery_b/features/user/data/datasource/local_datasource/user_local_datasource.dart';
import 'package:fooddelivery_b/features/user/data/datasource/remote_datasource/user_remote_datasource.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(String username, String password);

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, UserEntity>> updateUser(UserEntity user, {String? currentPassword});
}

// Hybrid Repository Implementation
class UserRepository implements IUserRepository {
  final UserRemoteDatasource remoteDataSource;
  final UserLocalDatasource localDataSource;

  UserRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Check network connectivity
  Future<bool> _isNetworkConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Connectivity check failed: $e');
      return false;
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String username, String password) async {
    try {
      print('=== Login User Started ===');
      print('Username: $username');
      
      // Check network connectivity
      final isNetwork = await _isNetworkConnected();
      print('Network connected: $isNetwork');

      if (isNetwork) {
        // Network available - try remote first
        print('Attempting remote login...');
        try {
          final token = await remoteDataSource.loginUser(username, password);
          print('Remote login successful, token: ${token.substring(0, 20)}...');
          
          // Cache successful login locally for offline access
          await localDataSource.registerUser(UserEntity(
            userId: null,
            fullname: '',
            username: username,
            password: password,
            phone: '',
            address: '',
            email: '',
          ));
          print('Login data cached locally');
          
          return Right(token);
        } catch (remoteError) {
          print('Remote login failed: $remoteError');
          
          // Only fall back to local login if it's a specific server error
          // For authentication errors, don't fall back
          if (remoteError.toString().contains('User not found') || 
              remoteError.toString().contains('Invalid credentials')) {
            print('Authentication failed - not falling back to local');
            return Left(RemoteDatabaseFailure(message: remoteError.toString()));
          }
          
          print('Server error - falling back to local login...');
          
          // Remote failed - fallback to local only for server errors
          try {
            final localResult = await localDataSource.loginUser(username, password);
            print('Local login successful');
            return Right(localResult);
          } catch (localError) {
            print('Local login also failed: $localError');
            return Left(RemoteDatabaseFailure(message: remoteError.toString()));
          }
        }
      } else {
        // No network - use local only
        print('No network connection, attempting local login...');
        try {
          final localResult = await localDataSource.loginUser(username, password);
          print('Local login successful');
          return Right(localResult);
        } catch (localError) {
          print('Local login failed: $localError');
          return Left(LocalDatabaseFailure(message: localError.toString()));
        }
      }
    } catch (e) {
      print('Login unexpected error: $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      print('=== Register User Started ===');
      print('Username: ${user.username}');
      print('Email: ${user.email}');
      
      // Check network connectivity
      final isNetwork = await _isNetworkConnected();
      print('Network connected: $isNetwork');

      if (isNetwork) {
        // Network available - try remote first
        print('Attempting remote registration...');
        try {
          // Add timeout to prevent hanging
          await remoteDataSource.registerUser(user).timeout(
            const Duration(seconds: 8), // Reduced timeout for faster response
            onTimeout: () {
              throw Exception('Registration timeout - server not responding');
            },
          );
          print('Remote registration successful');
          
          // Cache successful registration locally
          await localDataSource.registerUser(user);
          print('Registration data cached locally');
          
          return const Right(null);
        } catch (remoteError) {
          print('Remote registration failed: $remoteError');
          
          // Don't fall back to local registration for new user registration
          // Local storage should only be used for offline access of existing users
          print('Registration failed - server not available. Please try again when server is running.');
          return Left(RemoteDatabaseFailure(message: 'Registration failed: ${remoteError.toString()}. Please ensure the server is running.'));
        }
      } else {
        // No network - don't allow registration
        print('No network connection - registration requires server connection');
        return Left(RemoteDatabaseFailure(message: 'Registration requires internet connection. Please check your network and try again.'));
      }
    } catch (e) {
      print('Registration unexpected error: $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      print('=== Get Current User Started ===');
      
      // Check network connectivity
      final isNetwork = await _isNetworkConnected();
      print('Network connected: $isNetwork');

      if (isNetwork) {
        // Network available - try remote first
        print('Attempting remote get current user...');
        try {
          final user = await remoteDataSource.getCurrentUser();
          print('Remote get current user successful');
          return Right(user);
        } catch (remoteError) {
          print('Remote get current user failed: $remoteError');
          // For getCurrentUser, we might not have a local fallback
          return Left(RemoteDatabaseFailure(message: remoteError.toString()));
        }
      } else {
        // No network - try local
        print('No network connection, attempting local get current user...');
        try {
          final user = await localDataSource.getCurrentUser();
          print('Local get current user successful');
          return Right(user);
        } catch (localError) {
          print('Local get current user failed: $localError');
          return Left(LocalDatabaseFailure(message: localError.toString()));
        }
      }
    } catch (e) {
      print('Get current user unexpected error: $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user, {String? currentPassword}) async {
    try {
      final isNetwork = await _isNetworkConnected();
      if (isNetwork) {
        final updatedUser = await remoteDataSource.updateUser(user, currentPassword: currentPassword);
        return Right(updatedUser);
      } else {
        return Left(RemoteDatabaseFailure(message: 'No network connection.'));
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}


//RemoteDataSource remoteDataSource =RemoteDatasource
//LocalDataSource localdatasource= LocalDataSource
//bool isNetwork=true
// bool addUser(User user){
//   // check for internte connectivity
//   if(isNetwork){
//     return remoteDatasource.regiterUser
//   }
// }

//same for all three cases


//class UserRepository{
// finalRemoteDataSource remoteDataSource;
// final LocalDataSource localDataSource;

 //UserRepository({
 //  required this.remoteDataSource;
 //  required this.localDataSource;
//  })
// }