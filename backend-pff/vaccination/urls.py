from rest_framework.routers import DefaultRouter
from .views import VillageViewSet, EnfantViewSet, VaccinViewSet, CustomLoginView
from rest_framework.authtoken.views import obtain_auth_token
from django.urls import path

router = DefaultRouter()
router.register(r'villages', VillageViewSet)
router.register(r'enfants', EnfantViewSet)
router.register(r'vaccins', VaccinViewSet)

urlpatterns = [
    path('login/', CustomLoginView.as_view(), name='custom_login'),
]
urlpatterns += router.urls 