import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;
  final int _totalPages = 3;

  // Mock onboarding data
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Descubre DeFi",
      "description":
          "Aprende los conceptos básicos de las finanzas descentralizadas y cómo funcionan los préstamos con criptomonedas de manera segura.",
      "imageUrl":
          "https://images.unsplash.com/photo-1639762681485-074b7f938ba0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3J5cHRvY3VycmVuY3l8ZW58MHx8MHx8fDA%3D",
    },
    {
      "title": "Préstamos con Stablecoins",
      "description":
          "Utiliza monedas estables para generar ingresos pasivos a través de préstamos descentralizados con tasas competitivas y transparentes.",
      "imageUrl":
          "https://images.unsplash.com/photo-1621761191319-c6fb62004040?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3RhYmxlY29pbnxlbnwwfHwwfHx8MA%3D%3D",
    },
    {
      "title": "Gana Recompensas",
      "description":
          "Acumula puntos por cada transacción y completa cursos educativos para desbloquear recompensas exclusivas en nuestra plataforma.",
      "imageUrl":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmV3YXJkc3xlbnwwfHwwfHx8MA%3D%3D",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _getStarted() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingPageWidget(
                  title: data["title"] as String,
                  description: data["description"] as String,
                  imageUrl: data["imageUrl"] as String,
                  isLastPage: index == _totalPages - 1,
                  onNext: _nextPage,
                  onSkip: _skipOnboarding,
                  onGetStarted: _getStarted,
                );
              },
            ),
          ),

          // Page indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: PageIndicatorWidget(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
          ),
        ],
      ),
    );
  }
}
