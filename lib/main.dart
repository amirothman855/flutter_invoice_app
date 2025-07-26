import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: InvoiceApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class InvoiceApp extends StatefulWidget {
  @override
  _InvoiceAppState createState() => _InvoiceAppState();
}

class _InvoiceAppState extends State<InvoiceApp> {
  // المتحكمات لحقول الإدخال في رأس الفاتورة وتذييلها
  TextEditingController customerNameController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController previousDebtController = TextEditingController(); // للسابق (الدين السابق)
  TextEditingController collectionController = TextEditingController(); // للتحصيل (المبلغ المدفوع)

  // قائمة الأصناف الكاملة بناءً على 'نموذج فاتورة.xlsx - list.csv'
  // ملاحظة هامة: 'packPrice' هنا يُفترض أنه يمثل 'عدد القطع في العبوة الواحدة'
  // بناءً على معادلتك في الإكسل لحساب "العدد" الإجمالي (القطع).
  // إذا كان 'packPrice' يمثل السعر النقدي للعبوة، فستحتاج إلى عمود إضافي
  // في هذه القائمة يحدد عدد القطع في كل عبوة (مثلاً 'piecesPerPack').
  List<Map<String, dynamic>> itemsList = [
    {"name": "( T ) مشترك 1\\2", "unitPrice": 4.1, "packPrice": 350.0}, // تم تعديل packPrice ليتناسب مع عدد القطع في العبوة
    {"name": "( T ) مشترك 3\\4", "unitPrice": 6.15, "packPrice": 225.0},
    {"name": "( T ) مشترك 1", "unitPrice": 8.9, "packPrice": 150.0},
    {"name": "( T ) مشترك 2", "unitPrice": 26.95, "packPrice": 90.0},
    {"name": "( T ) مشترك 63", "unitPrice": 31.8, "packPrice": 70.0},
    {"name": "( T ) مشترك 75", "unitPrice": 44, "packPrice": 45.0},
    {"name": "( T ) مشترك 90", "unitPrice": 76, "packPrice": 26.0},
    {"name": "( T ) مشترك 110", "unitPrice": 118.2, "packPrice": 17.0},
    {"name": "( T ) مشترك 125", "unitPrice": 166.45, "packPrice": 12.0},
    {"name": "( T ) مشترك 160", "unitPrice": 322, "packPrice": 5.0},
    {"name": "( T ) مشترك 200", "unitPrice": 637, "packPrice": 3.0},
    {"name": "( T ) مشترك 160 خفيف", "unitPrice": 254, "packPrice": 5.0},
    {"name": "( T ) مشترك 125 خفيف", "unitPrice": 138.5, "packPrice": 12.0},
    {"name": "( T ) مشترك 110 خفيف", "unitPrice": 84.55, "packPrice": 17.0},
    {"name": "( T ) مسلوب 110\\2", "unitPrice": 78.3, "packPrice": 21.0},
    {"name": "( T ) مسلوب 110\\90", "unitPrice": 118.2, "packPrice": 17.0},
    {"name": "( T ) مسلوب 125\\110", "unitPrice": 159.75, "packPrice": 12.0},
    {"name": "( T ) مسلوب 125\\90", "unitPrice": 159.75, "packPrice": 12.0},
    {"name": "( T ) مسلوب 160\\125", "unitPrice": 304.75, "packPrice": 8.0},
    {"name": "( T ) مسلوب 160\\110", "unitPrice": 304.75, "packPrice": 8.0},
    {"name": "( T ) مسلوب 160\\90", "unitPrice": 304.75, "packPrice": 8.0},
    {"name": "( T ) مسلوب 200\\160", "unitPrice": 623, "packPrice": 3.0},
    {"name": "( T ) مسلوب 200\\110", "unitPrice": 623, "packPrice": 4.0},
    {"name": "( T ) مسلوب خفيف110\\90", "unitPrice": 84.55, "packPrice": 17.0},
    {"name": "جلبة 1\\2", "unitPrice": 2.1, "packPrice": 780.0},
    {"name": "جلبة 3\\4", "unitPrice": 3.5, "packPrice": 480.0},
    {"name": "جلبة 1", "unitPrice": 4.15, "packPrice": 350.0},
    {"name": "جلبة 2", "unitPrice": 9.8, "packPrice": 120.0},
    {"name": "جلبة 75", "unitPrice": 18.85, "packPrice": 130.0},
    {"name": "جلبة 90", "unitPrice": 27.5, "packPrice": 80.0},
    {"name": "جلبة 110", "unitPrice": 41.55, "packPrice": 50.0},
    {"name": "جلبة 160", "unitPrice": 84.75, "packPrice": 18.0},
    {"name": "كوع 1\\2", "unitPrice": 3.5, "packPrice": 600.0},
    {"name": "كوع 3\\4", "unitPrice": 4.2, "packPrice": 400.0},
    {"name": "كوع 1", "unitPrice": 6.25, "packPrice": 240.0},
    {"name": "كوع 50", "unitPrice": 10.6, "packPrice": 240.0},
    {"name": "كوع 2", "unitPrice": 17, "packPrice": 150.0},
    {"name": "كوع 63", "unitPrice": 22.4, "packPrice": 120.0},
    {"name": "كوع 75", "unitPrice": 35, "packPrice": 75.0},
    {"name": "كوع 90", "unitPrice": 59, "packPrice": 40.0},
    {"name": "كوع 110", "unitPrice": 99.9, "packPrice": 23.0},
    {"name": "كوع 125", "unitPrice": 139.8, "packPrice": 15.0},
    {"name": "كوع 160", "unitPrice": 246.5, "packPrice": 8.0},
    {"name": "كوع 200", "unitPrice": 460, "packPrice": 5.0},
    {"name": "كوع خفيف 160", "unitPrice": 199, "packPrice": 8.0},
    {"name": "كوع خفيف125", "unitPrice": 90, "packPrice": 19.0},
    {"name": "كوع خفيف110", "unitPrice": 68, "packPrice": 26.0},
    {"name": "بردة 63", "unitPrice": 15.8, "packPrice": 150.0},
    {"name": "بردة 90", "unitPrice": 30, "packPrice": 80.0},
    {"name": "بردة 110", "unitPrice": 43.35, "packPrice": 60.0},
    {"name": "بردة 125", "unitPrice": 57.1, "packPrice": 45.0},
    {"name": "بردة 160", "unitPrice": 96.5, "packPrice": 25.0},
    {"name": "بردة 200", "unitPrice": 231, "packPrice": 16.0},
    {"name": "فلنشة 63", "unitPrice": 27.3, "packPrice": 88.0},
    {"name": "فلنشة 90", "unitPrice": 42.15, "packPrice": 80.0},
    {"name": "فلنشة 110", "unitPrice": 54.4, "packPrice": 60.0},
    {"name": "فلنشة 125", "unitPrice": 75.6, "packPrice": 45.0},
    {"name": "فلنشة 160", "unitPrice": 93.5, "packPrice": 25.0},
    {"name": "فلنشة 200", "unitPrice": 231, "packPrice": 20.0},
    {"name": "بمبه 90\\2", "unitPrice": 36.1, "packPrice": 50.0},
    {"name": "دكر 2", "unitPrice": 20, "packPrice": 200.0},
    {"name": "دكر 63\\2", "unitPrice": 13, "packPrice": 200.0},
    {"name": "دكر 50\\2", "unitPrice": 9.1, "packPrice": 300.0},
    {"name": "نبل 2", "unitPrice": 11.8, "packPrice": 300.0},
    {"name": "صليبه 110", "unitPrice": 119, "packPrice": 14.0},
    {"name": "محبس 1 رمادى", "unitPrice": 30, "packPrice": 80.0},
    {"name": "محبس 1 أسود", "unitPrice": 22, "packPrice": 80.0},
    {"name": "محبس 2 أسود", "unitPrice": 42, "packPrice": 26.0},
    {"name": "محبس 2 رمادى", "unitPrice": 52, "packPrice": 22.0},
    {"name": "راس خط 63\\2", "unitPrice": 35.55, "packPrice": 50.0},
    {"name": "راس خط 75\\2", "unitPrice": 56.5, "packPrice": 35.0},
    {"name": "راس خط 75\\3", "unitPrice": 56.5, "packPrice": 35.0},
    {"name": "وصلة رباط 63", "unitPrice": 56.6, "packPrice": 30.0},
    {"name": "وصلة رباط 75", "unitPrice": 94.4, "packPrice": 16.0},
  ];

