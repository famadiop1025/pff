from django.shortcuts import render
from rest_framework import viewsets
from .models import Village, Enfant, Vaccin
from .serializers import VillageSerializer, EnfantSerializer, VaccinSerializer
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from django.contrib.auth.models import User
from .models import Profile

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

class CustomLoginView(APIView):
    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')
        user = authenticate(username=username, password=password)
        if user is not None:
            token, created = Token.objects.get_or_create(user=user)
            role = user.profile.role if hasattr(user, 'profile') else 'parent'
            
            # Gestion du nom complet avec fallback
            if user.first_name and user.last_name:
                full_name = f"{user.first_name} {user.last_name}"
            elif user.first_name:
                full_name = user.first_name
            elif user.last_name:
                full_name = user.last_name
            else:
                full_name = user.username
            
            print(f"Login - Username: {user.username}, Full Name: {full_name}, Role: {role}")
            
            return Response({
                'token': token.key,
                'role': role,
                'username': user.username,
                'full_name': full_name,
            })
        return Response({'error': 'Identifiants invalides'}, status=status.HTTP_401_UNAUTHORIZED)
