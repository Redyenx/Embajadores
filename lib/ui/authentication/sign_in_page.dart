import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/homepage.dart';
import 'package:embajadores/ui/widgets/footer.dart';
import 'package:embajadores/ui/widgets/passwordfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  CustomColors _colors = new CustomColors();
  String? logo = "assets/logo.png";
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //LoginRequestModel? loginRequestModel;
  bool isApiCallProcess = false;
  String? _password;
  String? _emailPhone;
  String? _errorText;

/*  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel(
        email: '', password: '', token: PushNotificationService.token);
  }*/

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.92,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    theme.toggleTheme();
                  },
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    //color: Colors.lightBlue,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        LottieBuilder.asset(
                          'assets/store-location.zip',
                        ),
                      ],
                    ),
                  ),
                ),
                buildInputLogin(),
                buildInput(),
                widgetFooter(_colors.textColor(context))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildLoginWith() {
    return const Padding(
      padding: EdgeInsets.all(28.0),
      child: Text("Iniciar sesión",
          style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
    );
  }

  Container buildInputLogin() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
                          name: "emailphone",
                          onSaved: (input) => _emailPhone = input,
                          decoration: InputDecoration(
                              errorText: _errorText,
                              prefixIcon: const Icon(Icons.alternate_email,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: "Cédula o correo electrónico"),
                          validator: (value) {
                            var isEmailValid = _validateEmail(value!);
                            print(isEmailValid);
                            //print(value);
                            if (_validateEmail(value) == false &&
                                _validateId(value) == false) {
                              return 'Ingrese una cédula o número de teléfono válido.';
                            }
                            return null;
                          },
/*                          validator: (value) {
                            if (_validateEmail(value!) == false &&
                                _validateId(value) == false) {
                              return 'Ingrese una cédula o número de teléfono válido.';
                            }
                            return null;
                          },*/
/*                          onChanged: (value) {
                            _emailPhone = value;
                          },*/
                        ),
                        PasswordField(
                          fieldKey: _passwordFieldKey,
                          controller: _passController,
                          onSaved: (input) => _password = input!,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: "Por favor ingrese una contraseña"),
                          ]),
                          labelText: 'Contraseña',
                          onFieldChange: (value) {
                            _password = value;
                          },
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            //color: Colors.deepPurple,
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: NeumorphicText(
                              "¿Olvidó su contraseña?",
                              style: NeumorphicStyle(
                                color: _colors.textColor(context),
                                intensity: 0.7,
                                depth: 1,
                                shadowLightColor:
                                    _colors.shadowTextColor(context),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ))
        ],
      ),
    );
  }

  Container buildInput() {
    return Container(
      //color: Colors.deepPurpleAccent,
      width: 200,
      height: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          NeumorphicButton(
            onPressed: () {
              APIService apiService = APIService();
              final prefs = UserPreferences();
              if (_formKey.currentState!.saveAndValidate()) {
                //print(loginRequestModel!.toJson());
                EasyLoading.show(
                  status: 'Iniciando sesión...',
                  maskType: EasyLoadingMaskType.black,
                );
                apiService.login(_emailPhone!, _password!).then((value) {
                  setState(() {
                    print(value.message);
                    EasyLoading.dismiss();
                  });
                  if (value.status == true) {
                    prefs.userId = value.data!.id.toString();
                    prefs.userName = value.data!.nombre!;
                    prefs.lastName = value.data!.apellidos!;
                    prefs.userDni = value.data!.dni!.toString();
                    prefs.email = value.data!.email!;
                    prefs.userRolId = value.data!.idRol!.toString();
                    prefs.token = value.data!.token!;
                    prefs.phone = value.data!.celular.toString();
                    print('User ID:  ${prefs.userId}');
                    print('Rol ID: ${prefs.userId}');
                    final snackBar = SnackBar(
                      content: Text(
                        value.message!,
                        style: TextStyle(color: _colors.textColor(context)),
                      ),
                      backgroundColor: Colors.black38,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(content: Text(value.message!));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              }
            },
            tooltip: 'Iniciar sesión',
            style: NeumorphicStyle(
                color: _colors.iconsColor(context),
                shape: NeumorphicShape.flat,
                boxShape: const NeumorphicBoxShape.rect(),
                shadowLightColor: _colors.iconsColor(context),
                depth: 1,
                intensity: 1),
            //padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NeumorphicText(
                  'Iniciar sesión ',
                  style: NeumorphicStyle(
                    color: _colors.textButtonColor(context),
                    intensity: 0.7,
                    depth: 1,
                    shadowLightColor: _colors.shadowTextColor(context),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 14,
                  ),
                ),
                NeumorphicIcon(
                  Icons.login,
                  size: 18,
                  style: NeumorphicStyle(
                      color: _colors.textButtonColor(context),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 0.9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget widgetFooter(Color texcolor) {
  return Footer(
    logo: 'assets/logo_footer.png',
    text: 'Powered by',
    textColor: texcolor,
    funFooterLogin: () {
      // develop what they want the footer to do when the user clicks
    },
  );
}

bool? _validateId(String value) {
  print(value);
  if (value.isEmpty) return false;
  final RegExp idExp = RegExp(r"^[0-9]+$");
  if (idExp.hasMatch(value)) return true;
}

bool? _validateEmail(String value) {
  print(value);
  if (value.isEmpty) return false;
  final RegExp emailExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (emailExp.hasMatch(value)) return true;
}
