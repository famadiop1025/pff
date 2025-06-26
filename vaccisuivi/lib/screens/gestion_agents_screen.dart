import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GestionAgentsScreen extends StatefulWidget {
  const GestionAgentsScreen({Key? key}) : super(key: key);

  @override
  State<GestionAgentsScreen> createState() => _GestionAgentsScreenState();
}

class _GestionAgentsScreenState extends State<GestionAgentsScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _agents = [];
  bool _isLoading = true;
  String _filtreVillage = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _villages = ['Tous', 'Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAgents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API pour les agents
      // TODO: Remplacer par un vrai appel API quand l'endpoint sera créé
      await Future.delayed(Duration(seconds: 1));
      
      _agents = _generateMockAgents();
      
    } catch (e) {
      print('Erreur lors du chargement des agents: $e');
      _agents = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockAgents() {
    return [
      {
        'id': '1',
        'username': 'aissatou.diallo',
        'full_name': 'Aissatou Diallo',
        'email': 'aissatou.diallo@email.com',
        'village': 'Joal',
        'date_embauche': '2024-01-10',
        'statut': 'actif',
        'enfants_vaccines': 45,
        'rendez_vous_planifies': 12,
        'specialite': 'Vaccination infantile',
        'telephone': '+221 77 123 45 67',
      },
      {
        'id': '2',
        'username': 'mamadou.ndiaye',
        'full_name': 'Mamadou Ndiaye',
        'email': 'mamadou.ndiaye@email.com',
        'village': 'Thiès',
        'date_embauche': '2024-02-15',
        'statut': 'actif',
        'enfants_vaccines': 38,
        'rendez_vous_planifies': 8,
        'specialite': 'Suivi vaccinal',
        'telephone': '+221 76 234 56 78',
      },
      {
        'id': '3',
        'username': 'fatou.sene',
        'full_name': 'Fatou Sene',
        'email': 'fatou.sene@email.com',
        'village': 'Mbour',
        'date_embauche': '2024-01-20',
        'statut': 'actif',
        'enfants_vaccines': 52,
        'rendez_vous_planifies': 15,
        'specialite': 'Vaccination et conseil',
        'telephone': '+221 77 345 67 89',
      },
      {
        'id': '4',
        'username': 'ibrahim.traore',
        'full_name': 'Ibrahim Traore',
        'email': 'ibrahim.traore@email.com',
        'village': 'Ngaparou',
        'date_embauche': '2024-03-01',
        'statut': 'inactif',
        'enfants_vaccines': 0,
        'rendez_vous_planifies': 0,
        'specialite': 'Vaccination infantile',
        'telephone': '+221 76 456 78 90',
      },
    ];
  }

  List<Map<String, dynamic>> _getAgentsFiltres() {
    List<Map<String, dynamic>> agents = _agents;

    // Filtre par village
    if (_filtreVillage != 'Tous') {
      agents = agents.where((agent) => agent['village'] == _filtreVillage).toList();
    }

    // Filtre par recherche
    if (_searchController.text.isNotEmpty) {
      agents = agents.where((agent) =>
          agent['full_name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          agent['username'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          agent['email'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    return agents;
  }

  Color _getStatutColor(String statut) {
    return statut == 'actif' ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final agentsFiltres = _getAgentsFiltres();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Agents'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implémenter l'ajout d'agent
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité d\'ajout d\'agent à implémenter'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAgents,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF4CAF50),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Rechercher un agent...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtreVillage,
                    decoration: InputDecoration(
                      labelText: 'Village',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _villages.map((village) {
                      return DropdownMenuItem(
                        value: village,
                        child: Text(village),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filtreVillage = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Statistiques
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFE8F5E8),
            child: Row(
              children: [
                Icon(Icons.medical_services, color: const Color(0xFF4CAF50), size: 16),
                const SizedBox(width: 8),
                Text(
                  '${agentsFiltres.length} agent(s) trouvé(s)',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Liste des agents
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : agentsFiltres.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun agent trouvé',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: agentsFiltres.length,
                        itemBuilder: (context, index) {
                          final agent = agentsFiltres[index];
                          return _buildAgentCard(agent);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec nom et statut
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF4CAF50),
                  child: const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agent['full_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        agent['specialite'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatutColor(agent['statut']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatutColor(agent['statut'])),
                  ),
                  child: Text(
                    agent['statut'].toUpperCase(),
                    style: TextStyle(
                      color: _getStatutColor(agent['statut']),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Informations de l'agent
            _buildInfoRow(Icons.email, 'Email', agent['email']),
            _buildInfoRow(Icons.phone, 'Téléphone', agent['telephone']),
            _buildInfoRow(Icons.location_on, 'Village', agent['village']),
            _buildInfoRow(Icons.calendar_today, 'Embauché le', agent['date_embauche']),

            const SizedBox(height: 12),

            // Statistiques de performance
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Enfants vaccinés',
                    '${agent['enfants_vaccines']}',
                    Icons.vaccines,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'RDV planifiés',
                    '${agent['rendez_vous_planifies']}',
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter la modification
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Modification de ${agent['full_name']}'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter la désactivation/activation
                      final newStatut = agent['statut'] == 'actif' ? 'inactif' : 'actif';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Statut de ${agent['full_name']} changé à $newStatut'),
                          backgroundColor: newStatut == 'actif' ? Colors.green : Colors.orange,
                        ),
                      );
                    },
                    icon: Icon(agent['statut'] == 'actif' ? Icons.block : Icons.check_circle),
                    label: Text(agent['statut'] == 'actif' ? 'Désactiver' : 'Activer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: agent['statut'] == 'actif' ? Colors.red : Colors.green,
                      side: BorderSide(
                        color: agent['statut'] == 'actif' ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 