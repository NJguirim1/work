import 'package:flutter_application_1/models/UnsentSale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnsentSaleStorage {
  static const String _key = 'unsent_sales_list';

  Future<List<UnsentSale>> getAllSales() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_key);
    if (jsonList == null) return [];
    return jsonList.map((jsonStr) => UnsentSale.fromJson(jsonStr)).toList();
  }

  Future<void> saveSale(UnsentSale sale) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = prefs.getStringList(_key) ?? [];
    jsonList.add(sale.toJson());
    await prefs.setStringList(_key, jsonList);
  }

  Future<void> deleteSale(UnsentSale sale) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = prefs.getStringList(_key) ?? [];
    jsonList.removeWhere((jsonStr) {
      final s = UnsentSale.fromJson(jsonStr);
      return s.dateTimeSaved == sale.dateTimeSaved &&
          s.iccid == sale.iccid; // match criteria
    });
    await prefs.setStringList(_key, jsonList);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
