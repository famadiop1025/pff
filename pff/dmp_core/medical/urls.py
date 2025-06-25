from django.urls import path
from . import views

urlpatterns = [
    path('', views.dashboard, name='dashboard'),
    path('profile/patient/', views.complete_patient_profile, name='complete_patient_profile'),
    path('dossier/', views.DossierMedicalDetailView.as_view(), name='dossier_detail'),
    path('dossier/<int:dossier_id>/consultation/new/', 
         views.ConsultationCreateView.as_view(), 
         name='new_consultation'),
]