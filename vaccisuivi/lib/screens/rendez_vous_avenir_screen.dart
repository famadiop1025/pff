import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/enfant.dart';

class RendezVousAvenirScreen extends StatefulWidget {
  const RendezVousAvenirScreen({Key? key}) : super(key: key);

  @override
  State<RendezVousAvenirScreen> createState() => _RendezVousAvenirScreenState();
}

class _RendezVousAvenirScreenState extends State<RendezVousAvenirScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _rendezVous = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRendezVous();
  }

  Future<void> _loadRendezVous() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API pour les rendez-vous à venir
      // TODO: Remplacer par un vrai appel API quand l'endpoint sera créé
      await Future.delayed(Duration(seconds: 1));
      
      _rendezVous = _generateMockRendezVous();
      
    } catch (e) {
      print('Erreur lors du chargement des rendez-vous: $e');
      _rendezVous = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockRendezVous() {
    final now = DateTime.now();
    return [
      {
        'id': '1',
        'enfant': {
          'nom': 'Fatou Diop',
          'age': 2,
          'village': 'Thiès',
        },
        'vaccin': 'DTC',
        'date_prevue': now.add(Duration(days: 3)),
        'lieu': 'Centre de santé de Thiès',
        'notes': 'Apporter le carnet de vaccination',
        'priorite': 'normale',
      },
      {
        'id': '2',
        'enfant': {
          'nom': 'Moussa Sall',
          'age': 1,
          'village': 'Mbour',
        },
        'vaccin': 'Rougeole',
        'date_prevue': now.add(Duration(days: 7)),
        'lieu': 'Centre de santé de Mbour',
        'notes': 'Vaccin obligatoire',
        'priorite': 'normale',
      },
      {
        'id': '3',
        'enfant': {
          'nom': 'Aissatou Diallo',
          'age': 3,
          'village': 'Joal',
        },
        'vaccin': 'Polio',
        'date_prevue': now.add(Duration(days: 14)),
        'lieu': 'Centre de santé de Joal',
        'notes': 'Rappel de vaccination',
        'priorite': 'normale',
      },
    ];
  }

  Color _getPrioriteColor(String priorite) {
    switch (priorite) {
      case 'urgente':
        return Colors.red;
      case 'elevee':
        return Colors.orange;
      case 'normale':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getJoursRestants(DateTime datePrevue) {
    final difference = datePrevue.difference(DateTime.now()).inDays;
    if (difference == 0) {
      return 'Aujourd\'hui';
    } else if (difference == 1) {
      return 'Demain';
    } else if (difference < 0) {
      return 'En retard de ${difference.abs()} jour(s)';
    } else {
      return 'Dans $difference jour(s)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendez-vous à Venir'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRendezVous,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rendezVous.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 64,
                        color: Colors.green,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun rendez-vous à venir',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tous les vaccins sont à jour !',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRendezVous,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _rendezVous.length,
                    itemBuilder: (context, index) {
                      final rendezVous = _rendezVous[index];
                      return _buildRendezVousCard(rendezVous);
                    },
                  ),
                ),
    );
  }

  Widget _buildRendezVousCard(Map<String, dynamic> rendezVous) {
    final enfant = rendezVous['enfant'] as Map<String, dynamic>;
    final datePrevue = rendezVous['date_prevue'] as DateTime;
    final joursRestants = _getJoursRestants(datePrevue);
    final isEnRetard = datePrevue.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      color: isEnRetard ? Colors.red[50] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec nom de l'enfant et vaccin
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF4CAF50),
                  child: const Icon(
                    Icons.vaccines,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enfant['nom'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Vaccin: ${rendezVous['vaccin']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isEnRetard ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isEnRetard ? 'EN RETARD' : 'À VENIR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Informations du rendez-vous
            _buildInfoRow(Icons.calendar_today, 'Date', DateFormat('dd/MM/yyyy').format(datePrevue)),
            _buildInfoRow(Icons.access_time, 'Jours restants', joursRestants),
            _buildInfoRow(Icons.location_on, 'Lieu', rendezVous['lieu']),
            
            if (rendezVous['notes'] != null && rendezVous['notes'].isNotEmpty)
              _buildInfoRow(Icons.info, 'Notes', rendezVous['notes']),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter la confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Confirmation du rendez-vous pour ${enfant['nom']}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Confirmer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4CAF50),
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter le report
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Report du rendez-vous pour ${enfant['nom']}'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    icon: const Icon(Icons.schedule),
                    label: const Text('Reporter'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
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
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 