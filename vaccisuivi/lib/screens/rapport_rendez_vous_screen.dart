import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RapportRendezVousScreen extends StatefulWidget {
  const RapportRendezVousScreen({Key? key}) : super(key: key);

  @override
  State<RapportRendezVousScreen> createState() => _RapportRendezVousScreenState();
}

class _RapportRendezVousScreenState extends State<RapportRendezVousScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _periodeSelectionnee = 'Ce mois';
  String _villageSelectionne = 'Tous';

  final List<String> _periodes = ['Cette semaine', 'Ce mois', 'Ce trimestre', 'Cette année'];
  final List<String> _villages = ['Tous', 'Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];

  Map<String, dynamic> _statistiques = {};

  @override
  void initState() {
    super.initState();
    _loadRapportRendezVous();
  }

  Future<void> _loadRapportRendezVous() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 1));
      _statistiques = _generateMockRendezVousData();
    } catch (e) {
      print('Erreur lors du chargement du rapport rendez-vous: $e');
      _statistiques = {};
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _generateMockRendezVousData() {
    return {
      'total_rendez_vous': 156,
      'rendez_vous_realises': 142,
      'rendez_vous_annules': 8,
      'rendez_vous_en_attente': 6,
      'taux_realisation': 91.0,
      'taux_presence': 94.2,
      'moyenne_retard': 12.5,
      'rendez_vous_urgents': 15,
      'rendez_vous_planifies': 23,
      'par_village': [
        {'village': 'Thiès', 'total': 45, 'realises': 42, 'taux': 93.3},
        {'village': 'Mbour', 'total': 38, 'realises': 35, 'taux': 92.1},
        {'village': 'Joal', 'total': 32, 'realises': 29, 'taux': 90.6},
        {'village': 'Ngaparou', 'total': 28, 'realises': 26, 'taux': 92.9},
        {'village': 'Popenguine', 'total': 13, 'realises': 10, 'taux': 76.9},
      ],
      'par_type_vaccin': [
        {'vaccin': 'DTC', 'rendez_vous': 45, 'realises': 42},
        {'vaccin': 'Rougeole', 'rendez_vous': 38, 'realises': 35},
        {'vaccin': 'Polio', 'rendez_vous': 32, 'realises': 30},
        {'vaccin': 'BCG', 'rendez_vous': 28, 'realises': 25},
        {'vaccin': 'Hépatite B', 'rendez_vous': 13, 'realises': 10},
      ],
      'evolution_hebdomadaire': [
        {'semaine': 'Sem 1', 'planifies': 25, 'realises': 23},
        {'semaine': 'Sem 2', 'planifies': 28, 'realises': 26},
        {'semaine': 'Sem 3', 'planifies': 22, 'realises': 20},
        {'semaine': 'Sem 4', 'planifies': 30, 'realises': 28},
        {'semaine': 'Sem 5', 'planifies': 26, 'realises': 25},
        {'semaine': 'Sem 6', 'planifies': 25, 'realises': 20},
      ],
      'raisons_annulation': [
        {'raison': 'Absence parent', 'count': 4},
        {'raison': 'Enfant malade', 'count': 2},
        {'raison': 'Problème transport', 'count': 1},
        {'raison': 'Oubli', 'count': 1},
      ],
      'agents_performance': [
        {'agent': 'Fatou Diop', 'rendez_vous': 45, 'realises': 43, 'taux': 95.6},
        {'agent': 'Moussa Sall', 'rendez_vous': 38, 'realises': 35, 'taux': 92.1},
        {'agent': 'Aissatou Ba', 'rendez_vous': 42, 'realises': 39, 'taux': 92.9},
        {'agent': 'Omar Diallo', 'rendez_vous': 31, 'realises': 25, 'taux': 80.6},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport Rendez-vous'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export du rapport rendez-vous à implémenter'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRapportRendezVous,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFiltres(),
                  const SizedBox(height: 20),
                  _buildStatistiquesGenerales(),
                  const SizedBox(height: 20),
                  _buildGraphiques(),
                  const SizedBox(height: 20),
                  _buildPerformanceParVillage(),
                  const SizedBox(height: 20),
                  _buildPerformanceParVaccin(),
                  const SizedBox(height: 20),
                  _buildPerformanceAgents(),
                  const SizedBox(height: 20),
                  _buildRaisonsAnnulation(),
                ],
              ),
            ),
    );
  }

  Widget _buildFiltres() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _periodeSelectionnee,
                decoration: InputDecoration(
                  labelText: 'Période',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _periodes.map((periode) {
                  return DropdownMenuItem(
                    value: periode,
                    child: Text(periode),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _periodeSelectionnee = value!;
                  });
                  _loadRapportRendezVous();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _villageSelectionne,
                decoration: InputDecoration(
                  labelText: 'Village',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _villages.map((village) {
                  return DropdownMenuItem(
                    value: village,
                    child: Text(village),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _villageSelectionne = value!;
                  });
                  _loadRapportRendezVous();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistiquesGenerales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistiques Générales des Rendez-vous',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard(
              'Total RDV',
              '${_statistiques['total_rendez_vous']}',
              Icons.schedule,
              Colors.blue,
            ),
            _buildStatCard(
              'Taux Réalisation',
              '${_statistiques['taux_realisation']}%',
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatCard(
              'RDV Réalisés',
              '${_statistiques['rendez_vous_realises']}',
              Icons.done_all,
              Colors.orange,
            ),
            _buildStatCard(
              'RDV Annulés',
              '${_statistiques['rendez_vous_annules']}',
              Icons.cancel,
              Colors.red,
            ),
            _buildStatCard(
              'RDV Urgents',
              '${_statistiques['rendez_vous_urgents']}',
              Icons.priority_high,
              Colors.purple,
            ),
            _buildStatCard(
              'Moyenne Retard',
              '${_statistiques['moyenne_retard']} min',
              Icons.access_time,
              Colors.indigo,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphiques() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Évolution Hebdomadaire',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rendez-vous planifiés vs réalisés'),
                    Icon(Icons.trending_up, color: Colors.green),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: _buildGraphiqueEvolution(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphiqueEvolution() {
    final evolution = _statistiques['evolution_hebdomadaire'] as List;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: evolution.map((semaine) {
        final maxPlanifies = evolution.map((e) => e['planifies'] as int).reduce((a, b) => a > b ? a : b);
        final maxRealises = evolution.map((e) => e['realises'] as int).reduce((a, b) => a > b ? a : b);
        final max = maxPlanifies > maxRealises ? maxPlanifies : maxRealises;
        
        final hauteurPlanifies = (semaine['planifies'] as int) / max * 150;
        final hauteurRealises = (semaine['realises'] as int) / max * 150;
        
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 18,
                  height: hauteurPlanifies,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 2),
                Container(
                  width: 18,
                  height: hauteurRealises,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              semaine['semaine'],
              style: const TextStyle(fontSize: 11),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPerformanceParVillage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance par Village',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Village')),
                DataColumn(label: Text('Total RDV')),
                DataColumn(label: Text('Réalisés')),
                DataColumn(label: Text('Taux (%)')),
                DataColumn(label: Text('Statut')),
              ],
              rows: (_statistiques['par_village'] as List).map((village) {
                final taux = village['taux'] as double;
                Color statutColor;
                String statutText;
                
                if (taux >= 95) {
                  statutColor = Colors.green;
                  statutText = 'Excellent';
                } else if (taux >= 85) {
                  statutColor = Colors.orange;
                  statutText = 'Bon';
                } else {
                  statutColor = Colors.red;
                  statutText = 'À améliorer';
                }
                
                return DataRow(
                  cells: [
                    DataCell(Text(village['village'])),
                    DataCell(Text('${village['total']}')),
                    DataCell(Text('${village['realises']}')),
                    DataCell(Text('${village['taux']}%')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statutColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statutColor),
                        ),
                        child: Text(
                          statutText,
                          style: TextStyle(
                            color: statutColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceParVaccin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance par Type de Vaccin',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: (_statistiques['par_type_vaccin'] as List).map((vaccin) {
                final taux = (vaccin['realises'] as int) / (vaccin['rendez_vous'] as int) * 100;
                return _buildVaccinPerformance(vaccin['vaccin'], vaccin['rendez_vous'], vaccin['realises'], taux);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVaccinPerformance(String nom, int total, int realises, double taux) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              nom,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: taux / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$realises/$total (${taux.toStringAsFixed(1)}%)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAgents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance des Agents',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Agent')),
                DataColumn(label: Text('Total RDV')),
                DataColumn(label: Text('Réalisés')),
                DataColumn(label: Text('Taux (%)')),
                DataColumn(label: Text('Performance')),
              ],
              rows: (_statistiques['agents_performance'] as List).map((agent) {
                final taux = agent['taux'] as double;
                Color performanceColor;
                String performanceText;
                
                if (taux >= 95) {
                  performanceColor = Colors.green;
                  performanceText = 'Excellent';
                } else if (taux >= 85) {
                  performanceColor = Colors.orange;
                  performanceText = 'Bon';
                } else {
                  performanceColor = Colors.red;
                  performanceText = 'À améliorer';
                }
                
                return DataRow(
                  cells: [
                    DataCell(Text(agent['agent'])),
                    DataCell(Text('${agent['rendez_vous']}')),
                    DataCell(Text('${agent['realises']}')),
                    DataCell(Text('${agent['taux']}%')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: performanceColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: performanceColor),
                        ),
                        child: Text(
                          performanceText,
                          style: TextStyle(
                            color: performanceColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRaisonsAnnulation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Raisons d\'Annulation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: (_statistiques['raisons_annulation'] as List).map((raison) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          raison['raison'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          '${raison['count']}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
} 