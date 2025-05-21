import 'dart:convert';

import 'package:flutter/material.dart';
import '../controllers/airport_sim_controller.dart';
import '../models/airport_sim_model.dart';

class AirportSimView extends StatefulWidget {
  final String token;
  const AirportSimView({required this.token, Key? key}) : super(key: key);

  @override
  State<AirportSimView> createState() => _AirportSimViewState();
}

class _AirportSimViewState extends State<AirportSimView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Vente'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Passport'),
            Tab(text: 'CIN'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PassportForm(token: widget.token),
          _CinForm(token: widget.token),
        ],
      ),
    );
  }
}

// =================== CIN Form ===================

class _CinForm extends StatefulWidget {
  final String token;
  const _CinForm({required this.token});

  @override
  State<_CinForm> createState() => _CinFormState();
}

class _CinFormState extends State<_CinForm> {
  final _cinController = TextEditingController();
  final _iccIdController = TextEditingController();
  late AirportSimController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AirportSimController(AirportSimModel(iccId: '', type: 3));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await _controller.pickFrontCinImage();
                    setState(() {});
                  },
                  child: Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: _controller.model.frontCinImage != null
                        ? Image.memory(
                            base64Decode(_controller.model.frontCinImage!),
                            fit: BoxFit.cover,
                          )
                        : const Center(child: Text("CIN Recto")),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await _controller.pickBackCinImage();
                    setState(() {});
                  },
                  child: Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: _controller.model.backCinImage != null
                        ? Image.memory(
                            base64Decode(_controller.model.backCinImage!),
                            fit: BoxFit.cover,
                          )
                        : const Center(child: Text("CIN Verso")),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _cinController,
            decoration: const InputDecoration(
              labelText: 'CIN',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _controller.model.cin = val,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _iccIdController,
            decoration: const InputDecoration(
              labelText: 'ICC-ID',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _controller.model.iccId = val,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("ENVOYER"),
              onPressed: () async {
                final success = await _controller.submit(
                  widget.token,
                  '1',
                  '36.8',
                  '10.1',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Vente soumise avec succès'
                        : 'Échec de la soumission'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =================== Passport Form (Unchanged) ===================

class _PassportForm extends StatefulWidget {
  final String token;
  const _PassportForm({required this.token});

  @override
  State<_PassportForm> createState() => _PassportFormState();
}

class _PassportFormState extends State<_PassportForm> {
  final _passportController = TextEditingController();
  final _iccIdController = TextEditingController();
  late AirportSimController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AirportSimController(AirportSimModel(iccId: '', type: 4));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await _controller.pickContractImage();
              setState(() {});
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.grey[300],
              ),
              child: _controller.model.contractImage != null
                  ? Image.memory(base64Decode(_controller.model.contractImage!), fit: BoxFit.cover)
                  : const Center(child: Text('Contrat')),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _iccIdController,
            decoration: const InputDecoration(
              labelText: 'ICC-ID',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _controller.model.iccId = val,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passportController,
            decoration: const InputDecoration(
              labelText: 'N° Passeport (optionnel)',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _controller.model.passportNumber = val,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("ENVOYER"),
              onPressed: () async {
                final success = await _controller.submit(
                  widget.token,
                  '1',
                  '36.8',
                  '10.1',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Vente soumise avec succès'
                        : 'Échec de la soumission'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
