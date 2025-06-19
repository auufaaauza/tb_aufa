import 'package:flutter/material.dart';
import 'package:tb_aufa/src/views/login_screen.dart';
import 'package:tb_aufa/src/views/splash_screen.dart';
import 'package:tb_aufa/src/views/register_screen.dart';
import 'package:tb_aufa/src/views/profile_screen.dart';
import 'package:tb_aufa/src/views/bottom_navigation.dart';
import 'package:tb_aufa/src/views/edit_profile_screen.dart';
import 'package:tb_aufa/src/views/article_detail_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const introduction = '/intro';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const articleDetail = '/article/:id';
  static const profile = '/profile';
  static const explore = '/explore';
  static const trending = '/trending';
  static const saved = '/saved';
  static const myArticles = '/my-articles';
  static const createArticle = '/create-article';
  static const editArticle = '/edit-article/:id';
  static const editProfile = '/edit-profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case home:
        return MaterialPageRoute(
          builder: (_) => const BottomNavigationScreen(),
        );
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/article/:id':
        return MaterialPageRoute(
          builder: (_) =>
              ArticleDetailScreen(articleId: settings.arguments as String),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
