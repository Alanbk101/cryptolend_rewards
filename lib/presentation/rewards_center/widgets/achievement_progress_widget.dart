import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementProgressWidget extends StatefulWidget {
  final Map<String, dynamic> achievement;
  final VoidCallback? onShare;

  const AchievementProgressWidget({
    Key? key,
    required this.achievement,
    this.onShare,
  }) : super(key: key);

  @override
  State<AchievementProgressWidget> createState() =>
      _AchievementProgressWidgetState();
}

class _AchievementProgressWidgetState extends State<AchievementProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final double progress = (widget.achievement['progress'] as num).toDouble();
    final double target = (widget.achievement['target'] as num).toDouble();
    final double progressPercentage = (progress / target).clamp(0.0, 1.0);

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: progressPercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.achievement['title'] as String;
    final String description = widget.achievement['description'] as String;
    final int progress = (widget.achievement['progress'] as num).toInt();
    final int target = (widget.achievement['target'] as num).toInt();
    final int pointReward = (widget.achievement['pointReward'] as num).toInt();
    final String category = widget.achievement['category'] as String;
    final bool isCompleted = progress >= target;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      onLongPress: isCompleted ? widget.onShare : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : _getCategoryColor(category).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: isCompleted
                          ? 'check_circle'
                          : _getCategoryIcon(category),
                      color: isCompleted
                          ? Colors.white
                          : _getCategoryColor(category),
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isCompleted
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Completado',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: _isExpanded ? null : 2,
                        overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progreso',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$progress / $target',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.primaryColor,
                            ),
                            minHeight: 8,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'stars',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '$pointReward',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requisitos de Finalización',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _getCompletionRequirements(category),
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    if (isCompleted) ...[
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Mantén presionado para compartir tu logro',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'educativo':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'préstamo':
        return AppTheme.lightTheme.primaryColor;
      case 'referido':
        return const Color(0xFF7C3AED);
      case 'social':
        return const Color(0xFFD97706);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'educativo':
        return 'school';
      case 'préstamo':
        return 'account_balance_wallet';
      case 'referido':
        return 'group_add';
      case 'social':
        return 'share';
      default:
        return 'emoji_events';
    }
  }

  String _getCompletionRequirements(String category) {
    switch (category.toLowerCase()) {
      case 'educativo':
        return 'Completa todos los módulos del curso y aprueba el examen final con una puntuación mínima del 80%.';
      case 'préstamo':
        return 'Realiza préstamos por un valor total acumulado y mantén un historial de pagos sin retrasos.';
      case 'referido':
        return 'Invita a nuevos usuarios que completen su primer préstamo exitosamente en la plataforma.';
      case 'social':
        return 'Comparte tus logros en redes sociales y participa activamente en la comunidad DeFi.';
      default:
        return 'Cumple con todos los requisitos específicos del logro para desbloquearlo.';
    }
  }
}
