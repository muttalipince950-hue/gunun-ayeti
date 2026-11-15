import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const GununAyetiApp());
}

class AyetModel {
  final String arapca;
  final String meal;
  final String kaynak;

  const AyetModel({
    required this.arapca,
    required this.meal,
    required this.kaynak,
  });
}

final List<AyetModel> ayetlerListesi = [
  const AyetModel(
    arapca: "فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ",
    meal: "Öyleyse beni anın ki ben de sizi anayım. Bana şükredin, sakın nankörlük etmeyin.",
    kaynak: "Bakara Suresi, 152",
  ),
  const AyetModel(
    arapca: "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
    meal: "Bilesiniz ki kalpler ancak Allah’ı anmakla huzur bulur.",
    kaynak: "Ra’d Suresi, 28",
  ),
  const AyetModel(
    arapca: "وَمَنْ يَتَّقِ اللَّهَ يَجْعَلْ لَهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ",
    meal: "Kim Allah’a karşı gelmekten sakınırsa, Allah ona bir çıkış yolu açar ve onu beklemediği yerden rızıklandırır.",
    kaynak: "Talâk Suresi, 2-3",
  ),
  const AyetModel(
    arapca: "إِنَّ مَعَ الْعُسْرِ يُسْرًا",
    meal: "Şüphesiz güçlükle beraber bir kolaylık vardır.",
    kaynak: "İnşirah Suresi, 6",
  ),
  const AyetModel(
    arapca: "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي",
    meal: "Rabbim! Göğsümü genişlet, işimi bana kolaylaştır.",
    kaynak: "Tâhâ Suresi, 25-26",
  ),
];

class GununAyetiApp extends StatelessWidget {
  const GununAyetiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Günün Ayeti 4K',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B131F),
        primarySwatch: Colors.amber,
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int currentIndex = 0;
  bool isGenerating4K = false;

  AyetModel get aktifAyet {
    // Yılın gününe göre otomatik günün ayetini seç
    final now = DateTime.now();
    final dayOfYear = int.parse(DateFormat("D").format(now));
    return ayetlerListesi[(dayOfYear + currentIndex) % ayetlerListesi.length];
  }

  void sonrakiAyet() {
    setState(() {
      currentIndex++;
    });
  }

  // 4K (2160x3840) Çözünürlükte Görsel Üreten Motor
  Future<void> duvarKagidiUretVeIndir() async {
    setState(() => isGenerating4K = true);

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // 4K Boyutlar
      const double width = 2160;
      const double height = 3840;
      final size = const Size(width, height);

      // 1. Arka Plan (Zümrüt & Gece Laciverti Gradyanı)
      final bgPaint = Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 0),
          Offset(0, height),
          [
            const Color(0xFF041C14),
            const Color(0xFF0B131F),
            const Color(0xFF02060B),
          ],
        );
      canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

      // 2. Geleneksel Altın Varak Çerçeve
      final borderPaint = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16.0;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(100, 100, width - 200, height - 200),
          const Radius.circular(60),
        ),
        borderPaint,
      );

      // İç İnce Çerçeve
      final innerBorderPaint = Paint()
        ..color = const Color(0xFFD4AF37).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(130, 130, width - 260, height - 260),
          const Radius.circular(45),
        ),
        innerBorderPaint,
      );

      // 3. Başlık / Süsleme
      final textPainterHeader = TextPainter(
        text: const TextSpan(
          text: "• GÜNÜN AYETİ •",
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 52,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainterHeader.layout(minWidth: 0, maxWidth: width - 400);
      textPainterHeader.paint(canvas, Offset((width - textPainterHeader.width) / 2, 350));

      // 4. Arapça Hat Metni
      final textPainterArabic = TextPainter(
        text: TextSpan(
          text: aktifAyet.arapca,
          style: const TextStyle(
            color: Color(0xFFFFF8E7),
            fontSize: 90,
            height: 1.6,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      );
      textPainterArabic.layout(minWidth: 0, maxWidth: width - 400);
      textPainterArabic.paint(canvas, Offset((width - textPainterArabic.width) / 2, 850));

      // 5. Türkçe Meal Metni
      final textPainterMeal = TextPainter(
        text: TextSpan(
          text: "“${aktifAyet.meal}”",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 70,
            height: 1.5,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainterMeal.layout(minWidth: 0, maxWidth: width - 500);
      textPainterMeal.paint(canvas, Offset((width - textPainterMeal.width) / 2, 1800));

      // 6. Kaynak / Sure Bilgisi
      final textPainterSource = TextPainter(
        text: TextSpan(
          text: "— ${aktifAyet.kaynak}",
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 56,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainterSource.layout(minWidth: 0, maxWidth: width - 400);
      textPainterSource.paint(canvas, Offset((width - textPainterSource.width) / 2, 2600));

      // Resmi Tamamla
      final picture = recorder.endRecording();
      final img = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      if (kIsWeb) {
        // Web ortamı simülasyonu
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("4K Duvar Kağıdı başarıyla oluşturuldu!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata oluştu: $e")),
        );
      }
    } finally {
      setState(() => isGenerating4K = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Günün İslami Duvar Kağıdı (4K)"),
        centerTitle: true,
        backgroundColor: const Color(0xFF041C14),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111E2E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "• GÜNÜN AYETİ •",
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 14,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      aktifAyet.arapca,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        height: 1.6,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFF8E7),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "“${aktifAyet.meal}”",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.4,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "— ${aktifAyet.kaynak}",
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isGenerating4K ? null : duvarKagidiUretVeIndir,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: isGenerating4K
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.wallpaper),
              label: Text(
                isGenerating4K ? "4K Görsel Hazırlanıyor..." : "4K Duvar Kağıdı Oluştur & İndir",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: sonrakiAyet,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: Color(0xFFD4AF37)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Sonraki Ayeti Gör",
                style: TextStyle(color: Color(0xFFD4AF37), fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
