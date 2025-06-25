from django.shortcuts import render
from rest_framework import viewsets
from .models import Village, Enfant, Vaccin
from .serializers import VillageSerializer, EnfantSerializer, VaccinSerializer

# Create your views here.

class VillageViewSet(viewsets.ModelViewSet):
    queryset = Village.objects.all()
    serializer_class = VillageSerializer

class EnfantViewSet(viewsets.ModelViewSet):
    queryset = Enfant.objects.all().order_by('id')
    serializer_class = EnfantSerializer

class VaccinViewSet(viewsets.ModelViewSet):
    queryset = Vaccin.objects.all()
    serializer_class = VaccinSerializer
