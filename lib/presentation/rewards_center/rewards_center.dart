import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_progress_widget.dart';
import './widgets/activity_item_widget.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/reward_card_widget.dart';
import './widgets/rewards_header_widget.dart';

class RewardsCenter extends StatefulWidget {
  const RewardsCenter({Key? key}) : super(key: key);

  @override
  State<RewardsCenter> createState() => _RewardsCenterState();
}

class _RewardsCenterState extends State<RewardsCenter>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Todos';
  bool _isLoading = false;
  bool _isOffline = false;

  final List<String> _categories = [
    'Todos',
    'Educativo',
    'Préstamo',
    'Referido',
    'Evento Especial'
  ];

  // Mock data for rewards
  final List<Map<String, dynamic>> _availableRewards = [
    {
      "id": 1,
      "title": "Descuento Premium 20%",
      "description":
          "Obtén un 20% de descuento en tu próximo préstamo premium. Válido por 30 días desde el canje.",
      "pointCost": 500,
      "category": "Préstamo",
      "imageUrl":
          "https://images.pexels.com/photos/3943716/pexels-photo-3943716.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isAvailable": true,
    },
    {
      "id": 2,
      "title": "Curso Avanzado DeFi",
      "description":
          "Acceso completo al curso avanzado de finanzas descentralizadas con certificación incluida.",
      "pointCost": 1200,
      "category": "Educativo",
      "imageUrl":
          "https://images.pexels.com/photos/5980856/pexels-photo-5980856.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isAvailable": true,
    },
    {
      "id": 3,
      "title": "Tarjeta Regalo \$50",
      "description":
          "Tarjeta regalo digital por valor de \$50 USD para usar en comercios afiliados.",
      "pointCost": 2500,
      "category": "Evento Especial",
      "imageUrl":
          "https://images.pexels.com/photos/4968391/pexels-photo-4968391.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isAvailable": false,
    },
    {
      "id": 4,
      "title": "Bono de Referido",
      "description":
          "Recibe puntos extra por cada amigo que invites y complete su primer préstamo.",
      "pointCost": 300,
      "category": "Referido",
      "imageUrl":
          "https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isAvailable": true,
    },
  ];

  // Mock data for recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "title": "Préstamo Completado",
      "description": "Préstamo de 1,000 USDC completado exitosamente",
      "points": 150,
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "type": "lending",
    },
    {
      "id": 2,
      "title": "Curso Básico Finalizado",
      "description": "Completaste el módulo 'Introducción a DeFi'",
      "points": 100,
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "type": "education",
    },
    {
      "id": 3,
      "title": "Referido Exitoso",
      "description": "Tu amigo María completó su primer préstamo",
      "points": 200,
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "type": "referral",
    },
    {
      "id": 4,
      "title": "Bono Diario",
      "description": "Bono por usar la aplicación 7 días consecutivos",
      "points": 50,
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "type": "bonus",
    },
  ];

  // Mock data for achievements
  final List<Map<String, dynamic>> _achievements = [
    {
      "id": 1,
      "title": "Maestro DeFi",
      "description": "Completa todos los cursos educativos disponibles",
      "progress": 7,
      "target": 10,
      "pointReward": 1000,
      "category": "Educativo",
    },
    {
      "id": 2,
      "title": "Prestamista Experto",
      "description": "Realiza 25 préstamos exitosos",
      "progress": 18,
      "target": 25,
      "pointReward": 750,
      "category": "Préstamo",
    },
    {
      "id": 3,
      "title": "Embajador de la Comunidad",
      "description": "Refiere a 10 nuevos usuarios activos",
      "progress": 10,
      "target": 10,
      "pointReward": 500,
      "category": "Referido",
    },
    {
      "id": 4,
      "title": "Influencer Social",
      "description": "Comparte 20 logros en redes sociales",
      "progress": 12,
      "target": 20,
      "pointReward": 300,
      "category": "Social",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkConnectivity();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isOffline = false; // For demo purposes, assume online
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onRedeemReward(Map<String, dynamic> reward) {
    _showRedemptionBottomSheet(reward);
  }

  void _showRedemptionBottomSheet(Map<String, dynamic> reward) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirmar Canje',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl: reward['imageUrl'] as String,
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reward['title'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'stars',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 16,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '${reward['pointCost']} puntos',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '¿Estás seguro de que quieres canjear esta recompensa?',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Se deducirán ${reward['pointCost']} puntos de tu saldo actual.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSuccessSnackBar(
                                  '¡Recompensa canjeada exitosamente!');
                            },
                            child: Text('Confirmar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _shareAchievement(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Compartir Logro'),
        content: Text(
            '¡Comparte tu logro "${achievement['title']}" en redes sociales!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('¡Logro compartido exitosamente!');
            },
            child: Text('Compartir'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredRewards() {
    if (_selectedCategory == 'Todos') {
      return _availableRewards;
    }
    return _availableRewards
        .where((reward) => reward['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.primaryColor,
        child: Column(
          children: [
            RewardsHeaderWidget(
              totalPoints: 3750,
              currentTier: 'Oro',
              onRefresh: _refreshData,
            ),
            if (_isOffline)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'wifi_off',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Modo sin conexión - Mostrando datos guardados',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: AppTheme.lightTheme.cardColor,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppTheme.lightTheme.primaryColor,
                      unselectedLabelColor:
                          AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      indicatorColor: AppTheme.lightTheme.primaryColor,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Recompensas'),
                        Tab(text: 'Actividad'),
                        Tab(text: 'Logros'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Rewards Tab
                        Column(
                          children: [
                            SizedBox(height: 2.h),
                            FilterChipsWidget(
                              categories: _categories,
                              selectedCategory: _selectedCategory,
                              onCategorySelected: _onCategorySelected,
                            ),
                            SizedBox(height: 1.h),
                            Expanded(
                              child: _getFilteredRewards().isEmpty
                                  ? EmptyStateWidget(
                                      title: 'No hay recompensas disponibles',
                                      description:
                                          'No se encontraron recompensas para la categoría seleccionada. Prueba con otra categoría.',
                                      buttonText: 'Ver Todas',
                                      onButtonPressed: () =>
                                          _onCategorySelected('Todos'),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.only(bottom: 2.h),
                                      itemCount: _getFilteredRewards().length,
                                      itemBuilder: (context, index) {
                                        final reward =
                                            _getFilteredRewards()[index];
                                        return RewardCardWidget(
                                          reward: reward,
                                          onRedeem: () =>
                                              _onRedeemReward(reward),
                                          onTap: () => _onRedeemReward(reward),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                        // Activity Tab
                        _recentActivities.isEmpty
                            ? EmptyStateWidget(
                                title: 'Sin actividad reciente',
                                description:
                                    'Comienza a usar la aplicación para ver tu actividad de puntos aquí.',
                                buttonText: 'Comenzar a Ganar',
                                onButtonPressed: () => Navigator.pushNamed(
                                    context, '/lending-screen'),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                itemCount: _recentActivities.length,
                                itemBuilder: (context, index) {
                                  final activity = _recentActivities[index];
                                  return ActivityItemWidget(activity: activity);
                                },
                              ),
                        // Achievements Tab
                        _achievements.isEmpty
                            ? EmptyStateWidget(
                                title: 'Sin logros disponibles',
                                description:
                                    'Completa actividades para desbloquear logros y ganar puntos extra.',
                                buttonText: 'Explorar Cursos',
                                onButtonPressed: () =>
                                    Navigator.pushNamed(context, '/dashboard'),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                itemCount: _achievements.length,
                                itemBuilder: (context, index) {
                                  final achievement = _achievements[index];
                                  return AchievementProgressWidget(
                                    achievement: achievement,
                                    onShare: () =>
                                        _shareAchievement(achievement),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 2,
        onTap: (index) {
          // Navigation handled in the widget
        },
      ),
    );
  }
}
