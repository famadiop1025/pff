from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinLengthValidator

class CustomUser(AbstractUser):
    USER_TYPE_CHOICES = (
        (1, 'Patient'),
        (2, 'Medecin'),
        (3, 'Administrateur'),
    )
    user_type = models.PositiveSmallIntegerField(choices=USER_TYPE_CHOICES, default=1)
    phone = models.CharField(max_length=20, blank=True)
    address = models.TextField(blank=True)

class PatientProfile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='patient_profile')
    date_naissance = models.DateField()
    groupe_sanguin = models.CharField(max_length=5)
    antecedents_familiaux = models.TextField(blank=True)

class MedecinProfile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='medecin_profile')
    specialite = models.CharField(max_length=100)
    numero_licence = models.CharField(max_length=50, validators=[MinLengthValidator(5)])
    hopital = models.CharField(max_length=100)

class DossierMedical(models.Model):
    patient = models.OneToOneField(PatientProfile, on_delete=models.CASCADE, related_name='dossier')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Consultation(models.Model):
    dossier = models.ForeignKey(DossierMedical, on_delete=models.CASCADE, related_name='consultations')
    medecin = models.ForeignKey(MedecinProfile, on_delete=models.CASCADE)
    date = models.DateTimeField(auto_now_add=True)
    motif = models.CharField(max_length=200)
    diagnostic = models.TextField()
    traitement = models.TextField()
    notes = models.TextField(blank=True)