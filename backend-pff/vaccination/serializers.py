from rest_framework import serializers
from .models import Village, Enfant, Vaccin

class VillageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Village
        fields = ['id', 'nom']

class VaccinSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vaccin
        fields = ['id', 'nom', 'date_administration', 'statut', 'notes']

class EnfantSerializer(serializers.ModelSerializer):
    village = VillageSerializer(read_only=True)
    village_id = serializers.PrimaryKeyRelatedField(queryset=Village.objects.all(), source='village', write_only=True)
    vaccins = VaccinSerializer(many=True, read_only=True)

    class Meta:
        model = Enfant
        fields = ['id', 'nom', 'sexe', 'village', 'village_id', 'date_naissance', 'vaccins'] 