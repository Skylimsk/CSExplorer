import 'package:csexplorer/bottom_NavBar.dart';
import 'package:csexplorer/data/model/course.dart';
import 'package:csexplorer/data/model/scholarship.dart';
import 'package:csexplorer/data/model/university.dart';
import 'package:csexplorer/main.dart';
import 'package:csexplorer/presentation/screens/Courses/course_details.dart';
import 'package:csexplorer/presentation/screens/Courses/courses_main.dart';
import 'package:csexplorer/presentation/screens/FAQ/manage_faq.dart';
import 'package:csexplorer/presentation/screens/Feedback/feedback_form.dart';
import 'package:csexplorer/presentation/screens/Profile/profile_screen.dart';
import 'package:csexplorer/presentation/screens/Scholarships/scholarship_details.dart';
import 'package:csexplorer/presentation/screens/Universities/university_details.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MyApp());
      case '/csExplorer':
        return MaterialPageRoute(builder: (_) => const BottomNavBar());
      case '/feedbackForm':
        return MaterialPageRoute(builder: (_) => const FeedbackForm());
      case '/profileScreen':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/manageFAQ':
        return MaterialPageRoute(builder: (_) => const ManageFAQ());
      case '/universityDetails': 
        return MaterialPageRoute(builder: (_) => UniversityDetails(universityArguments: routeSettings.arguments as University));   
      case '/course':
        return MaterialPageRoute(builder: (_) => const CourseMain());
      case '/courseDetails': 
        return MaterialPageRoute(builder: (_) => CourseDetails(courseArguments: routeSettings.arguments as Course));  
      case '/scholarshipDetails': 
        return MaterialPageRoute(builder: (_) => ScholarshipDetails(scholarshipArguments: routeSettings.arguments as Scholarship));  
      default:
        return null;
    }
  }
}
