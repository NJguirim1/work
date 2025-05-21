import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  _StockManagementScreenState createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final String apiBaseUrl = "https://preprod-orange.ernst.tn";
  List<String> iccIds = [];
  String selectedAgent = "";
  List<String> agents = [];
  String stockState = "Initial"; // Default stock filter
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchIccIds();
    fetchAgents();
  }

  // Fetch the user's IccIds
  Future<void> fetchIccIds() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse("$apiBaseUrl/Main/Api/Stock/GetMyIccIds"),
      headers: {"Authorization": "Bearer YOUR_TOKEN"},
    );
    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => iccIds = List<String>.from(data["iccIds"]));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching IccIds"))
      );
    }
  }

  // Fetch available agents for stock allocation
  Future<void> fetchAgents() async {
    final response = await http.get(
      Uri.parse("$apiBaseUrl/Main/Api/Stock/GetTeamAgents"),
      headers: {"Authorization": "Bearer YOUR_TOKEN"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => agents = List<String>.from(data["agents"]));
    }
  }

  // Assign stock to an agent
  Future<void> assignStock() async {
    if (selectedAgent.isEmpty || iccIds.isEmpty) return;

    final requestData = {
      "TerrainAgentId": selectedAgent,
      "IccIds": iccIds,
    };

    final response = await http.post(
      Uri.parse("$apiBaseUrl/Main/Api/Stock/NewStockAllocation"),
      headers: {
        "Authorization": "Bearer YOUR_TOKEN",
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stock allocated successfully!"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error allocating stock"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedAgent.isNotEmpty ? selectedAgent : null,
              hint: const Text("Select Agent"),
              items: agents.map((agent) {
                return DropdownMenuItem(value: agent, child: Text(agent));
              }).toList(),
              onChanged: (value) => setState(() => selectedAgent = value!),
            ),

            const SizedBox(height: 20),
            const Text("Filter Stock:"),
            DropdownButton<String>(
              value: stockState,
              items: ["Initial", "Sold", "Failed"].map((state) {
                return DropdownMenuItem(value: state, child: Text(state));
              }).toList(),
              onChanged: (value) => setState(() => stockState = value!),
            ),

            const SizedBox(height: 20),
            isLoading ? const CircularProgressIndicator() :
            Expanded(
              child: ListView.builder(
                itemCount: iccIds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("IccId: ${iccIds[index]}"),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: assignStock,
              child: const Text("Allocate Stock to Agent"),
            ),
          ],
        ),
      ),
    );
  }
}
