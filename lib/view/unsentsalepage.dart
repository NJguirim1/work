import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnsentSalesPage extends StatefulWidget {
  @override
  _UnsentSalesPageState createState() => _UnsentSalesPageState();
}

class _UnsentSalesPageState extends State<UnsentSalesPage> {
  List<Map<String, dynamic>> unsentSales = [];

  @override
  void initState() {
    super.initState();
    _loadUnsentSales();
  }

  Future<void> _loadUnsentSales() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('unsent_sales') ?? [];

    final decoded = list.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();

    setState(() {
      unsentSales = decoded;
    });
  }

  Future<void> _deleteSale(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('unsent_sales') ?? [];

    list.removeAt(index);
    await prefs.setStringList('unsent_sales', list);

    setState(() {
      unsentSales.removeAt(index);
    });
  }

  Future<void> _clearAllSales() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('unsent_sales');

    setState(() {
      unsentSales.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Toutes les ventes ont été supprimées')),
    );
  }

  String _fileName(dynamic value) {
    if (value == null) return '–';
    try {
      return File(value).uri.pathSegments.last;
    } catch (_) {
      return value.toString().substring(0, 10) + '...';
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tout supprimer ?'),
        content: const Text('Voulez‑vous vraiment supprimer toutes les ventes non envoyées ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllSales();
            },
            child: const Text('Supprimer tout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleCard(Map<String, dynamic> sale, int index) {
    final isForeign = sale['type'] == 2;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(isForeign
            ? 'Passeport: ${sale['passportNumber'] ?? '–'}'
            : 'CIN: ${sale['cin'] ?? '–'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ICCID: ${sale['iccId'] ?? '–'}'),
            if (!isForeign) ...[
              Text('Front CIN: ${_fileName(sale['frontCinImagePath'])}'),
              Text('Back CIN: ${_fileName(sale['backCinImagePath'])}'),
              Text('Contrat: ${_fileName(sale['contractImagePath'])}'),
            ],
            if (isForeign) ...[
              Text('Passeport 1: ${_fileName(sale['foreignPassportImage1'])}'),
              Text('Passeport 2: ${_fileName(sale['foreignPassportImage2'])}'),
              Text('Contrat: ${_fileName(sale['foreignContratImage'])}'),
            ],
            Text('Type: ${isForeign ? "Étranger" : "CIN"}'),
            Text('Date: ${sale['dateEnvoi'] ?? '–'}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteSale(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À envoyer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: unsentSales.isNotEmpty ? _showClearConfirmation : null,
          ),
        ],
      ),
      body: unsentSales.isEmpty
          ? const Center(child: Text('Aucune vente en attente'))
          : ListView.builder(
              itemCount: unsentSales.length,
              itemBuilder: (context, index) {
                return _buildSaleCard(unsentSales[index], index);
              },
            ),
    );
  }
}
