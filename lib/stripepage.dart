import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart'as http;

class StripePage extends StatefulWidget {
  const StripePage({super.key});

  @override
  State<StripePage> createState() => _StripePageState();
}

class _StripePageState extends State<StripePage> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Payment"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()async{
             await makePayment();
            },
            child: Container(
              alignment: Alignment.center,
              width: 200,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.deepOrange
              ),
              child: const Text("Pay"),
            )
          )
        ],
      ),
    );
  }
  Future<void>makePayment()async{
    try{
       paymentIntentData=createPaymentIntent('20','USD');
       await Stripe.instance.initPaymentSheet(
           paymentSheetParameters: SetupPaymentSheetParameters(
             paymentIntentClientSecret:paymentIntentData?['client_secret'],
             // applePay: PaymentSheetApplePay(merchantCountryCode: 'US'),
             // googlePay:PaymentSheetGooglePay(merchantCountryCode: 'US'),
             merchantDisplayName: "Sachin Saini",
           )
       );
     displayPaymentSheet();

    }catch(e){
      if (kDebugMode) {
        print('Exception$e');
      }
    }

  }
  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
        //       parameters: PresentPaymentSheetParameters(
        // clientSecret: paymentIntentData!['client_secret'],
        // confirmPayment: true,
        // )
      )
          .then((newValue) {
        print('payment intent${paymentIntentData!['id']}');
        print(
            'payment intent${paymentIntentData!['client_secret']}');
        print('payment intent${paymentIntentData!['amount']}');
        print('payment intent$paymentIntentData');
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('Exception/DISPLAYPAYMENTSHEET==> $e');
      }
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }
  createPaymentIntent(String amount, String currency)async{
    try{
   Map<String ,dynamic>body={
      'amount':calculateAmount(amount),
      'currency':currency,
     'payment_method_type[]':'card',
   };
  var response=await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
    body: body,
    headers: {
    'Authorization':'Bearer sk_test_51PzxI9P5RDqDoolZEnyxsKchCfXhuwzckBc3GLVfI48ral6gzc0o1EUU2q20WnJ9RW5oOeYB0rnXL8FqOTW63Sr900oc7MWcY3',
     'content-Type':'application/x-www-form-urlencoded'
  }
  );
  return jsonDecode(response.body.toString());

    }catch(e){
      if (kDebugMode) {
        print('Exception$e');
      }
    }
  }
  calculateAmount(String amount){
    final price=int.parse(amount)*100;
    return price;
  }
}