  // قائمة الأصناف التي تم اختيارها في الفاتورة
  List<Map<String, dynamic>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // تهيئة المتحكمات للاستماع للتغييرات وإعادة بناء الواجهة
    discountController.addListener(_updateTotals);
    previousDebtController.addListener(_updateTotals);
    collectionController.addListener(_updateTotals);
  }

  // دالة لإضافة صف جديد إلى الفاتورة
  void addNewRow() {
    setState(() {
      selectedItems.add({
        "selectedItem": null, // الصنف المختار (اسمه)
        "packQuantity": 0, // العدد شكارة
        "unitQuantity": 0, // العدد (القطع) - سيتم حسابه تلقائياً
        "unitPrice": 0.0, // سعر الوحدة
        "packPrice": 0.0, // سعر العبوة (أو عدد القطع في العبوة)
        "total": 0.0, // الإجمالي لهذا الصنف
        "packQuantityController": TextEditingController(text: "0"), // متحكم خاص لحقل "العدد شكارة" لكل صف
      });
    });
  }

  // دالة لتحديث البيانات عند اختيار صنف من القائمة المنسدلة
  void updateItemSelection(int index, String? itemName) {
    // البحث عن الصنف في قائمة الأصناف الرئيسية لجلب سعره
    final item = itemsList.firstWhere((element) => element["name"] == itemName);
    double unitPrice = item["unitPrice"];
    double packPrice = item["packPrice"]; // سعر العبوة (أو قطع في العبوة)

    setState(() {
      selectedItems[index]["selectedItem"] = itemName;
      selectedItems[index]["unitPrice"] = unitPrice;
      selectedItems[index]["packPrice"] = packPrice;
      // إعادة حساب الكميات والإجمالي بعد تغيير الصنف
      _recalculateQuantitiesAndTotal(index);
    });
  }

  // دالة لتحديث "العدد شكارة" وحساب "العدد (القطع)" تلقائياً
  void updatePackQuantity(int index, int packQty) {
    setState(() {
      selectedItems[index]["packQuantity"] = packQty;
      // تحديث النص في الـ TextEditingController المرتبط لضمان مزامنة الواجهة
      selectedItems[index]["packQuantityController"].text = packQty.toString();
      _recalculateQuantitiesAndTotal(index);
    });
  }

  // دالة مساعدة لإعادة حساب 'unitQuantity' و 'total' لكل صنف
  void _recalculateQuantitiesAndTotal(int index) {
    int packQty = selectedItems[index]["packQuantity"];
    double unitPrice = selectedItems[index]["unitPrice"];
    double packPrice = selectedItems[index]["packPrice"]; // يفترض هنا أنها عدد القطع في العبوة

    // حساب "العدد" (القطع) بناءً على "العدد شكارة" و "سعر العبوة" (عدد القطع في العبوة)
    int unitQty = 0;
    if (packPrice > 0) {
      unitQty = (packPrice * packQty).round();
    }
    selectedItems[index]["unitQuantity"] = unitQty;

    // حساب الإجمالي بناءً على "العدد" (القطع) وسعر الوحدة
    selectedItems[index]["total"] = unitQty * unitPrice;
  }

  // دالة مساعدة لتحديث جميع الإجماليات في التذييل
  void _updateTotals() {
    setState(() {
      // لا تحتاج إلى منطق هنا، فقط استدعاء setState كافٍ لإعادة بناء الواجهة
      // مما سيؤدي إلى إعادة حساب الدوال مثل getTotalBeforeDiscount()
    });
  }

  // حساب الإجمالي قبل الخصم
  double getTotalBeforeDiscount() {
    return selectedItems.fold(0, (sum, item) => sum + item["total"]);
  }

  // حساب الإجمالي بعد الخصم
  double getTotalAfterDiscount() {
    double total = getTotalBeforeDiscount();
    double discount = double.tryParse(discountController.text) ?? 0;
    return total - (total * discount / 100);
  }

  // حساب المبلغ المطلوب (السابق + الإجمالي بعد الخصم)
  double getRequiredAmount() {
    double previousDebt = double.tryParse(previousDebtController.text) ?? 0;
    return previousDebt + getTotalAfterDiscount();
  }

  // حساب المبلغ المتبقي (المطلوب - التحصيل)
  double getRemainingAmount() {
    double required = getRequiredAmount();
    double collection = double.tryParse(collectionController.text) ?? 0;
    return required - collection;
  }

  @override
  void dispose() {
    // التخلص من جميع المتحكمات لمنع تسرب الذاكرة
    customerNameController.dispose();
    discountController.dispose();
    previousDebtController.dispose();
    collectionController.dispose();
    for (var item in selectedItems) {
      item["packQuantityController"]?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فاتورة مبيعات'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0, // إزالة الظل من شريط التطبيق
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // رأس الفاتورة: اسم العميل والخصم
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: customerNameController,
                      decoration: InputDecoration(
                        labelText: "اسم العميل",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "الخصم (%)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.percent, color: Colors.blueAccent),
                      ),
                      // onChanged: (_) => setState(() {}), // تم نقل الاستماع إلى initState
                    ),
                  ],
                ),
              ),
            ),

            // زر إضافة صنف جديد
            ElevatedButton.icon(
              onPressed: addNewRow,
              icon: Icon(Icons.add),
              label: Text("إضافة صنف جديد", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // لون مميز للزر
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50), // زر بعرض كامل وارتفاع مناسب
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
            ),
            SizedBox(height: 16),

            // قائمة الأصناف المختارة (قابلة للتمرير)
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  var item = selectedItems[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "اختر الصنف",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  ),
                                  value: item["selectedItem"],
                                  isExpanded: true,
                                  items: itemsList.map((data) {
                                    return DropdownMenuItem<String>(
                                      value: data["name"],
                                      child: Text(data["name"], overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    updateItemSelection(index, value);
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              // زر حذف الصنف
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red.shade700, size: 28),
                                  onPressed: () {
                                    setState(() {
                                      // التخلص من المتحكم الخاص بالصف المحذوف لمنع تسرب الذاكرة
                                      item["packQuantityController"]?.dispose();
                                      selectedItems.removeAt(index);
                                    });
                                    _updateTotals(); // إعادة حساب الإجماليات بعد الحذف
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: item["packQuantityController"],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "العدد شكارة",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  ),
                                  onChanged: (val) {
                                    int packQty = int.tryParse(val) ?? 0;
                                    updatePackQuantity(index, packQty);
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("العدد (قطع): ${item["unitQuantity"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text("سعر الوحدة: ${item["unitPrice"].toStringAsFixed(2)}", style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                                    Text("سعر العبوة: ${item["packPrice"].toStringAsFixed(2)}", style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              // عرض الإجمالي لهذا الصنف
                              Text(
                                "الإجمالي: ${item["total"].toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // تذييل الفاتورة (الإجماليات والحسابات النهائية)
            Card(
              elevation: 4,
              margin: EdgeInsets.only(top: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("الإجمالي قبل الخصم:", style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text("${getTotalBeforeDiscount().toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: Text("الإجمالي بعد الخصم:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      trailing: Text("${getTotalAfterDiscount().toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18)),
                    ),
                    Divider(height: 20, thickness: 1),
                    TextField(
                      controller: previousDebtController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "السابق",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.history, color: Colors.orange),
                      ),
                      // onChanged: (_) => setState(() {}), // تم نقل الاستماع إلى initState
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      title: Text("المطلوب:", style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text("${getRequiredAmount().toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: collectionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "التحصيل",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.payments, color: Colors.teal),
                      ),
                      // onChanged: (_) => setState(() {}), // تم نقل الاستماع إلى initState
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      title: Text("الباقي:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      trailing: Text("${getRemainingAmount().toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20)),
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


