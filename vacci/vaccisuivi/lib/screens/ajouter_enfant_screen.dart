import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/enfant.dart';
import '../services/data_service.dart';

class AjouterEnfantScreen extends StatefulWidget {
  const AjouterEnfantScreen({super.key});

  @override
  State<AjouterEnfantScreen> createState() => _AjouterEnfantScreenState();
}

class _AjouterEnfantScreenState extends State<AjouterEnfantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final DataService _dataService = DataService();
  String? _sexe;
  String? _village;
  DateTime? _dateNaissance;
  bool _isSaving = false;
  bool _isLoading = true;
  List<String> _villages = [];

  @override
  void initState() {
    super.initState();
    _loadVillages();
  }

  Future<void> _loadVillages() async {
    try {
      final villages = await _dataService.getVillages();
      setState(() {
        _villages = villages;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des villages: $e');
      setState(() {
        _villages = ['Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  void _ajouterEnfant() async {
    if (!_formKey.currentState!.validate() || _dateNaissance == null || _sexe == null || _village == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    setState(() { _isSaving = true; });

    try {
      final enfant = Enfant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nom: _nomController.text.trim(),
        sexe: _sexe!,
        village: _village!,
        dateNaissance: _dateNaissance!,
        historiqueVaccins: [],
        prochainVaccin: null,
      );

      final success = await _dataService.ajouterEnfant(enfant);
      
      if (mounted) {
        setState(() { _isSaving = false; });
        
        if (success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Enfant ajouté avec succès !'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de l\'ajout de l\'enfant.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() { _isSaving = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365)),
      firstDate: now.subtract(const Duration(days: 365*10)),
      lastDate: now,
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() { _dateNaissance = picked; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un enfant', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chargement des villages...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nom de l\'enfant', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        hintText: 'Ex: Fatou Diop',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Sexe', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Fille'),
                            value: 'F',
                            groupValue: _sexe,
                            onChanged: (v) => setState(() => _sexe = v),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Garçon'),
                            value: 'M',
                            groupValue: _sexe,
                            onChanged: (v) => setState(() => _sexe = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Village', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _village,
                      items: _villages.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                      onChanged: (v) => setState(() => _village = v),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Sélectionner le village',
                      ),
                      validator: (v) => v == null ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Date de naissance', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Sélectionner la date',
                        ),
                        child: Text(
                          _dateNaissance == null
                              ? 'Sélectionner la date'
                              : DateFormat('dd/MM/yyyy').format(_dateNaissance!),
                          style: TextStyle(
                            color: _dateNaissance == null ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.save),
                        label: const Text('Ajouter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isSaving ? null : _ajouterEnfant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 