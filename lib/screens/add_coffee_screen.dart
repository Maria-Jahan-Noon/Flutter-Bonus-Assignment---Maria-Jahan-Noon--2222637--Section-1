import 'package:flutter/material.dart';
import '../models/coffee_records_model.dart';
import '../services/coffee_state_management.dart';

class AddCoffeeScreen extends StatefulWidget {
  const AddCoffeeScreen({super.key});

  @override
  State<AddCoffeeScreen> createState() => _AddCoffeeScreenState();
}

class _AddCoffeeScreenState extends State<AddCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _originController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedRoast = "Medium";
  String _selectedMethod = "Espresso";
  int _rating = 3;

  final List<String> _roasts = ["Light", "Medium", "Dark"];
  final List<String> _methods = [
    "Espresso",
    "V60 Pour Over",
    "French Press",
    "AeroPress",
    "Cold Brew"
  ];

  @override
  Widget build(BuildContext context) {
    final manager = CoffeeStateManagement();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Log a New Brew", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _originController,
                decoration:
                    const InputDecoration(labelText: "Bean Origin (e.g., Colombia)"),
                validator: (value) =>
                    value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRoast,
                items: _roasts
                    .map((r) => DropdownMenuItem(value: r, child: Text("$r Roast")))
                    .toList(),
                onChanged: (val) => setState(() => _selectedRoast = val!),
                decoration: const InputDecoration(labelText: "Roast Profile"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                items: _methods
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedMethod = val!),
                decoration: const InputDecoration(labelText: "Brewing Method"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: "Tasting Notes"),
              ),
              const SizedBox(height: 24),
              const Text("Rating:", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E342E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newRecord = CoffeeRecordsModel(
                        id: "",
                        beanOrigin: _originController.text,
                        roastProfile: _selectedRoast,
                        brewMethod: _selectedMethod,
                        tastingNotes: _notesController.text,
                        rating: _rating,
                        createdAt: DateTime.now(),
                      );
                      await manager.addCoffeeRecord(newRecord);
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text("Save to Firebase",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}