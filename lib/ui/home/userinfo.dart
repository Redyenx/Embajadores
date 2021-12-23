import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/authentication/sign_in_page.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/widgets/footer.dart';
import 'package:embajadores/ui/widgets/passwordfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final CustomColors _colors = CustomColors();
  bool isChecked = false;
  bool isEnabled = true;
  bool _obscure = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final prefs = UserPreferences();

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widgetFooter(_colors.shadowColor(context)),
              Container(
                //color: Colors.deepPurple,
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            NeumorphicIcon(
                              Icons.dark_mode_outlined,
                              size: 30,
                              style: NeumorphicStyle(
                                  color: _colors.iconsColor(context),
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  shadowLightColor:
                                      _colors.shadowColor(context),
                                  depth: 1,
                                  intensity: 0.7),
                            ),
                            NeumorphicText(
                              ' Tema oscuro',
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
                          ],
                        ),
                        Switch(
                            activeColor: _colors.iconsColor(context),
                            value: theme.darkTheme,
                            onChanged: (value) {
                              theme.toggleTheme();
                            }),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            NeumorphicIcon(
                              Icons.touch_app,
                              size: 30,
                              style: NeumorphicStyle(
                                  color: _colors.iconsColor(context),
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  shadowLightColor:
                                      _colors.shadowColor(context),
                                  depth: 1,
                                  intensity: 0.7),
                            ),
                            NeumorphicText(
                              ' Reiniciar tuturiales',
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
                          ],
                        ),
                        NeumorphicButton(
                          onPressed: () {
                            FormHelper.showMessage(
                              context,
                              "Embajadores",
                              "¿Reiniciar tutoriales?",
                              "Si",
                              () {
                                prefs.firstRun = true;
                                prefs.firstStoreFilter = true;
                                prefs.firstIncident = true;
                                prefs.firstIncidentFilter = true;
                                prefs.firstStore = true;
                                prefs.firstViewStore = true;
                                prefs.firstViewOrEdit = true;
                                EasyLoading.showInfo('Tutoriales reiniciados',
                                    maskType: EasyLoadingMaskType.custom,
                                    dismissOnTap: true);
                                Navigator.of(context).pop();
                              },
                              buttonText2: "No",
                              isConfirmationDialog: true,
                              onPressed2: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          tooltip: 'Reiniciar tutoriales',
                          style: NeumorphicStyle(
                              color: _colors.contextColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: const NeumorphicBoxShape.circle(),
                              shadowLightColor: _colors.shadowColor(context),
                              depth: 1,
                              intensity: 0.7),
                          padding: const EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.refresh,
                            color: _colors.iconsColor(context),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        NeumorphicIcon(
                          Icons.account_box_outlined,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.textColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor:
                                  _colors.shadowTextColor(context),
                              depth: 1,
                              intensity: 0.7),
                        ),
                        NeumorphicText(
                          ' Mi cuenta',
                          style: NeumorphicStyle(
                            color: _colors.textColor(context),
                            intensity: 0.7,
                            depth: 1,
                            shadowLightColor: _colors.shadowTextColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Visibility(
                      visible: false,
                      child: ListTile(
                        leading: NeumorphicIcon(
                          Icons.lock_outline,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.iconsColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: _colors.shadowColor(context),
                              depth: 1,
                              intensity: 0.7),
                        ),
                        title: NeumorphicText(
                          ' Cambiar contraseña',
                          style: NeumorphicStyle(
                            color: _colors.textColor(context),
                            intensity: 0.7,
                            depth: 1,
                            shadowLightColor: _colors.shadowTextColor(context),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 14,
                          ),
                        ),
                        trailing: NeumorphicIcon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          style: NeumorphicStyle(
                              color: _colors.iconsColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: _colors.shadowColor(context),
                              depth: 1,
                              intensity: 0.7),
                        ),
                        onTap: () {
                          _changePasswordInputDialog(context);
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: NeumorphicIcon(
                        Icons.logout,
                        size: 30,
                        style: NeumorphicStyle(
                            color: _colors.iconsColor(context),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            shadowLightColor: _colors.shadowColor(context),
                            depth: 1,
                            intensity: 0.7),
                      ),
                      title: NeumorphicText(
                        ' Cerrar sesión',
                        style: NeumorphicStyle(
                          color: _colors.textColor(context),
                          intensity: 0.7,
                          depth: 1,
                          shadowLightColor: _colors.shadowTextColor(context),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: NeumorphicIcon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                        style: NeumorphicStyle(
                            color: _colors.iconsColor(context),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            shadowLightColor: _colors.shadowColor(context),
                            depth: 1,
                            intensity: 0.7),
                      ),
                      onTap: () {
                        FormHelper.showMessage(
                          context,
                          "Embajadores",
                          "¿Cerrar sesión?",
                          "Si",
                          () async {
                            final prefs = UserPreferences();
                            prefs.removeValues();
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SignInPage(),
                                ),
                                (route) => false);
                          },
                          buttonText2: "No",
                          isConfirmationDialog: true,
                          onPressed2: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePasswordInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cambiar contraseña'),
            content: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                height: 90,
                //color: Colors.deepPurpleAccent,
                child: Column(
                  children: <Widget>[
                    PasswordField(
                      onSaved: (input) {},
                      controller: _newPasswordController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "Por favor ingrese una contraseña"),
                        FormBuilderValidators.minLength(context, 8,
                            errorText: 'Debe contener al menos 8 caracteres'),
                        //FormBuilderValidators.match(context, r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$', errorText: 'La contraseña debe contener al menos una mayúscula, un número y un carácter especial'),
                        FormBuilderValidators.match(context, r'^(?=.*?[A-Z])',
                            errorText: 'Debe contener al menos una mayúscula.'),
                        FormBuilderValidators.match(context, r'^(?=.*?[0-9])',
                            errorText: 'Debe contener al menos un digito.'),
                        FormBuilderValidators.match(
                            context, r'^(?=.*?[#?!@$%^&*-])',
                            errorText: '..al menos un caracter especial.')
                      ]),
                      labelText: 'Contraseña',
                      onFieldChange: (value) {},
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('Enviar'),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          );
        });
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
