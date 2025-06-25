from rest_framework.routers import DefaultRouter
from .views import VillageViewSet, EnfantViewSet, VaccinViewSet

router = DefaultRouter()
router.register(r'villages', VillageViewSet)
router.register(r'enfants', EnfantViewSet)
router.register(r'vaccins', VaccinViewSet)

urlpatterns = router.urls 