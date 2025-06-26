from django.contrib.auth.models import User
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver

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

class Profile(models.Model):
    USER_ROLES = (
        ('parent', 'Parent'),
        ('tuteur', 'Tuteur'),
        ('agent', 'Agent de santé'),
        ('admin', 'Administrateur'),
    )
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=USER_ROLES, default='parent')

    def __str__(self):
        return f'{self.user.username} ({self.role})'

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()
