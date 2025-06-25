from django import forms
from django.contrib.auth.forms import UserCreationForm
from .models import CustomUser, PatientProfile, MedecinProfile

class CustomUserCreationForm(UserCreationForm):
    class Meta(UserCreationForm.Meta):
        model = CustomUser
        fields = ('username', 'email', 'first_name', 'last_name', 'user_type')

class PatientProfileForm(forms.ModelForm):
    class Meta:
        model = PatientProfile
        fields = ['date_naissance', 'groupe_sanguin', 'antecedents_familiaux']

class MedecinProfileForm(forms.ModelForm):
    class Meta:
        model = MedecinProfile
        fields = ['specialite', 'numero_licence', 'hopital']