from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.views.generic import DetailView, UpdateView
from .models import DossierMedical, Consultation
from .forms import PatientProfileForm, MedecinProfileForm
from django.views.generic import CreateView, UpdateView, DetailView  # Ajoutez cette ligne

@login_required
def dashboard(request):
    if request.user.user_type == 1:  # Patient
        return render(request, 'medical/patient_dashboard.html')
    elif request.user.user_type == 2:  # Médecin
        return render(request, 'medical/medecin_dashboard.html')
    else:  # Admin
        return redirect('/admin/')

@login_required
@user_passes_test(lambda u: u.user_type == 1)
def complete_patient_profile(request):
    if request.method == 'POST':
        form = PatientProfileForm(request.POST)
        if form.is_valid():
            profile = form.save(commit=False)
            profile.user = request.user
            profile.save()
            return redirect('dashboard')
    else:
        form = PatientProfileForm()
    return render(request, 'medical/complete_profile.html', {'form': form})

class DossierMedicalDetailView(LoginRequiredMixin, DetailView):
    model = DossierMedical
    template_name = 'medical/dossier_detail.html'
    
    def get_object(self):
        if self.request.user.user_type == 1:  # Patient
            return self.request.user.patient_profile.dossier
        # Pour les médecins, vous devrez ajouter une logique supplémentaire

class ConsultationCreateView(LoginRequiredMixin, UserPassesTestMixin, CreateView):
    model = Consultation
    fields = ['motif', 'diagnostic', 'traitement', 'notes']
    template_name = 'medical/consultation_form.html'
    
    def test_func(self):
        return self.request.user.user_type == 2  # Seulement pour les médecins
    
    def form_valid(self, form):
        dossier = DossierMedical.objects.get(pk=self.kwargs['dossier_id'])
        form.instance.dossier = dossier
        form.instance.medecin = self.request.user.medecin_profile
        return super().form_valid(form)