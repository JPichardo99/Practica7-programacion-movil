import 'package:flutter/material.dart';
import 'package:socialtec/Screens/ApiPopular/list_popular_videos.dart';
import 'package:socialtec/Screens/Post/add_post_screen.dart';
import 'package:socialtec/Screens/UserPreferences/user_preference.dart';
import 'package:socialtec/Screens/Welcome/welcome_screen.dart';
import 'package:socialtec/Screens/dashboard_screen.dart';
import 'package:socialtec/Screens/map_screen.dart';
import 'package:socialtec/Screens/profileUser/profile_user_screen.dart';

import 'Screens/Eventos/events_screen.dart';

Map<String, WidgetBuilder> getApplicactionRoutes() {
  return <String, WidgetBuilder>{
    '/dash': (BuildContext context) => DashboardScreen(),
    '/welcome': (BuildContext context) => WelcomeScreen(),
    '/preferences': (BuildContext context) => UserPreferenceScreen(),
    '/add': (BuildContext context) => AddPostScreen(),
    '/events': (BuildContext context) => EventsScreen(),
    '/popular': (BuildContext context) => ListPopularVideos(),
    '/maps': (BuildContext context) => MapSample(),
    '/profile': (BuildContext context) => ProfileUserScreen(),
  };
}
