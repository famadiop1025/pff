import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/enfant.dart';
import '../services/data_service.dart';

class FicheEnfantScreen extends StatefulWidget {
  final Enfant enfant;
  const FicheEnfantScreen({super.key, required this.enfant});

  @override
  State<FicheEnfantScreen> createState() => _FicheEnfantScreenState();
}

class _FicheEnfantScreenState extends State<FicheEnfantScreen> {
  late Enfant enfant;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    enfant = widget.enfant;
  }

  void _ajouterVaccin() async {
    final TextEditingController _nomVaccinController = TextEditingController();
    DateTime? _dateVaccin;
    String? _statut = 'reçu';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un vaccin reçu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomVaccinController,
                decoration: const InputDecoration(labelText: 'Nom du vaccin'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _statut,
                items: [
                  DropdownMenuItem(value: 'reçu', child: Text('Reçu')),
                  DropdownMenuItem(value: 'retard', child: Text('Retard')),
                ],
                onChanged: (v) => _statut = v,
                decoration: const InputDecoration(labelText: 'Statut'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.date_range),
                label: Text(_dateVaccin == null ? 'Date d\'administration' : DateFormat('dd/MM/yyyy').format(_dateVaccin!)),
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now.subtract(const Duration(days: 365*5)),
                    lastDate: now,
                    locale: const Locale('fr', 'FR'),
                  );
                  if (picked != null) {
                    setState(() { _dateVaccin = picked; });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nomVaccinController.text.trim().isEmpty || _dateVaccin == null) return;
                final vaccin = Vaccin(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  nom: _nomVaccinController.text.trim(),
                  dateAdministration: _dateVaccin!,
                  statut: _statut!,
                );
                _dataService.ajouterVaccin(enfant.id, vaccin);
                setState(() {
                  enfant = _dataService.enfants.firstWhere((e) => e.id == enfant.id);
                });
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche enfant', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Infos de base
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: enfant.sexe == 'M' ? Colors.blue : Colors.pink,
                      child: Icon(enfant.sexe == 'M' ? Icons.boy : Icons.girl, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(enfant.nom, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(enfant.village, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(width: 16),
                              Icon(Icons.cake, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${enfant.age} ans', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.vaccines, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${enfant.historiqueVaccins.length} vaccins reçus', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Prochain vaccin
            if (enfant.prochainVaccin != null)
              Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.orange),
                  title: Text('Prochain vaccin : ${enfant.prochainVaccin!.nom}'),
                  subtitle: Text('Date : ${DateFormat('dd/MM/yyyy').format(enfant.prochainVaccin!.dateAdministration)}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
                ),
              ),
            if (enfant.prochainVaccin == null)
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Aucun vaccin à venir'),
                ),
              ),
            const SizedBox(height: 20),
            // Historique vaccins
            const Text('Historique des vaccins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            if (enfant.historiqueVaccins.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Aucun vaccin reçu.'),
                ),
              ),
            if (enfant.historiqueVaccins.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enfant.historiqueVaccins.length,
                itemBuilder: (context, i) {
                  final vaccin = enfant.historiqueVaccins[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.vaccines, color: vaccin.statut == 'reçu' ? Colors.green : Colors.red),
                      title: Text(vaccin.nom),
                      subtitle: Text('Date : ${DateFormat('dd/MM/yyyy').format(vaccin.dateAdministration)}'),
                      trailing: Text(
                        vaccin.statut == 'reçu' ? 'Reçu' : 'Retard',
                        style: TextStyle(
                          color: vaccin.statut == 'reçu' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Ajouter un vaccin reçu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _ajouterVaccin,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 