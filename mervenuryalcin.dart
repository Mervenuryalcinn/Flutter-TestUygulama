import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(BilgiYarismasiUygulamasi());
}

class BilgiYarismasiUygulamasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bilgi Yarışması',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFF0F0F5),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,//arka plan rengi
            foregroundColor: Colors.white,//yazı rengi
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 22, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
      home: BilgiYarismasiSayfasi(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BilgiYarismasiSayfasi extends StatefulWidget {
  @override
  _BilgiYarismasiSayfasiState createState() => _BilgiYarismasiSayfasiState();
}

class _BilgiYarismasiSayfasiState extends State<BilgiYarismasiSayfasi> {
  List<Soru> sorular = [
    Soru('Türkiye’nin başkenti neresidir?', ['Ankara', 'İstanbul', 'İzmir', 'Bursa', 'Antalya'], 0),
    Soru('Dart dili hangi firma tarafından geliştirilmiştir?', ['Microsoft', 'Facebook', 'Apple', 'Google', 'Amazon'], 3),
    Soru('En büyük gezegen hangisidir?', ['Dünya', 'Venüs', 'Mars', 'Jüpiter', 'Satürn'], 3),
    Soru('Flutter ile mobil uygulama hangi dille yazılır?', ['Java', 'Python', 'C++', 'Swift', 'Dart'], 4),
    Soru('Türkiye kaç bölgeden oluşur?', ['5', '6', '7', '8', '9'], 2),
    Soru('İlk 10 doğal sayı toplamı kaçtır?', ['40', '55', '60', '50', '45'], 1),
    Soru('Hangisi bir programlama dili değildir?', ['Python', 'HTML', 'Java', 'C#', 'Swift'], 1),
    Soru('Türk bayrağında hangi renk yoktur?', ['Kırmızı', 'Beyaz', 'Mavi', 'Yok', 'Hepsi var'], 2),
    Soru('1 GB kaç MB\'dir?', ['1000', '1024', '512', '2048', '256'], 1),
    Soru('Flutter hangi tür uygulama geliştirmeye uygundur?', ['Web', 'Mobil', 'Masaüstü', 'Hepsi', 'Hiçbiri'], 3),
  ];

  int mevcutSoruIndex = 0;
  int puan = 0;
  bool yarismaBitti = false;
  bool yarismaBasladi = false;
  int kalanSure = 20;
  Timer? zamanlayici;

  void zamanlayiciyiBaslat() {
    zamanlayici?.cancel();
    kalanSure = 20;
    zamanlayici = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (kalanSure > 0) {
          kalanSure--;
        } else {
          timer.cancel();
          sonrakiSoruyaGec();
        }
      });
    });
  }

  void soruyuCevapla(int secilenIndex) {
    if (sorular[mevcutSoruIndex].dogruSecenekIndex == secilenIndex) {
      puan += 10;
    }
    sonrakiSoruyaGec();
  }

  void sonrakiSoruyaGec() {
    zamanlayici?.cancel();
    if (mevcutSoruIndex < sorular.length - 1) {
      setState(() {
        mevcutSoruIndex++;
      });
      zamanlayiciyiBaslat();
    } else {
      setState(() {
        yarismaBitti = true;
      });
    }
  }

  void yarismayiSifirla() {
    setState(() {
      mevcutSoruIndex = 0;
      puan = 0;
      yarismaBitti = false;
      yarismaBasladi = false;
    });
  }

  void yarismayiBaslat() {
    setState(() {
      yarismaBasladi = true;
    });
    zamanlayiciyiBaslat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          "Bilgi Yarışması",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: yarismaBasladi
            ? (yarismaBitti
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 100),
              SizedBox(height: 20),
              Text(
                'Yarışma Bitti!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Toplam Puanınız: $puan',
                style: TextStyle(fontSize: 26),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: yarismayiSifirla,
                child: Text('Yeniden Başla'),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Soru ${mevcutSoruIndex + 1}/${sorular.length}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Kalan Süre: $kalanSure saniye',
                style: TextStyle(color: Colors.redAccent, fontSize: 18)),
            Divider(thickness: 2, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              sorular[mevcutSoruIndex].soruMetni,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 30),
            ...List.generate(5, (index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => soruyuCevapla(index),
                  child: Text(sorular[mevcutSoruIndex].secenekler[index]),
                ),
              );
            }),
          ],
        ))
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz, size: 100, color: Colors.deepPurpleAccent),
              SizedBox(height: 20),
              Text(
                "Sınava Hazır Mısın?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: yarismayiBaslat,
                child: Text("Başla"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Soru {
  final String soruMetni;
  final List<String> secenekler;
  final int dogruSecenekIndex;

  Soru(this.soruMetni, this.secenekler, this.dogruSecenekIndex);
}
