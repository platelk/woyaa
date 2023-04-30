import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/blocs/authentication/authentication_bloc.dart';
import 'package:woyaa/screens/OnBoarding/onboarding.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Home/home_screen.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final state = context.read<AuthenticationBloc>().state;
        if (state is LoggedInState) {
          Future.delayed(const Duration(milliseconds: 500)).then((value) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const OnBoardingScreen();
                    },
                  ),
                )
              });
        }
        var emailController = TextEditingController();
        final focus = FocusNode();
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
                  focusedBorder : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(color: kWelcomePrimaryColor),
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
              const SizedBox(height: defaultPadding),
            ],
          ),
        );
      },
    );
  }
}
