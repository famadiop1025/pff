import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({Key? key}) : super(key: key);

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomCompletController = TextEditingController();
  final TextEditingController _nomUtilisateurController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _roleSelectionne = 'parent';
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  final List<String> _roles = ['parent', 'tuteur', 'agent', 'admin'];
  final List<String> _villages = ['Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];

  @override
  void dispose() {
    _nomCompletController.dispose();
    _nomUtilisateurController.dispose();
    _telephoneController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();
    _emailController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  Future<void> _inscrire() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Préparer les données d'inscription
      final inscriptionData = {
        'username': _nomUtilisateurController.text.trim(),
        'password': _motDePasseController.text,
        'email': _emailController.text.trim(),
        'first_name': _nomCompletController.text.trim().split(' ').first,
        'last_name': _nomCompletController.text.trim().split(' ').length > 1 
            ? _nomCompletController.text.trim().split(' ').skip(1).join(' ')
            : '',
        'telephone': _telephoneController.text.trim(),
        'village': _villageController.text,
        'role': _roleSelectionne,
      };

      // Appel API pour l'inscription
      final response = await _apiService.register(inscriptionData);

      if (response['success'] == true) {
        // Inscription réussie
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Inscription réussie ! Bienvenue ${_nomCompletController.text}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Rediriger vers la page de connexion
          Navigator.pop(context);
        }
      } else {
        // Erreur lors de l'inscription
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Erreur lors de l\'inscription'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      // Gestion des erreurs réseau ou autres
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateNomComplet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer votre nom complet';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Veuillez entrer votre nom et prénom';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Veuillez entrer un nom d'utilisateur";
    }
    if (value.trim().length < 3) {
      return "Le nom d'utilisateur doit contenir au moins 3 caractères";
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return "Le nom d'utilisateur ne peut contenir que des lettres, chiffres et underscores";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer votre email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  String? _validateTelephone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    if (!RegExp(r'^[0-9+\-\s\(\)]{8,15}$').hasMatch(value.trim())) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une minuscule, une majuscule et un chiffre';
    }
    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != _motDePasseController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF4CAF50)),
                  SizedBox(height: 16),
                  Text('Création de votre compte...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo ou titre
                    const Icon(
                      Icons.person_add,
                      size: 80,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Créer votre compte',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Nom complet
                    TextFormField(
                      controller: _nomCompletController,
                      decoration: const InputDecoration(
                        labelText: 'Nom complet *',
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Ex: Fatou Diop',
                      ),
                      validator: _validateNomComplet,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // Nom d'utilisateur
                    TextFormField(
                      controller: _nomUtilisateurController,
                      decoration: const InputDecoration(
                        labelText: "Nom d'utilisateur *",
                        prefixIcon: Icon(Icons.account_circle),
                        hintText: 'Ex: fatou_diop',
                      ),
                      validator: _validateUsername,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Ex: fatou.diop@email.com',
                      ),
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Téléphone
                    TextFormField(
                      controller: _telephoneController,
                      decoration: const InputDecoration(
                        labelText: 'Téléphone *',
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Ex: +221 77 123 45 67',
                      ),
                      validator: _validateTelephone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Village
                    DropdownButtonFormField<String>(
                      value: _villageController.text.isEmpty ? null : _villageController.text,
                      decoration: const InputDecoration(
                        labelText: 'Village *',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      items: _villages.map((village) {
                        return DropdownMenuItem(
                          value: village,
                          child: Text(village),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _villageController.text = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner votre village';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Rôle
                    DropdownButtonFormField<String>(
                      value: _roleSelectionne,
                      decoration: const InputDecoration(
                        labelText: 'Rôle *',
                        prefixIcon: Icon(Icons.work),
                      ),
                      items: _roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(_getRoleDisplayName(role)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _roleSelectionne = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Mot de passe
                    TextFormField(
                      controller: _motDePasseController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe *',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: 'Au moins 8 caractères',
                      ),
                      validator: _validatePassword,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Confirmation du mot de passe
                    TextFormField(
                      controller: _confirmationController,
                      decoration: InputDecoration(
                        labelText: 'Confirmation du mot de passe *',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmation ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmation = !_obscureConfirmation;
                            });
                          },
                        ),
                      ),
                      validator: _validateConfirmation,
                      obscureText: _obscureConfirmation,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 32),

                    // Bouton d'inscription
                    ElevatedButton(
                      onPressed: _inscrire,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Créer mon compte",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lien vers la connexion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Déjà inscrit ? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Se connecter",
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'parent':
        return 'Parent';
      case 'tuteur':
        return 'Tuteur';
      case 'agent':
        return 'Agent de santé';
      case 'admin':
        return 'Administrateur';
      default:
        return role;
    }
  }
} 