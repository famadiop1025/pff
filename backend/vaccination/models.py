from django.db import models

# Create your models here.

class Village(models.Model):
    nom = models.CharField(max_length=100)

    def __str__(self):
        return self.nom

class Enfant(models.Model):
    SEXE_CHOICES = (
        ('M', 'Garçon'),
        ('F', 'Fille'),
    )
    nom = models.CharField(max_length=100)
    sexe = models.CharField(max_length=1, choices=SEXE_CHOICES)
    village = models.ForeignKey(Village, on_delete=models.CASCADE, related_name='enfants')
    date_naissance = models.DateField()

    def __str__(self):
        return self.nom

class Vaccin(models.Model):
    STATUT_CHOICES = (
        ('recu', 'Reçu'),
        ('retard', 'Retard'),
    )
    enfant = models.ForeignKey(Enfant, on_delete=models.CASCADE, related_name='vaccins')
    nom = models.CharField(max_length=100)
    date_administration = models.DateField()
    statut = models.CharField(max_length=10, choices=STATUT_CHOICES)
    notes = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.nom} - {self.enfant.nom}"
