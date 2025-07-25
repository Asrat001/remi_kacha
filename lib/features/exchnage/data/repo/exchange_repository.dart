import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/utils/database_service.dart';
import '../models/exchange_rate_model.dart';


class ExchangeRepository{
  final dbHelper = DatabaseService.instance;



  Future<void> fetchAndInsertExchangeRates() async {
    final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/USD'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;
      final timestamp = DateTime.now().toIso8601String();

      final db = await dbHelper.database;

      // Delete existing exchange rates
      await dbHelper.clearTableIfExists('exchange_rates');

      for (final entry in rates.entries) {
        await db.insert('exchange_rates', {
          'currency_code': entry.key,
          'rate': entry.value,
          'timestamp': timestamp,
        });
      }

      print('✅ Exchange rates inserted successfully');
    } else {
      print('❌ Failed to fetch exchange rates: ${response.body}');
    }
  }


  Future<double?> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final db = await dbHelper.database;

    // Get rates from DB
    final fromRateResult = await db.query(
      'exchange_rates',
      where: 'currency_code = ?',
      whereArgs: [fromCurrency],
      limit: 1,
    );

    final toRateResult = await db.query(
      'exchange_rates',
      where: 'currency_code = ?',
      whereArgs: [toCurrency],
      limit: 1,
    );

    if (fromRateResult.isNotEmpty && toRateResult.isNotEmpty) {
      final fromRate = fromRateResult.first['rate'] as num;
      final toRate = toRateResult.first['rate'] as num;

      final convertedAmount = (amount / fromRate) * toRate;
      return convertedAmount;
    }

    return null; // If rate not found
  }

  Future<List<ExchangeRate>> getAllExchangeRates() async {
    final db = await dbHelper.database;
    final results = await db.query(
      'exchange_rates',
      orderBy: 'currency_code ASC',
    );
    return results.map((map) => ExchangeRate.fromMap(map)).toList();
  }


}