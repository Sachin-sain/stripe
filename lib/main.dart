import 'package:flutter/material.dart';
import 'package:stripe_integration/stripepage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey='pk_test_51PzxI9P5RDqDoolZAmNWa6XWBZD2AoA5ZvJ6TutgcoszM6pbaVbtJ6KI2uS13Bc4UvXgoITwRTZJa4xHmqqKw01Z00DaBCMYyh';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StripePage(),
    );
  }
}


