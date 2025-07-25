import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:remi_kacha/core/error/failure.dart';
import 'package:remi_kacha/core/utils/database_service.dart';
import 'package:remi_kacha/features/auth/data/models/user_model.dart';
import '../models/user_request_model.dart';

class UserRepository {
  final dbHelper = DatabaseService.instance;

  String _hash(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  Future<Either<Failure, int>> registerUser({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final db = await dbHelper.database;
    // Check if a user with the phone number already exists
      final existingUsers = await db.query(
        'users',
        where: 'phoneNumber = ?',
        whereArgs: [phoneNumber],
      );

      if (existingUsers.isNotEmpty) {
        // User already exists, return a failure
        return Left(DatabaseFailure('User with phone number $phoneNumber already exists'));
      }
      // Proceed with registration if no user is found

      final user = UserRequestModel(
        name: "",
        email: "",
        phoneNumber: phoneNumber,
        password: _hash(password),
        pin: "",
        currency: "USD",//default currency for our user they can also add other wallet with different currency later
      );
      final id = await db.insert('users', user.toMap());

      // 2. Create wallet for this user to simulate  transactions
      await db.insert('wallets', {
        'user_id': id,
        'balance': 20000.0,
        'currency': 'USD',
      });

      return Right(id);
    } catch (e) {
       return Left(DatabaseFailure('Failed to register user into Database'));
    }

  }

 Future<Either<Failure, UserModel>>  login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final db = await dbHelper.database;
      final hashed = _hash(password);
      await Future.delayed(Duration(milliseconds: 600));
      final result = await db.query(
        'users',
        where: 'phoneNumber = ? AND password = ?',
        whereArgs: [phoneNumber, hashed],
      );

      if (result.isNotEmpty) {
        return Right(UserModel.fromMap(result.first));
      } else {
        return Left(AuthFailure('Invalid phone or password'));
      }
    } catch (e) {
      return Left(DatabaseFailure('Login failed: ${e.toString()}'));
    }
  }

  Future<Either<Failure, int>> updateUserById({
    required int userId,
    required String name,
    required email,
    required  pin,
  }) async {
    try {
      final db = await dbHelper.database;
      final hashedPin = _hash(pin);
      // Build a map with only the fields provided (non-null)
      final Map<String, dynamic> updatedFields = {};
      updatedFields['name'] = name;
      updatedFields['email'] = email;
      updatedFields['pin'] = hashedPin;

      final result = await db.update(
        'users',
        updatedFields,
        where: 'id = ?',
        whereArgs: [userId],
      );
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update user: ${e.toString()}'));
    }
  }




  Future<Either<Failure, bool>> verifyTransactionPin(
    int userId,
    String enteredPin,
  ) async {
    try {
      final db = await dbHelper.database;
      final hashedPin = _hash(enteredPin);

      final result = await db.query(
        'users',
        columns: ['id'],
        where: 'id = ? AND pin = ?',
        whereArgs: [userId, hashedPin],
      );

      return Right(result.isNotEmpty);
    } catch (e) {
      return Left(DatabaseFailure('PIN verification failed: ${e.toString()}'));
    }
  }
}
