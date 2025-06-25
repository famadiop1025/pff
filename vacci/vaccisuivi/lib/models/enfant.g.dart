// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enfant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enfant _$EnfantFromJson(Map<String, dynamic> json) => Enfant(
  id: json['id'] as String,
  nom: json['nom'] as String,
  sexe: json['sexe'] as String,
  village: json['village'] as String,
  dateNaissance: DateTime.parse(json['date_naissance'] as String),
  historiqueVaccins:
      (json['historique_vaccins'] as List<dynamic>)
          .map((e) => Vaccin.fromJson(e as Map<String, dynamic>))
          .toList(),
  prochainVaccin:
      json['prochain_vaccin'] == null
          ? null
          : Vaccin.fromJson(json['prochain_vaccin'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EnfantToJson(Enfant instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'sexe': instance.sexe,
  'village': instance.village,
  'date_naissance': instance.dateNaissance.toIso8601String(),
  'historique_vaccins': instance.historiqueVaccins,
  'prochain_vaccin': instance.prochainVaccin,
};

Vaccin _$VaccinFromJson(Map<String, dynamic> json) => Vaccin(
  id: json['id'] as String,
  nom: json['nom'] as String,
  dateAdministration: DateTime.parse(json['date_administration'] as String),
  statut: json['statut'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$VaccinToJson(Vaccin instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'date_administration': instance.dateAdministration.toIso8601String(),
  'statut': instance.statut,
  'notes': instance.notes,
};
