part of '../../index.dart';

class HistoryAbsensiScreen extends StatefulWidget {
  const HistoryAbsensiScreen({super.key});

  @override
  State<HistoryAbsensiScreen> createState() => _HistoryAbsensiScreenState();
}

class _HistoryAbsensiScreenState extends State<HistoryAbsensiScreen> {
  TextEditingController controllerMonthPick = TextEditingController();
  var valueTipe;
  var valueName;
  DateTime? valueMonthYear;
  List listCustomer = [
    {"name": "Customer", "value": "C"},
    {"name": "Non Customer", "value": "N"},
  ];
  void setValueCustomer(value) {
    setState(() {
      valueName = value;
      listCustomer.where((e) => e['name'] == value).forEach((a) async {
        valueTipe = a['value'];
      });
    });
  }

  void choseMonth() async {
    var result = await pickMonth(context);
    setState(() {
      valueMonthYear = result;
      controllerMonthPick.text = formatMonth(result).toString();
    });
  }

  void filterSearch() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Filter Laporan', style: TextStyle(fontSize: 16, fontFamily: 'InterSemiBold')),
                            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Choose Month', style: TextStyle(fontSize: 14, fontFamily: 'InterMedium')),
                      const SizedBox(height: 6),
                      CustomField2(controller: controllerMonthPick, onTap: choseMonth, readOnly: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: CustomButton2(
                          onTap: () {
                            getHistory();
                            Navigator.pop(context);
                          },
                          backgroundColor: amber2,
                          text: "Refresh",
                          textStyle: const TextStyle(color: whiteCustom2, fontFamily: "InterSemiBold", fontSize: 16),
                          roundedRectangleBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return Transform.scale(scale: Curves.easeOutBack.transform(anim.value), child: Opacity(opacity: anim.value, child: child));
      },
    );
  }

  void getHistory() {
    if (controllerMonthPick.text.isEmpty) {
      MyDialog.dialogAlert2(context, "Please Choose Month Year");
      return;
    }

    BlocProvider.of<GetHistoryAbsensiCubit>(context).getHistory(valueMonthYear!.year, valueMonthYear!.month, valueTipe, context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, true);
        BlocProvider.of<GetHistoryAbsensiCubit>(context).initial();
      },
      child: Scaffold(
        backgroundColor: whiteCustom,
        appBar: AppBar(
          backgroundColor: teal2,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<GetHistoryAbsensiCubit>(context).initial();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text("Laporan Absensi Kunjugan", style: TextStyle(color: Colors.white, fontFamily: 'InterMedium', fontSize: 14)),
          centerTitle: true,
          actions: [IconButton(onPressed: filterSearch, icon: Icon(Icons.search, color: Colors.white))],
        ),
        body: BlocBuilder<GetHistoryAbsensiCubit, GetHistoryAbsensiState>(
          builder: (context, state) {
            if (state is GetHistoryAbsensiLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetHistoryAbsensiFailed) {
              var message = state.message;
              return Center(child: Text(message, style: const TextStyle(fontFamily: 'JakartaSansMedium', color: Colors.red)));
            }
            if (state is GetHistoryAbsensiLoaded == false) {
              return const Center(child: Text("Silakan tekan Search", style: TextStyle(fontFamily: 'JakartaSansMedium', fontSize: 12, color: Colors.grey)));
            }
            if (state is GetHistoryAbsensiLoaded) {
              var data = state.model;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = data[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.attndCustName ?? "-", style: const TextStyle(fontFamily: "InterSemiBold", fontSize: 14)),
                                  if (item.attndType == "C")
                                    Text("Customer", style: const TextStyle(fontFamily: "InterMedium", fontSize: 12))
                                  else
                                    Text("Non Customer", style: const TextStyle(fontFamily: "InterMedium", fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                              child: Text(item.duration ?? "-", style: const TextStyle(fontFamily: "InterSemiBold", fontSize: 11, color: Colors.blue)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// INFO GRID
                        Row(
                          children: [
                            Expanded(child: _itemInfo("Tgl Checkin", item.attndDateIn != null ? formatDate3(item.attndDateIn!) : "-")),
                            Expanded(child: _itemInfo("Tgl Checkout", item.attndDateOut != null ? formatDate3(item.attndDateOut!) : "-")),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(child: _itemInfo("Jam Checkin", item.attndTimeIn != null ? formatDateToTime3(item.attndTimeIn!) : "-")),
                            Expanded(child: _itemInfo("Jam Checkout", item.attndTimeOut != null ? formatDateToTime3(item.attndTimeOut!) : "-")),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// FOTO
                        Row(
                          children: [
                            Expanded(child: _imageItem("Foto Checkin", "$url/storage/uploads/absensi/${item.attndImageIn}")),
                            Expanded(child: _imageItem("Foto Checkout", "$url/storage/uploads/absensi/${item.attndImageOut}")),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _itemInfo(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontFamily: "InterMedium", fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value ?? "-", style: const TextStyle(fontFamily: "InterSemiBold", fontSize: 12)),
      ],
    );
  }

  Widget _imageItem(String title, String? image) {
    return InkWell(
      onTap: () {
        showImagePreview(context: context, imageUrl: image);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: "InterMedium", fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                image == null
                    ? Container(width: 70, height: 70, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported, size: 20))
                    : Image.network(
                      image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Icon(Icons.image_not_supported, size: 20);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void showImagePreview({required BuildContext context, String? imageUrl}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "ImagePreview",
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child:
                        imageUrl != null
                            ? InteractiveViewer(
                              child: Image.network(
                                imageUrl,
                                // headers: {"ngrok-skip-browser-warning": "true"},
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) {
                                  return const Text('Gagal memuat gambar', style: TextStyle(color: Colors.white));
                                },
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                ),

                /// tombol close
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context)),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: ScaleTransition(scale: Tween<double>(begin: 0.95, end: 1).animate(anim1), child: child));
      },
    );
  }
}
