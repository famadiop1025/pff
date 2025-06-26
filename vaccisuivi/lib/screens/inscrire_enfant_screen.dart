import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/enfant.dart';

class InscrireEnfantScreen extends StatefulWidget {
  const InscrireEnfantScreen({Key? key}) : super(key: key);

  @override
  State<InscrireEnfantScreen> createState() => _InscrireEnfantScreenState();
}

class _InscrireEnfantScreenState extends State<InscrireEnfantScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  
  final _nomController = TextEditingController();
  final _villageController = TextEditingController();
  DateTime? _dateNaissance;
  String _sexe = 'M';
  bool _isLoading = false;
  
  final List<String> _villages = ['Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];

  @override
  void dispose() {
    _nomController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null && picked != _dateNaissance) {
      setState(() {
        _dateNaissance = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final enfantData = {
        'nom': _nomController.text.trim(),
        'sexe': _sexe,
        'village': _villageController.text,
        'date_naissance': _dateNaissance!.toIso8601String(),
      };

      final nouvelEnfant = await _apiService.createEnfant(enfantData);
      
      if (nouvelEnfant != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${nouvelEnfant.nom} a été inscrit avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Retour avec succès
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'inscription'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur de connexion au serveur'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscrire un Enfant'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4CAF50)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.child_care,
                      size: 48,
                      color: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Inscription d\'un Nouvel Enfant',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Remplissez les informations ci-dessous pour inscrire votre enfant au programme de vaccination.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2E7D32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Nom de l'enfant
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom complet de l\'enfant *',
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF4CAF50)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer le nom de l\'enfant';
                  }
                  if (value.trim().length < 2) {
                    return 'Le nom doit contenir au moins 2 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Sexe
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 4),
                      child: Text(
                        'Sexe *',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Row(
                              children: [
                                Icon(Icons.boy, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Garçon'),
                              ],
                            ),
                            value: 'M',
                            groupValue: _sexe,
                            onChanged: (value) {
                              setState(() {
                                _sexe = value!;
                              });
                            },
                            activeColor: const Color(0xFF4CAF50),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Row(
                              children: [
                                Icon(Icons.girl, color: Colors.pink),
                                SizedBox(width: 8),
                                Text('Fille'),
                              ],
                            ),
                            value: 'F',
                            groupValue: _sexe,
                            onChanged: (value) {
                              setState(() {
                                _sexe = value!;
                              });
                            },
                            activeColor: const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Date de naissance
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date de naissance *',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dateNaissance != null
                                  ? DateFormat('dd/MM/yyyy').format(_dateNaissance!)
                                  : 'Sélectionner une date',
                              style: TextStyle(
                                fontSize: 16,
                                color: _dateNaissance != null ? Colors.black : Colors.grey,
                                fontWeight: _dateNaissance != null ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              if (_dateNaissance == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    'Veuillez sélectionner la date de naissance',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Village
              DropdownButtonFormField<String>(
                value: _villageController.text.isEmpty ? null : _villageController.text,
                decoration: InputDecoration(
                  labelText: 'Village *',
                  prefixIcon: const Icon(Icons.location_on, color: Color(0xFF4CAF50)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
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
                    _villageController.text = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un village';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Informations importantes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Informations importantes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• L\'inscription permettra de suivre la vaccination de votre enfant\n'
                      '• Vous recevrez des notifications pour les rendez-vous\n'
                      '• Les données sont confidentielles et sécurisées\n'
                      '• Vous pourrez consulter l\'historique vaccinal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bouton d'inscription
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Inscrire l\'enfant',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
} 