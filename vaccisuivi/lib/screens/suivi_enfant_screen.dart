import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/enfant.dart';
import 'fiche_enfant_screen.dart';

class SuiviEnfantScreen extends StatefulWidget {
  const SuiviEnfantScreen({Key? key}) : super(key: key);

  @override
  State<SuiviEnfantScreen> createState() => _SuiviEnfantScreenState();
}

class _SuiviEnfantScreenState extends State<SuiviEnfantScreen> {
  final ApiService _apiService = ApiService();
  List<Enfant> _enfants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEnfants();
  }

  Future<void> _loadEnfants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _enfants = await _apiService.getEnfants();
    } catch (e) {
      print('Erreur lors du chargement des enfants: $e');
      _enfants = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(double tauxCouverture) {
    if (tauxCouverture >= 100) {
      return Colors.green;
    } else if (tauxCouverture > 0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getStatusText(double tauxCouverture) {
    if (tauxCouverture >= 100) {
      return 'Complet';
    } else if (tauxCouverture > 0) {
      return 'Partiel';
    } else {
      return 'Non vacciné';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de l\'Enfant'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEnfants,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _enfants.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.child_care_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun enfant inscrit',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Inscrivez votre enfant pour commencer le suivi',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadEnfants,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _enfants.length,
                    itemBuilder: (context, index) {
                      final enfant = _enfants[index];
                      return _buildEnfantCard(enfant);
                    },
                  ),
                ),
    );
  }

  Widget _buildEnfantCard(Enfant enfant) {
    final statusColor = _getStatusColor(enfant.tauxCouverture);
    final statusText = _getStatusText(enfant.tauxCouverture);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FicheEnfantScreen(enfant: enfant),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
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
                    backgroundColor: enfant.sexe == 'M' ? Colors.blue : Colors.pink,
                    child: Icon(
                      enfant.sexe == 'M' ? Icons.boy : Icons.girl,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enfant.nom,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              enfant.village,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.cake, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${enfant.age} ans',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barre de progression
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progression vaccinale',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${enfant.tauxCouverture.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: enfant.tauxCouverture / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 8,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Informations rapides
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      Icons.vaccines,
                      '${enfant.historiqueVaccins.length} vaccins reçus',
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      Icons.schedule,
                      enfant.prochainVaccin != null
                          ? 'Prochain: ${enfant.prochainVaccin!.nom}'
                          : 'Aucun RDV prévu',
                      Colors.orange,
                    ),
                  ),
                ],
              ),

              // Bouton d'action
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FicheEnfantScreen(enfant: enfant),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('Voir le détail complet'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4CAF50),
                    side: const BorderSide(color: Color(0xFF4CAF50)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
} 