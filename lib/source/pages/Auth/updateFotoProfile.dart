part of '../index.dart';

class UpdateFotoProfileScreen extends StatefulWidget {
  const UpdateFotoProfileScreen({super.key});

  @override
  State<UpdateFotoProfileScreen> createState() => _UpdateFotoProfileScreenState();
}

class _UpdateFotoProfileScreenState extends State<UpdateFotoProfileScreen> {
  XFile? imageFile;
  bool isLoading = false;

  void pickImage(ImageSource? source) async {
    selectPhoto(source: source).then((value) {
      setState(() {
        imageFile = value;
        print("gambar: ${imageFile!.path}");
      });
    });
  }

  void submit() {
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan ambil foto terlebih dahulu', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    BlocProvider.of<ChangeFotoProfileCubit>(context).updateFotoProfil(imageFile, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteCustom,
      appBar: AppBar(
        title: Text('Ubah Foto Profile', style: TextStyle(fontFamily: "InterSemiBold", fontSize: 14)),
        centerTitle: true,
        backgroundColor: whiteCustom2,
      ),
      body: BlocListener<ChangeFotoProfileCubit, ChangeFotoProfileState>(
        listener: (context, state) {
          if (state is ChangeFotoProfileLoading) {
            MyDialog.dialogLoading(context);
          }
          if (state is ChangeFotoProfileFailed) {
            Navigator.of(context).pop();
            var message = state.message;
            MyDialog.dialogAlert2(context, message);
          }
          if (state is ChangeFotoProfileLoaded) {
            Navigator.of(context).pop();
            var message = state.message;
            MyDialog.dialogSuccess2(context, message);
             BlocProvider.of<ProfileCubit>(context).getProfile(context);
          }
        },
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: Ink(
                  color: whiteCustom2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextButton.icon(icon: const Icon(Icons.camera), label: const Text('Camera'), onPressed: () => pickImage(ImageSource.camera)),
                            TextButton.icon(icon: const Icon(Icons.image), label: const Text('Gallery'), onPressed: () => pickImage(ImageSource.gallery)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (imageFile != null) Center(child: Image.file(File(imageFile!.path), height: 240)),
                        if (imageFile == null)
                          Container(height: 240, decoration: BoxDecoration(color: Colors.grey.shade100), child: Center(child: Icon(Icons.image))),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Spacer(),
                    CustomButton(
                      onTap: () => submit(),
                      height: 45,
                      text: 'Simpan',
                      backgroundColor: biru,
                      textStyle: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'InterMedium'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
