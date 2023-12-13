import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/firebase/email_auth.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailAuth = EmailAuth();
  final imglogo = Image.asset('assets/logo.png', height: 350, width: 350);
  final imglogoD = Image.asset('assets/logo.png', height: 300, width: 300,);
  final spaceHorizontal = SizedBox(height: 10,);

  @override
  Widget build(BuildContext context) {
    //controladores
    TextEditingController txtConUser = TextEditingController();
    TextEditingController txtConPass = TextEditingController();

    final txtRegister = Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
       child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
          },
          child: const Text('Registrarse', style: TextStyle(fontSize: 18, decoration: TextDecoration.underline))));

    final txtEmail = TextFormField(
      controller: txtConUser,
      decoration: InputDecoration(
        label: Text('Email User'),
        border: OutlineInputBorder()
      ),
    );

    final txtPass = TextFormField(
      controller: txtConPass,
      obscureText: true,
      decoration: InputDecoration(
        label: Text('Password'),
        border: OutlineInputBorder()
      )
    );

    final btnEmail = SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin, 
      onPressed:() async {
        bool res = await emailAuth.validateUser(emailUser: txtConUser.text, pwdUser: txtConPass.text);
        txtConPass.text = '';
        txtConUser.text = '';
        if(res){
          GlobalValues.login.setBool('login', true);
          Navigator.pushNamed(context, '/dash');
        }
        //Navigator.pushNamed(context, '/dash');
      }
    );

    final session = CheckboxListTile(
      title: Text('Recordar'),
      controlAffinity: ListTileControlAffinity.leading,
      value: GlobalValues.session.getBool('session') ?? false,
      onChanged: (bool? newbool) {
        setState(() {
          GlobalValues.session.setBool('session', newbool!);
        });
      });

    txtConUser.text = 'saulsanchezd@hotmail.com';
    txtConPass.text = 'yamatodmc3';
    
    //construccion de la pantalla login
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: .6, 
                  fit: BoxFit.cover, 
                  image: AssetImage('assets/fondoesp.jpg')
                )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                              imglogo,
                              txtEmail,
                              spaceHorizontal,
                              txtPass,
                              spaceHorizontal,
                              session,
                              spaceHorizontal,
                              btnEmail,
                              spaceHorizontal,
                              txtRegister,
                              spaceHorizontal,
                              //conocenos()
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}

