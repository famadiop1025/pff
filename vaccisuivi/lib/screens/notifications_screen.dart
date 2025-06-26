import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  final String userRole;
  final String userName;

  const NotificationsScreen({
    Key? key,
    required this.userRole,
    required this.userName,
  }) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API pour les notifications
      // TODO: Remplacer par un vrai appel API quand l'endpoint sera créé
      await Future.delayed(Duration(seconds: 1));
      
      // Données mock basées sur le rôle
      _notifications = _generateMockNotifications();
      
    } catch (e) {
      print('Erreur lors du chargement des notifications: $e');
      _notifications = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockNotifications() {
    final now = DateTime.now();
    final notifications = <Map<String, dynamic>>[];

    switch (widget.userRole) {
      case 'admin':
        notifications.addAll([
          {
            'id': '1',
            'type': 'system',
            'title': 'Nouvel utilisateur inscrit',
            'message': 'Un nouvel agent de santé s\'est inscrit dans le système',
            'timestamp': now.subtract(Duration(hours: 2)),
            'isRead': false,
            'priority': 'high',
          },
          {
            'id': '2',
            'type': 'vaccination',
            'title': 'Rapport de vaccination',
            'message': 'Le rapport mensuel de vaccination est disponible',
            'timestamp': now.subtract(Duration(days: 1)),
            'isRead': true,
            'priority': 'medium',
          },
          {
            'id': '3',
            'type': 'alert',
            'title': 'Maintenance système',
            'message': 'Maintenance prévue le 15/12/2024 de 22h à 02h',
            'timestamp': now.subtract(Duration(days: 2)),
            'isRead': false,
            'priority': 'high',
          },
        ]);
        break;

      case 'agent':
        notifications.addAll([
          {
            'id': '1',
            'type': 'urgent',
            'title': 'Rendez-vous urgent',
            'message': 'Fatou Diop a un rendez-vous de vaccination en retard',
            'timestamp': now.subtract(Duration(hours: 1)),
            'isRead': false,
            'priority': 'high',
          },
          {
            'id': '2',
            'type': 'reminder',
            'title': 'Rappel de vaccination',
            'message': '5 enfants ont des vaccins à administrer cette semaine',
            'timestamp': now.subtract(Duration(hours: 3)),
            'isRead': false,
            'priority': 'medium',
          },
          {
            'id': '3',
            'type': 'info',
            'title': 'Nouveau protocole',
            'message': 'Mise à jour du protocole de vaccination COVID-19',
            'timestamp': now.subtract(Duration(days: 1)),
            'isRead': true,
            'priority': 'low',
          },
        ]);
        break;

      case 'parent':
      case 'tuteur':
        notifications.addAll([
          {
            'id': '1',
            'type': 'reminder',
            'title': 'Rendez-vous de vaccination',
            'message': 'Votre enfant a un rendez-vous de vaccination demain',
            'timestamp': now.subtract(Duration(hours: 4)),
            'isRead': false,
            'priority': 'high',
          },
          {
            'id': '2',
            'type': 'info',
            'title': 'Vaccin reçu',
            'message': 'Le vaccin DTC a été administré avec succès',
            'timestamp': now.subtract(Duration(days: 2)),
            'isRead': true,
            'priority': 'medium',
          },
          {
            'id': '3',
            'type': 'alert',
            'title': 'Rappel important',
            'message': 'N\'oubliez pas de ramener le carnet de vaccination',
            'timestamp': now.subtract(Duration(days: 3)),
            'isRead': false,
            'priority': 'medium',
          },
        ]);
        break;
    }

    return notifications;
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'urgent':
        return Icons.warning;
      case 'reminder':
        return Icons.schedule;
      case 'info':
        return Icons.info;
      case 'alert':
        return Icons.notification_important;
      case 'system':
        return Icons.admin_panel_settings;
      case 'vaccination':
        return Icons.vaccines;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucune notification',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
                ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final priority = notification['priority'] as String;
    final type = notification['type'] as String;
    final timestamp = notification['timestamp'] as DateTime;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 1 : 3,
      color: isRead ? Colors.grey[50] : Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPriorityColor(priority).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(type),
            color: _getPriorityColor(priority),
            size: 24,
          ),
        ),
        title: Text(
          notification['title'] as String,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? Colors.grey[600] : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'] as String,
              style: TextStyle(
                color: isRead ? Colors.grey[600] : Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy à HH:mm').format(timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getPriorityColor(priority),
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Marquer comme lu
          setState(() {
            notification['isRead'] = true;
          });
        },
      ),
    );
  }
} 