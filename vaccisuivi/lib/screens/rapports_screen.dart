import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RapportsScreen extends StatefulWidget {
  const RapportsScreen({Key? key}) : super(key: key);

  @override
  State<RapportsScreen> createState() => _RapportsScreenState();
}

class _RapportsScreenState extends State<RapportsScreen> {
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
    _loadRapports();
  }

  Future<void> _loadRapports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API pour les rapports
      // TODO: Remplacer par un vrai appel API quand l'endpoint sera créé
      await Future.delayed(Duration(seconds: 1));
      
      _statistiques = _generateMockStatistiques();
      
    } catch (e) {
      print('Erreur lors du chargement des rapports: $e');
      _statistiques = {};
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _generateMockStatistiques() {
    return {
      'total_enfants': 1250,
      'enfants_vaccines': 1180,
      'taux_couverture': 94.4,
      'rendez_vous_planifies': 45,
      'rendez_vous_realises': 38,
      'taux_realisation': 84.4,
      'nouveaux_inscrits': 23,
      'agents_actifs': 8,
      'parents_actifs': 156,
      'vaccins_populaires': [
        {'nom': 'DTC', 'count': 45},
        {'nom': 'Rougeole', 'count': 38},
        {'nom': 'Polio', 'count': 32},
        {'nom': 'BCG', 'count': 28},
      ],
      'evolution_mensuelle': [
        {'mois': 'Jan', 'enfants': 120, 'vaccinations': 95},
        {'mois': 'Fév', 'enfants': 135, 'vaccinations': 108},
        {'mois': 'Mar', 'enfants': 142, 'vaccinations': 118},
        {'mois': 'Avr', 'enfants': 128, 'vaccinations': 105},
        {'mois': 'Mai', 'enfants': 145, 'vaccinations': 125},
        {'mois': 'Juin', 'enfants': 138, 'vaccinations': 115},
      ],
      'par_village': [
        {'village': 'Thiès', 'enfants': 320, 'taux': 96.2},
        {'village': 'Mbour', 'enfants': 280, 'taux': 94.1},
        {'village': 'Joal', 'enfants': 245, 'taux': 92.8},
        {'village': 'Ngaparou', 'enfants': 215, 'taux': 93.5},
        {'village': 'Popenguine', 'enfants': 190, 'taux': 95.3},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports et Statistiques'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implémenter l'export des rapports
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export des rapports à implémenter'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRapports,
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
                  // Filtres
                  _buildFiltres(),
                  const SizedBox(height: 20),

                  // Statistiques générales
                  _buildStatistiquesGenerales(),
                  const SizedBox(height: 20),

                  // Graphiques
                  _buildGraphiques(),
                  const SizedBox(height: 20),

                  // Tableau par village
                  _buildTableauParVillage(),
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
                  _loadRapports();
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
                  _loadRapports();
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
          'Statistiques Générales',
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
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Total Enfants',
              '${_statistiques['total_enfants']}',
              Icons.child_care,
              Colors.blue,
            ),
            _buildStatCard(
              'Taux Couverture',
              '${_statistiques['taux_couverture']}%',
              Icons.vaccines,
              Colors.green,
            ),
            _buildStatCard(
              'RDV Réalisés',
              '${_statistiques['rendez_vous_realises']}/${_statistiques['rendez_vous_planifies']}',
              Icons.schedule,
              Colors.orange,
            ),
            _buildStatCard(
              'Nouveaux Inscrits',
              '${_statistiques['nouveaux_inscrits']}',
              Icons.person_add,
              Colors.purple,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
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
          'Évolution Mensuelle',
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
                    const Text('Enfants inscrits vs Vaccinations'),
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
        const SizedBox(height: 20),
        
        const Text(
          'Vaccins les Plus Populaires',
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
                ...(_statistiques['vaccins_populaires'] as List).map((vaccin) {
                  return _buildVaccinBar(vaccin['nom'], vaccin['count']);
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphiqueEvolution() {
    final evolution = _statistiques['evolution_mensuelle'] as List;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: evolution.map((mois) {
        final maxEnfants = evolution.map((e) => e['enfants'] as int).reduce((a, b) => a > b ? a : b);
        final maxVaccinations = evolution.map((e) => e['vaccinations'] as int).reduce((a, b) => a > b ? a : b);
        final max = maxEnfants > maxVaccinations ? maxEnfants : maxVaccinations;
        
        final hauteurEnfants = (mois['enfants'] as int) / max * 150;
        final hauteurVaccinations = (mois['vaccinations'] as int) / max * 150;
        
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: hauteurEnfants,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 2),
                Container(
                  width: 20,
                  height: hauteurVaccinations,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              mois['mois'],
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildVaccinBar(String nom, int count) {
    final maxCount = (_statistiques['vaccins_populaires'] as List)
        .map((v) => v['count'] as int)
        .reduce((a, b) => a > b ? a : b);
    
    final pourcentage = count / maxCount;
    
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
              value: pourcentage,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$count',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTableauParVillage() {
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
                DataColumn(label: Text('Enfants')),
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
                } else if (taux >= 90) {
                  statutColor = Colors.orange;
                  statutText = 'Bon';
                } else {
                  statutColor = Colors.red;
                  statutText = 'À améliorer';
                }
                
                return DataRow(
                  cells: [
                    DataCell(Text(village['village'])),
                    DataCell(Text('${village['enfants']}')),
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
} 