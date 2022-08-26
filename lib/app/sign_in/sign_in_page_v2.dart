import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oas_mobile/app/common_widgets/form_submit_button.dart';
import 'package:oas_mobile/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:oas_mobile/app/services/auth.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:oas_mobile/flutx/themes/app_theme.dart';
import 'package:oas_mobile/flutx/themes/text_style.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oas_mobile/flutx/utils/size_config.dart';

import 'sign_in_manager.dart';

class SignInForm extends StatefulWidget {
  final bool isLoading;
  final SignInManager model;

  SignInForm({Key? key, required this.model, required this.isLoading})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final oasServerApis = Provider.of<OasServerApis>(context, listen: false);
    return ChangeNotifierProvider<SignInManager>(
      create: (_) =>
          SignInManager(auth: auth, oasServerApis: oasServerApis),
      child: Consumer<SignInManager>(
          builder: (_, model, __) => SignInForm(
                model: model,
                isLoading: model.isLoading,
              )),
    );
  }

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  SignInManager get model => widget.model;

  late ThemeData themeData;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
      SizedBox(height: 24),
      FormSubmitButton(
        onPressed: model.canSubmit ? _submit : null,
        text: model.primaryButtonText,
      ),
      SizedBox(height: 8),
      FlatButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  Widget _buildForm() {
    return Scaffold(
      backgroundColor: FxAppTheme.customTheme.bgLayer1,
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 3 / 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: FxAppTheme.customTheme.bgLayer1,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(MySize.size96))),
                ),
                /*
                Positioned(
                  top: 30,
                  left: 10,
                  child: BackButton(
                    color: themeData.colorScheme.onBackground,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                 */
                Positioned(
                  bottom: 20,
                  right: 40,
                  child: widget.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text("LOGIN",
                          style: FxTextStyle.getStyle(
                              textStyle: themeData.textTheme.headline5,
                              fontWeight: 600)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: MySize.size16!,
                right: MySize.size16!,
                top: MySize.size16!),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MySize.size12!,
                    left: MySize.size16!,
                    right: MySize.size16!,
                    bottom: MySize.size12!),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: FxTextStyle.getStyle(
                          textStyle: themeData.textTheme.bodyText1,
                          letterSpacing: 0.1,
                          color: themeData.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: FxTextStyle.getStyle(
                            textStyle: themeData.textTheme.subtitle2,
                            letterSpacing: 0.1,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500),
                        prefixIcon: Icon(MdiIcons.emailOutline),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => _emailEditingComplete(),
                      onChanged: model.updateEmail,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: MySize.size16!),
                      child: TextFormField(
                        style: FxTextStyle.getStyle(
                            textStyle: themeData.textTheme.bodyText1,
                            letterSpacing: 0.1,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: FxTextStyle.getStyle(
                              textStyle: themeData.textTheme.subtitle2,
                              letterSpacing: 0.1,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 500),
                          prefixIcon: Icon(MdiIcons.lockOutline),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? MdiIcons.eyeOutline
                                : MdiIcons.eyeOffOutline),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: _passwordVisible,
                        textInputAction: TextInputAction.done,
                        onChanged: model.updatePassword,
                        onEditingComplete: _submit,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: MySize.size16!),
                      alignment: Alignment.centerRight,
                      child: Text("Forgot Password ?",
                          style: FxTextStyle.getStyle(
                              textStyle: themeData.textTheme.caption,
                              fontWeight: 500)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: MySize.size16!),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(MySize.size24!)),
                        boxShadow: [
                          BoxShadow(
                            color: themeData.colorScheme.primary.withAlpha(28),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(Spacing.xy(16, 0))),
                          onPressed: _submit,
                          child: Text("LOGIN",
                              style: FxTextStyle.getStyle(
                                  textStyle: themeData.textTheme.button,
                                  fontWeight: 600,
                                  color: themeData.colorScheme.onPrimary,
                                  letterSpacing: 0.5))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            child: Center(
              child: Text("OR",
                  style: FxTextStyle.getStyle(
                      textStyle: themeData.textTheme.bodyText2,
                      fontWeight: 500)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: themeData.colorScheme.primary,
                    child: InkWell(
                      splashColor: Colors.white.withAlpha(100),
                      highlightColor: themeData.colorScheme.primary,
                      // inkwell color
                      child: SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(
                            MdiIcons.facebook,
                            color: themeData.colorScheme.onPrimary,
                            size: 30,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                ClipOval(
                  child: Material(
                    color: themeData.colorScheme.primary,
                    child: InkWell(
                      splashColor: Colors.white.withAlpha(100),
                      highlightColor: themeData.colorScheme.primary,
                      child: SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(
                            MdiIcons.google,
                            color: themeData.colorScheme.onPrimary,
                            size: 30,
                          )),
                      onTap: () => _signInWithGoogle(context),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return _buildForm();
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') return;
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final userCredential = await model.signInWithGoogle();

      if (userCredential.additionalUserInfo!.isNewUser) {
        final oasServerApis =
            Provider.of<OasServerApis>(context, listen: false);
        oasServerApis.registerNewUser();
      }
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }
}
