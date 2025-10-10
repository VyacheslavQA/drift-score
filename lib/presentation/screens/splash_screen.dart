import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isPressed = false;

  // Контроллеры для анимаций
  late AnimationController _pressAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _shimmerAnimationController;
  late AnimationController _loadingAnimationController;

  // Анимации
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _loadingRotation;

  // Таймеры
  Timer? _pulseStartTimer;
  Timer? _shimmerStartTimer;
  Timer? _shimmerRepeatTimer;
  Timer? _loginDelayTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startPulseAnimation();
  }

  void _setupAnimations() {
    // Анимация нажатия (быстрая)
    _pressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _pressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация пульсации (медленная, повторяющаяся)
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация шиммера (блеск)
    _shimmerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация загрузки
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadingRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.linear,
      ),
    );
  }

  void _startPulseAnimation() {
    // Запускаем пульсацию с задержкой
    _pulseStartTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && !_isLoading) {
        _pulseAnimationController.repeat(reverse: true);
        // Запускаем шиммер периодически
        _startShimmerAnimation();
      }
    });
  }

  void _startShimmerAnimation() {
    _shimmerStartTimer = Timer(const Duration(seconds: 1), () {
      if (mounted && !_isLoading) {
        _shimmerAnimationController.forward().then((_) {
          if (mounted) {
            _shimmerAnimationController.reset();
            // Повторяем шиммер каждые 4 секунды
            _shimmerRepeatTimer = Timer(const Duration(seconds: 4), () {
              if (mounted && !_isLoading) {
                _startShimmerAnimation();
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // Отменяем все таймеры
    _pulseStartTimer?.cancel();
    _shimmerStartTimer?.cancel();
    _shimmerRepeatTimer?.cancel();
    _loginDelayTimer?.cancel();

    // Останавливаем и освобождаем анимации
    _pressAnimationController.dispose();
    _pulseAnimationController.dispose();
    _shimmerAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_isLoading) return;

    // Системная вибрация
    HapticFeedback.mediumImpact();

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // Останавливаем пульсацию и шиммер
    _pulseAnimationController.stop();
    _shimmerAnimationController.stop();

    // Отменяем таймеры анимаций
    _pulseStartTimer?.cancel();
    _shimmerStartTimer?.cancel();
    _shimmerRepeatTimer?.cancel();

    // Запускаем анимацию загрузки
    _loadingAnimationController.repeat();

    // Имитируем небольшую задержку для анимации
    _loginDelayTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        // Переходим на главный экран
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  Widget _buildAnimatedButton() {
    final screenSize = MediaQuery.of(context).size;

    // Адаптивные размеры
    final bool isTablet = screenSize.width >= 600;
    final bool isDesktop = screenSize.width >= 1024;
    final bool is4K = screenSize.width >= 2560;

    final double buttonWidth = is4K
        ? 600.0
        : isDesktop
        ? 500.0
        : isTablet
        ? 400.0
        : screenSize.width * 0.8;

    final double buttonHeight = is4K
        ? 80.0
        : isDesktop
        ? 72.0
        : isTablet
        ? 64.0
        : 56.0;

    final double fontSize = is4K
        ? 24.0
        : isDesktop
        ? 22.0
        : isTablet
        ? 20.0
        : 18.0;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _pressAnimationController,
        _pulseAnimationController,
        _shimmerAnimationController,
        _loadingAnimationController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value *
              (_isLoading ? 1.0 : _pulseAnimation.value),
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: _isLoading ? 8 : 12,
                  spreadRadius: _isLoading ? 0 : 1,
                  offset: const Offset(0, 4),
                ),
                if (!_isLoading)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.0),
              child: Stack(
                children: [
                  // Основной фон кнопки
                  Container(
                    decoration: BoxDecoration(
                      color: _isPressed
                          ? Colors.white.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(28.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),

                  // Шиммер эффект
                  if (!_isLoading)
                    Positioned(
                      left: _shimmerAnimation.value * buttonWidth * 0.5,
                      child: Container(
                        width: buttonWidth * 0.3,
                        height: buttonHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Содержимое кнопки
                  Center(
                    child: _isLoading
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: _loadingRotation.value * 2 * 3.14159,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Загрузка...',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    )
                        : Text(
                      'Войти',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Overlay для эффекта нажатия
                  if (_isPressed)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Адаптивные breakpoints
    final bool isTablet = screenSize.width >= 600;
    final bool isDesktop = screenSize.width >= 1024;
    final bool is4K = screenSize.width >= 2560;
    final bool isSmallScreen = screenSize.height < 600;

    // Адаптивные размеры шрифтов
    final double titleFontSize = is4K
        ? 96.0
        : isDesktop
        ? 80.0
        : isTablet
        ? 60.0
        : isSmallScreen
        ? 42.0
        : 54.0;

    final double subtitle1FontSize = is4K
        ? 34.0  // Было 32.0 → увеличено на 2
        : isDesktop
        ? 30.0  // Было 28.0 → увеличено на 2
        : isTablet
        ? 24.0  // Было 22.0 → увеличено на 2
        : isSmallScreen
        ? 18.0  // Было 16.0 → увеличено на 2
        : 22.0; // Было 20.0 → увеличено на 2

    final double subtitle2FontSize = is4K
        ? 30.0  // Было 28.0 → увеличено на 2
        : isDesktop
        ? 26.0  // Было 24.0 → увеличено на 2
        : isTablet
        ? 22.0  // Было 20.0 → увеличено на 2
        : isSmallScreen
        ? 16.0  // Было 14.0 → увеличено на 2
        : 20.0; // Было 18.0 → увеличено на 2

    final double copyrightFontSize = is4K
        ? 18.0
        : isDesktop
        ? 16.0
        : isTablet
        ? 14.0
        : 12.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: is4K
                    ? 64.0
                    : isDesktop
                    ? 48.0
                    : isTablet
                    ? 32.0
                    : 16.0,
                vertical: isDesktop ? 24.0 : 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Гибкий верхний отступ
                  Expanded(
                    flex: isSmallScreen ? 1 : (isTablet ? 3 : 2),
                    child: Container(),
                  ),

                  // Заголовок приложения
                  Text(
                    'Drift Score',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                      height: is4K
                          ? 48
                          : isTablet
                          ? 32
                          : isSmallScreen
                          ? 16
                          : 24),

                  // Подзаголовок 1
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: is4K
                          ? 1200
                          : isDesktop
                          ? 800
                          : isTablet
                          ? 600
                          : screenSize.width * 0.85,
                    ),
                    child: Text(
                      'Профессиональное судейство соревнований',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subtitle1FontSize,
                        fontWeight: FontWeight.bold,  // ✅ Изменено с w500 на bold
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 16),

                  // Подзаголовок 2
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: is4K
                          ? 1200
                          : isDesktop
                          ? 800
                          : isTablet
                          ? 600
                          : screenSize.width * 0.85,
                    ),
                    child: Text(
                      'Управляй турнирами легко',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subtitle2FontSize,
                        fontWeight: FontWeight.bold,  // ✅ Добавлено
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Гибкий средний отступ
                  Expanded(
                    flex: isSmallScreen ? 2 : (isTablet ? 4 : 3),
                    child: Container(),
                  ),

                  // Кнопка входа
                  GestureDetector(
                    onTapDown: (_) {
                      if (!_isLoading && mounted) {
                        setState(() {
                          _isPressed = true;
                        });
                        _pressAnimationController.forward();
                      }
                    },
                    onTapUp: (_) {
                      if (!_isLoading && mounted) {
                        setState(() {
                          _isPressed = false;
                        });
                        _pressAnimationController.reverse();
                        _handleLogin();
                      }
                    },
                    onTapCancel: () {
                      if (!_isLoading && mounted) {
                        setState(() {
                          _isPressed = false;
                        });
                        _pressAnimationController.reverse();
                      }
                    },
                    child: _buildAnimatedButton(),
                  ),

                  SizedBox(
                      height: is4K
                          ? 48
                          : isDesktop
                          ? 40
                          : isTablet
                          ? 32
                          : 24),

                  SizedBox(
                      height: isSmallScreen
                          ? 16
                          : isDesktop
                          ? 64
                          : isTablet
                          ? 48
                          : 32),

                  // Авторские права
                  Text(
                    '© 2025 Drift Score',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: copyrightFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Text(
                    'Все права защищены',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: copyrightFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}