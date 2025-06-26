import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/enfant.dart';
import '../services/api_service.dart';

class FicheEnfantScreen extends StatefulWidget {
  final Enfant enfant;
  const FicheEnfantScreen({Key? key, required this.enfant}) : super(key: key);

  @override
  State<FicheEnfantScreen> createState() => _FicheEnfantScreenState();
}

class _FicheEnfantScreenState extends State<FicheEnfantScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

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
        title: Text('Fiche de ${widget.enfant.nom}'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implémenter la modification
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modification de l\'enfant à implémenter'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec photo et informations principales
            _buildEnTete(),
            const SizedBox(height: 24),

            // Statut vaccinal
            _buildStatutVaccinal(),
            const SizedBox(height: 24),

            // Informations personnelles
            _buildInformationsPersonnelles(),
            const SizedBox(height: 24),

            // Historique vaccinal
            _buildHistoriqueVaccinal(),
            const SizedBox(height: 24),

            // Prochain rendez-vous
            if (widget.enfant.prochainVaccin != null) ...[
              _buildProchainRendezVous(),
              const SizedBox(height: 24),
            ],

            // Actions
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnTete() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: widget.enfant.sexe == 'M' ? Colors.blue : Colors.pink,
              child: Icon(
                widget.enfant.sexe == 'M' ? Icons.boy : Icons.girl,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.enfant.nom,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.enfant.village,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.cake, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.enfant.age} ans',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        widget.enfant.sexe == 'M' ? Icons.male : Icons.female,
                        size: 16,
                        color: widget.enfant.sexe == 'M' ? Colors.blue : Colors.pink,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.enfant.sexe == 'M' ? 'Garçon' : 'Fille',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.enfant.sexe == 'M' ? Colors.blue : Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatutVaccinal() {
    final statusColor = _getStatusColor(widget.enfant.tauxCouverture);
    final statusText = _getStatusText(widget.enfant.tauxCouverture);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.vaccines, color: statusColor, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Statut Vaccinal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${widget.enfant.tauxCouverture.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 16,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vaccins reçus: ${widget.enfant.historiqueVaccins.length}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vaccins manquants: ${_getVaccinsManquants()}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: widget.enfant.tauxCouverture / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationsPersonnelles() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: const Color(0xFF4CAF50), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Informations Personnelles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Date de naissance', DateFormat('dd/MM/yyyy').format(widget.enfant.dateNaissance)),
            _buildInfoRow('Lieu de naissance', widget.enfant.lieuNaissance),
            _buildInfoRow('Groupe sanguin', widget.enfant.groupeSanguin),
            _buildInfoRow('Allergies', widget.enfant.allergies.isNotEmpty ? widget.enfant.allergies : 'Aucune'),
            _buildInfoRow('Antécédents médicaux', widget.enfant.antecedentsMedicaux.isNotEmpty ? widget.enfant.antecedentsMedicaux : 'Aucun'),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoriqueVaccinal() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: const Color(0xFF4CAF50), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Historique Vaccinal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.enfant.historiqueVaccins.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Aucun vaccin reçu pour le moment',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.enfant.historiqueVaccins.length,
                itemBuilder: (context, index) {
                  final vaccin = widget.enfant.historiqueVaccins[index];
                  return _buildVaccinItem(vaccin);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinItem(Vaccin vaccin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccin.nom,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reçu le ${DateFormat('dd/MM/yyyy').format(vaccin.dateAdministration)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                if (vaccin.lieu != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Lieu: ${vaccin.lieu}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProchainRendezVous() {
    final prochainVaccin = widget.enfant.prochainVaccin!;
    
    return Card(
      elevation: 2,
      color: Colors.orange.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Prochain Rendez-vous',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Vaccin', prochainVaccin.nom),
            _buildInfoRow('Date prévue', DateFormat('dd/MM/yyyy').format(prochainVaccin.dateAdministration)),
            if (prochainVaccin.lieu != null)
              _buildInfoRow('Lieu', prochainVaccin.lieu!),
            if (prochainVaccin.notes != null)
              _buildInfoRow('Notes', prochainVaccin.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter l'ajout de vaccin
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ajout de vaccin à implémenter'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un vaccin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter la planification de RDV
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Planification de rendez-vous à implémenter'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    icon: const Icon(Icons.schedule),
                    label: const Text('Planifier RDV'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4CAF50),
                      side: const BorderSide(color: Color(0xFF4CAF50)),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
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

  int _getVaccinsManquants() {
    // Simulation du calcul des vaccins manquants
    // TODO: Implémenter la logique réelle basée sur l'âge et le calendrier vaccinal
    final vaccinsRecus = widget.enfant.historiqueVaccins.length;
    final vaccinsAttendus = (widget.enfant.age * 2).round(); // Estimation simple
    return vaccinsAttendus - vaccinsRecus > 0 ? vaccinsAttendus - vaccinsRecus : 0;
  }
} 