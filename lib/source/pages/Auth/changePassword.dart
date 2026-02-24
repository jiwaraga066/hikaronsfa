part of '../index.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController controllerConfirmPassword = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void onChangeHidePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void onChangeHideConfirmPassword() {
    setState(() {
      hideConfirmPassword = !hideConfirmPassword;
    });
  }

  void submit() {
    if (formkey.currentState!.validate()) {
      BlocProvider.of<ChangePasswordCubit>(context).changePassword(controllerPassword.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(backgroundColor: whiteCustom),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordLoading) {
            MyDialog.dialogLoading(context);
          }
          if (state is ChangePasswordFailed) {
            Navigator.of(context).pop();
            var message = state.message;
            MyDialog.dialogAlert2(context, message);
          }
          if (state is ChangePasswordLoaded) {
            Navigator.of(context).pop();
            var message = state.message;
            MyDialog.dialogSuccess2(context, message);
          }
        },
        child: Center(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('assets/images/hikaron.jpg', height: 30)),
                  const SizedBox(height: 12),
                  Center(child: Text("Change your Password.", style: TextStyle(fontFamily: 'InterSemiBold', fontSize: 18))),
                  const SizedBox(height: 30),
                  const Text("New Password", style: TextStyle(fontFamily: "InterRegular")),
                  const SizedBox(height: 6),
                  CustomField2(
                    controller: controllerPassword,
                    preffixIcon: const Icon(Icons.lock),
                    obscureText: hidePassword,
                    suffixIcon: InkWell(onTap: onChangeHidePassword, child: hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                    hintText: "Please Insert New Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "New password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text("Confirm Password", style: TextStyle(fontFamily: "InterRegular")),
                  const SizedBox(height: 6),
                  CustomField2(
                    controller: controllerConfirmPassword,
                    preffixIcon: const Icon(Icons.lock),
                    obscureText: hideConfirmPassword,
                    suffixIcon: InkWell(
                      onTap: onChangeHideConfirmPassword,
                      child: hideConfirmPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                    ),
                    hintText: "Please Insert New Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      if (value != controllerPassword.text) {
                        return "Password does not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: CustomButton(
                      onTap: submit,
                      text: "Change Password",
                      backgroundColor: ungu3,
                      textStyle: const TextStyle(color: whiteCustom, fontSize: 18, fontFamily: 'InterSemiBold'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
