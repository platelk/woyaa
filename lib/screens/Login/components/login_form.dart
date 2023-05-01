import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/blocs/authentication/authentication_bloc.dart';
import 'package:woyaa/screens/OnBoarding/onboarding.dart';

import '../../../constants.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLogging = false;
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final state = context.read<AuthenticationBloc>().state;
        if (state is LoggedInState && !isLogging) {
          isLogging = true;
          Future.delayed(const Duration(milliseconds: 500)).then((value) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      print("LOGGING STATE");
                      return const OnBoardingScreen();
                    },
                  ),
                )
              });
        }

        return Form(
          child: Column(
            children: [
              TextFormField(
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                cursorColor: Theme.of(context).primaryColor,
                style: const TextStyle(color: kWelcomePrimaryColor),
                decoration: const InputDecoration(
                  hintText: "Votre mail",
                  hintStyle: TextStyle(
                      color: kWelcomePrimaryColor, fontWeight: FontWeight.bold),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(color: kWelcomePrimaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(color: kTrombiBackgroundColor),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFE8D1C5)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              side:
                                  const BorderSide(color: Color(0xFFE8D1C5))))),
                  onPressed: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(LoggingEvent(email: emailController.text));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Commencer",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
            ],
          ),
        );
      },
    );
  }
}
