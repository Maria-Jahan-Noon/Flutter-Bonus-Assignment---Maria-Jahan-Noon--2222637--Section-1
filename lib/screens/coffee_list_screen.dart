import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/coffee_records_model.dart';
import '../services/coffee_state_management.dart';
import 'add_coffee_screen.dart';

class CoffeeListScreen extends StatelessWidget {
  const CoffeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CoffeeStateManagement coffeeManager = CoffeeStateManagement();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maria's Brew Journal",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8D6E63),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCoffeeScreen()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Log New Brew", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<List<CoffeeRecordsModel>>(
        stream: coffeeManager.getRecordsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.coffee_maker, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text("No brews logged yet.",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            );
          }

          final records = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return _buildCoffeeCard(context, record, coffeeManager);
            },
          );
        },
      ),
    );
  }

  Widget _buildCoffeeCard(BuildContext context, CoffeeRecordsModel record,
      CoffeeStateManagement manager) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(record.beanOrigin,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      5,
                      (i) => Icon(Icons.star,
                          size: 20,
                          color: i < record.rating
                              ? Colors.amber
                              : Colors.grey[300])),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Roast: ${record.roastProfile} | Brew: ${record.brewMethod}",
                style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text("Notes: ${record.tastingNotes}",
                style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('MMM dd, yyyy').format(record.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => manager.deleteRecord(record.id),
              ),
            )
          ],
        ),
      ),
    );
  }
}