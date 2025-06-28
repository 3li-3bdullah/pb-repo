
// main.dart
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

// Add these classes after SurahInfo class
class QuranPage {
  final int pageNumber;
  final List<SurahContent> surahs;
  
  QuranPage({required this.pageNumber, required this.surahs});
}

class SurahContent {
  final SurahInfo surahInfo;
  final List<int> ayahsOnThisPage;
  final bool showBismillah;
  final bool showSurahHeader;
  
  SurahContent({
    required this.surahInfo,
    required this.ayahsOnThisPage,
    this.showBismillah = false,
    this.showSurahHeader = false,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holy Quran',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Arial',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: QuranHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
    );
  }
}

class QuranHomePage extends StatefulWidget {
  @override
  _QuranHomePageState createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  List<SurahInfo> surahs = [];
  List<SurahInfo> filteredSurahs = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  bool isPlayingFullSurah = false;
  bool isRepeating = false;
  bool isRepeatingSurah = false;
  int currentPlayingIndex = 0;
  List<int> playQueue = [];

  @override
  void initState() {
    super.initState();
    loadSurahData();
    searchController.addListener(_filterSurahs);
  }

  void loadSurahData() {
    // Complete Surah data - you can replace this with your full JSON data
    const String surahJsonData = '''[
    {
        "number": 1,
        "name": "ٱلْفَاتِحَةِ",
        "englishName": "Al-Faatiha",
        "englishNameTranslation": "The Opening",
        "numberOfAyahs": 7,
        "revelationType": "Meccan"
    },
    {
        "number": 2,
        "name": "البَقَرَةِ",
        "englishName": "Al-Baqara",
        "englishNameTranslation": "The Cow",
        "numberOfAyahs": 286,
        "revelationType": "Medinan"
    }]''';

    try {
      List<dynamic> jsonData = json.decode(surahJsonData);
      surahs = jsonData.map((json) => SurahInfo.fromJson(json)).toList();

      // If JSON data is incomplete, fill the rest with quran package data
      if (surahs.length < 114) {
        for (int i = surahs.length + 1; i <= 114; i++) {
          surahs.add(SurahInfo(
            number: i,
            name: quran.getSurahName(i),
            englishName: quran.getSurahNameEnglish(i),
            englishNameTranslation: quran.getSurahNameEnglish(i),
            numberOfAyahs: quran.getVerseCount(i),
            revelationType: _getRevelationType(i),
          ));
        }
      }

      filteredSurahs = surahs;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Fallback to using quran package data only
      for (int i = 1; i <= 114; i++) {
        surahs.add(SurahInfo(
          number: i,
          name: quran.getSurahName(i),
          englishName: quran.getSurahNameEnglish(i),
          englishNameTranslation: quran.getSurahNameEnglish(i),
          numberOfAyahs: quran.getVerseCount(i),
          revelationType: _getRevelationType(i),
        ));
      }
      filteredSurahs = surahs;
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterSurahs() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSurahs = surahs.where((surah) {
        return surah.name.toLowerCase().contains(query) ||
            surah.englishName.toLowerCase().contains(query) ||
            surah.englishNameTranslation.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xfff7e7d0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.green[700]),
              SizedBox(height: 16),
              Text(
                'Loading Quran...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xfff7e7d0),
      appBar: AppBar(
        title:
            Text('Holy Quran', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Surahs...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: filteredSurahs.length,
        itemBuilder: (context, index) {
          SurahInfo surah = filteredSurahs[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[700]!, Colors.green[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${surah.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              title: Text(
                surah.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    '${surah.englishName} • ${surah.englishNameTranslation}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: surah.revelationType == "Meccan"
                              ? Colors.orange[100]
                              : Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          surah.revelationType,
                          style: TextStyle(
                            fontSize: 10,
                            color: surah.revelationType == "Meccan"
                                ? Colors.orange[800]
                                : Colors.blue[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${surah.numberOfAyahs} verses',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.green[700]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahPage(surahInfo: surah),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SurahPage extends StatefulWidget {
  final SurahInfo surahInfo;

  const SurahPage({Key? key, required this.surahInfo}) : super(key: key);

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> with TickerProviderStateMixin {
  late AudioPlayer audioPlayer;
  int? selectedAyah;
  int? playingAyah;
  bool isPlaying = false;
  bool isLoading = false;
  bool isPaused = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double fontSize = 22.0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int selectedReciter = 0;
  PageController? _versePageController;
  int currentVersePage = 0;

  List<QuranPage> quranPages = [];
int currentPageIndex = 0;

  // ADD THESE NEW VARIABLES HERE:
  bool isPlayingFullSurah = false;
  bool isRepeating = false;
  bool isRepeatingSurah = false;
  int currentPlayingIndex = 0;
  List<int> playQueue = [];

  // Audio settings
  List<String> reciters = [
    'Alafasy_128kbps',
    'Abdul_Basit_Murattal_192kbps',
    'Husary_128kbps',
    'Minshawi_Murattal_128kbps',
    'Sudais_192kbps',
  ];

  List<String> reciterNames = [
    'Mishary Rashid Alafasy',
    'Abdul Basit Abdul Samad',
    'Mahmoud Khalil Al-Husary',
    'Mohamed Siddiq El-Minshawi',
    'Abdul Rahman Al-Sudais',
  ];

  late PageController _pageController;
  late SurahInfo currentSurah;
  List<SurahInfo> allSurahs = [];

  @override
  void initState() {
    super.initState();
    currentSurah = widget.surahInfo;
    _initializeAllSurahs();
    _pageController = PageController();
    _versePageController = PageController();
    audioPlayer = AudioPlayer();
    _setupAudioPlayer();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadSettings();
  }

  void _setupAudioPlayer() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        isPaused = state == PlayerState.paused;
        if (state == PlayerState.completed) {
          // Move to next ayah in queue
          if (isRepeating && !isPlayingFullSurah) {
            // Repeat the same ayah
            _playFromQueue();
          } else if (isPlayingFullSurah ||
              currentPlayingIndex < playQueue.length - 1) {
            currentPlayingIndex++;
            _playFromQueue();
          } else {
            playingAyah = null;
            isPlaying = false;
            isPaused = false;
            isPlayingFullSurah = false;
            _pulseController.stop();
          }
        }
      });

      if (state == PlayerState.playing) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
      }
    });

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });
  }
Future<void> _initializeAllSurahs() async {
  final surahsJson = await rootBundle.loadString('assets/data/surahs.json');
  final surahs = json.decode(surahsJson);
  log('the xquran length is ${surahs.length}');
  
  for (int i = 1; i <= 114; i++) {
    allSurahs.add(SurahInfo(
      number: i,
      name: surahs[i - 1]['name'],
      englishName: quran.getSurahNameEnglish(i),
      englishNameTranslation: quran.getSurahNameEnglish(i),
      numberOfAyahs: quran.getVerseCount(i),
      revelationType: _getRevelationType(i),
    ));
  }
  
  // Generate Quran pages after loading surahs
  _generateQuranPages();
}
void _generateQuranPages() {
  quranPages.clear();
  int currentPage = 1;
  
  // Define which surahs should be grouped together (like real Quran)
  Map<int, List<int>> pageGroupings = {
    // Last 3 surahs on one page
    604: [112, 113, 114], // Al-Ikhlas, Al-Falaq, An-Nas
    603: [110, 111], // An-Nasr, Al-Masad
    602: [108, 109], // Al-Kawthar, Al-Kafirun
    601: [106, 107], // Quraysh, Al-Ma'un
    600: [104, 105], // Al-Humazah, Al-Fil
    599: [102, 103], // At-Takathur, Al-Asr
    598: [100, 101], // Al-Adiyat, Al-Qari'ah
    597: [97, 98, 99], // Al-Qadr, Al-Bayyina, Az-Zalzala
    // Add more groupings as needed
  };
  
  // Process special grouped pages first
  Set<int> processedSurahs = {};
  
  pageGroupings.forEach((pageNum, surahNumbers) {
    List<SurahContent> pageSurahs = [];
    
    for (int i = 0; i < surahNumbers.length; i++) {
      int surahNum = surahNumbers[i];
      SurahInfo surah = allSurahs[surahNum - 1];
      
      pageSurahs.add(SurahContent(
        surahInfo: surah,
        ayahsOnThisPage: List.generate(surah.numberOfAyahs, (index) => index + 1),
        showBismillah: i == 0 && surahNum != 1 && surahNum != 9,
        showSurahHeader: true,
      ));
      
      processedSurahs.add(surahNum);
    }
    
    quranPages.add(QuranPage(pageNumber: pageNum, surahs: pageSurahs));
  });
  
  // Process remaining surahs (longer ones get their own pages)
  for (int i = 1; i <= 114; i++) {
    if (!processedSurahs.contains(i)) {
      SurahInfo surah = allSurahs[i - 1];
      
      if (surah.numberOfAyahs <= 10) {
        // Small surahs might be grouped (if not already processed)
        quranPages.add(QuranPage(
          pageNumber: currentPage++,
          surahs: [
            SurahContent(
              surahInfo: surah,
              ayahsOnThisPage: List.generate(surah.numberOfAyahs, (index) => index + 1),
              showBismillah: surah.number != 1 && surah.number != 9,
              showSurahHeader: true,
            )
          ],
        ));
      } else {
        // Longer surahs get divided into multiple pages
        const int versesPerPage = 7;
        int totalPages = (surah.numberOfAyahs / versesPerPage).ceil();
        
        for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
          int startVerse = (pageIndex * versesPerPage) + 1;
          int endVerse = ((pageIndex + 1) * versesPerPage).clamp(1, surah.numberOfAyahs);
          
          List<int> versesOnPage = [];
          for (int v = startVerse; v <= endVerse; v++) {
            versesOnPage.add(v);
          }
          
          quranPages.add(QuranPage(
            pageNumber: currentPage++,
            surahs: [
              SurahContent(
                surahInfo: surah,
                ayahsOnThisPage: versesOnPage,
                showBismillah: pageIndex == 0 && surah.number != 1 && surah.number != 9,
                showSurahHeader: pageIndex == 0,
              )
            ],
          ));
        }
      }
    }
  }
  
  // Sort pages by page number
  quranPages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
  
  // Find current surah's page
  for (int i = 0; i < quranPages.length; i++) {
    if (quranPages[i].surahs.any((s) => s.surahInfo.number == currentSurah.number)) {
      currentPageIndex = i;
      break;
    }
  }
}

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('fontSize') ?? 22.0;
      selectedReciter = prefs.getInt('selectedReciter') ?? 0;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    await prefs.setInt('selectedReciter', selectedReciter);
  }

  String getAudioUrl(int surahNumber, int ayahNumber) {
    String surahPadded = surahNumber.toString().padLeft(3, '0');
    String ayahPadded = ayahNumber.toString().padLeft(3, '0');
    String reciter = reciters[selectedReciter];
    return 'https://everyayah.com/data/$reciter/$surahPadded$ayahPadded.mp3';
  }

  Future<void> playAyah(int ayahNumber, {bool isFullSurah = false}) async {
    if (!isFullSurah && playingAyah == ayahNumber) {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.resume();
      }
      return;
    }

    setState(() {
      isLoading = true;
      isPlayingFullSurah = isFullSurah;
    });

    if (isFullSurah) {
      // Setup queue for full surah
      playQueue =
          List.generate(currentSurah.numberOfAyahs, (index) => index + 1);
      currentPlayingIndex = ayahNumber - 1;
    } else {
      playQueue = [ayahNumber];
      currentPlayingIndex = 0;
    }

    await _playFromQueue();
  }

  Future<void> _playFromQueue() async {
    if (currentPlayingIndex >= playQueue.length) {
      if (isRepeatingSurah && isPlayingFullSurah) {
        currentPlayingIndex = 0;
      } else if (isRepeating && !isPlayingFullSurah) {
        // Keep playing the same ayah
      } else {
        await stopAudio();
        return;
      }
    }

    int ayahNumber = playQueue[currentPlayingIndex];

    try {
      String audioUrl = getAudioUrl(currentSurah.number, ayahNumber);

      final response = await http.head(Uri.parse(audioUrl));

      if (response.statusCode == 200) {
        await audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          playingAyah = ayahNumber;
        });
      } else {
        throw Exception('Audio not found');
      }
    } catch (e) {
      _showErrorSnackBar(
          'Unable to load audio. Please check your internet connection.');
      await stopAudio();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      playingAyah = null;
      isPlaying = false;
      isPaused = false;
      isPlayingFullSurah = false;
      isRepeating = false;
      isRepeatingSurah = false;
      position = Duration.zero;
      playQueue.clear();
      currentPlayingIndex = 0;
    });
    _pulseController.stop();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showAyahOptions(int ayahNumber) {
    setState(() {
      selectedAyah = selectedAyah == ayahNumber ? null : ayahNumber;
    });

    if (selectedAyah != null) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

//ToDo: just decorate the page details + when play ayah i should move into the next page
  Widget _buildVersePage(SurahInfo surah, int pageIndex, int versesPerPage) {
    int startVerse = (pageIndex * versesPerPage) + 1;
    int endVerse =
        ((pageIndex + 1) * versesPerPage).clamp(1, surah.numberOfAyahs);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Bismillah (only on first page and not for Surah 9 or 1)
          if (pageIndex == 0 && surah.number != 9 && surah.number != 1)
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/surahBorder.png',
                      color: Colors.teal,
                    ),
                    Positioned(
                        child: Text(
                      surah.name,
                      style:
                          TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18),
                    )),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.14,
                      child: Column(
                        children: [
                          Text(
                            'اباتها',
                            style: TextStyle(
                                fontFamily: 'UthmanicHafs', fontSize: 8),
                          ),
                          Text(
                            surah.numberOfAyahs.toString(),
                            style: TextStyle(
                                fontFamily: 'UthmanicHafs', fontSize: 8),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.14,
                      child: Column(
                        children: [
                          Text(
                            'ترتيبها',
                            style: TextStyle(
                                fontFamily: 'UthmanicHafs', fontSize: 8),
                          ),
                          Text(
                            surah.number.toString(),
                            style: TextStyle(
                                fontFamily: 'UthmanicHafs', fontSize: 8),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                  style: TextStyle(
                    fontSize: fontSize + 2,
                    height: 2.0,
                    fontFamily: 'UthmanicHafs',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),

          // Verses container
          Expanded(
            child: Container(
              // padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xfff7e7d0),
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.black.withOpacity(0.05),
                  //   blurRadius: 8,
                  //   offset: Offset(0, 2),
                  // ),
                ],
              ),
              child: SingleChildScrollView(
                child: RichText(
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    children: _buildPageVerses(surah, startVerse, endVerse),
                  ),
                ),
              ),
            ),
          ),

          // Page number indicator
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              'Page ${pageIndex + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),

          // Bottom padding for audio controls
          SizedBox(height: selectedAyah != null ? 140 : 20),
        ],
      ),
    );
  }

  List<TextSpan> _buildPageVerses(
      SurahInfo surah, int startVerse, int endVerse) {
    List<TextSpan> spans = [];

    for (int i = startVerse; i <= endVerse; i++) {
      String ayahText = quran.getVerse(surah.number, i);
      bool isCurrentlyPlaying =
          playingAyah == i && currentSurah.number == surah.number;

      spans.add(
        TextSpan(
          text: ayahText,
          style: TextStyle(
            fontSize: fontSize,
            wordSpacing: -2.5,
            fontFamily: 'KFGQPC Uthmanic Script HAFS Regular',
            fontWeight: FontWeight.w500,
            color: isCurrentlyPlaying ? Colors.green[800] : Colors.black87,
            backgroundColor: isCurrentlyPlaying ? Colors.green[100] : null,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _showAyahOptions(i),
        ),
      );

      // Add ayah number
      spans.add(
        TextSpan(
          text: quran.getVerseEndSymbol(
            i,
          ), // '﴿${convertToArabicNumber(i.toString())}﴾',
          style: TextStyle(
            fontSize: fontSize - 2,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _showAyahOptions(i),
        ),
      );

      // Add space between ayahs except for the last one
      // if (i < endVerse) {
      //   spans.add(
      //     TextSpan(
      //       text: ' ',
      //       style: TextStyle(fontSize: fontSize),
      //     ),
      //   );
      // }
    }

    return spans;
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(Icons.settings, color: Colors.green[700]),
                  SizedBox(width: 8),
                  Text('Audio Settings'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Reciter:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Column(
                        children: reciterNames.asMap().entries.map((entry) {
                          int index = entry.key;
                          String name = entry.value;
                          return RadioListTile<int>(
                            title: Text(name, style: TextStyle(fontSize: 14)),
                            value: index,
                            groupValue: selectedReciter,
                            activeColor: Colors.green[700],
                            onChanged: (int? value) {
                              setDialogState(() {
                                selectedReciter = value!;
                              });
                              setState(() {
                                selectedReciter = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Font Size: ${fontSize.round()}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Slider(
                    value: fontSize,
                    min: 16.0,
                    max: 32.0,
                    divisions: 8,
                    activeColor: Colors.green[700],
                    onChanged: (double value) {
                      setDialogState(() {
                        fontSize = value;
                      });
                      setState(() {
                        fontSize = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveSettings();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Settings saved successfully'),
                        backgroundColor: Colors.green[700],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    _versePageController?.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  if (quranPages.isEmpty) {
    return Scaffold(
      backgroundColor: Color(0xfff7e7d0),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  return Scaffold(
    backgroundColor: Color(0xfff7e7d0),
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Page ${quranPages[currentPageIndex].pageNumber}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '${quranPages[currentPageIndex].surahs.map((s) => s.surahInfo.englishName).join(", ")}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: currentPageIndex > 0
              ? () {
                  setState(() {
                    currentPageIndex--;
                    _updateCurrentSurah();
                  });
                }
              : null,
          tooltip: 'Previous Page',
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: currentPageIndex < quranPages.length - 1
              ? () {
                  setState(() {
                    currentPageIndex++;
                    _updateCurrentSurah();
                  });
                }
              : null,
          tooltip: 'Next Page',
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: _showSettingsDialog,
          tooltip: 'Settings',
        ),
        if (isPlaying || isPaused)
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: stopAudio,
            tooltip: 'Stop Audio',
          ),
      ],
    ),
    body: Stack(
      children: [
        PageView.builder(
          itemCount: quranPages.length,
          controller: PageController(initialPage: currentPageIndex),
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
              _updateCurrentSurah();
              stopAudio();
              selectedAyah = null;
            });
          },
          itemBuilder: (context, index) {
            return _buildQuranPage(quranPages[index]);
          },
        ),
        
        // Keep your existing audio control overlay here
        if (selectedAyah != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Keep your existing audio controls here
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[700]!, Colors.green[500]!],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Verse $selectedAyah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        if (isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Add your existing control buttons here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: Icons.copy,
                          label: 'Copy',
                          onPressed: () {
                            // Find which surah contains the selected ayah
                            SurahInfo? targetSurah;
                            for (var surahContent in quranPages[currentPageIndex].surahs) {
                              if (surahContent.ayahsOnThisPage.contains(selectedAyah!)) {
                                targetSurah = surahContent.surahInfo;
                                break;
                              }
                            }
                            
                            if (targetSurah != null) {
                              String ayahText = quran.getVerse(targetSurah.number, selectedAyah!);
                              Clipboard.setData(ClipboardData(text: ayahText));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Verse copied to clipboard'),
                                  backgroundColor: Colors.green[700],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                          },
                        ),
                        _buildControlButton(
                          icon: playingAyah == selectedAyah
                              ? (isPlaying ? Icons.pause : Icons.play_arrow)
                              : Icons.play_arrow,
                          label: playingAyah == selectedAyah
                              ? (isPlaying ? 'Pause' : 'Resume')
                              : 'Play',
                          isPrimary: true,
                          onPressed: isLoading ? null : () {
                            // Find which surah contains the selected ayah
                            SurahInfo? targetSurah;
                            for (var surahContent in quranPages[currentPageIndex].surahs) {
                              if (surahContent.ayahsOnThisPage.contains(selectedAyah!)) {
                                targetSurah = surahContent.surahInfo;
                                currentSurah = targetSurah;
                                break;
                              }
                            }
                            if (targetSurah != null) {
                              playAyah(selectedAyah!, isFullSurah: false);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
void _updateCurrentSurah() {
  if (quranPages.isNotEmpty && currentPageIndex < quranPages.length) {
    // Update current surah to the first surah on the current page
    currentSurah = quranPages[currentPageIndex].surahs.first.surahInfo;
  }
}

Widget _buildQuranPage(QuranPage page) {
  return Container(
    margin: EdgeInsets.all(16),
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: page.surahs.map((surahContent) => 
                _buildSurahContentOnPage(surahContent)).toList(),
            ),
          ),
        ),
        // Page number at bottom
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Text(
            'Page ${page.pageNumber}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: selectedAyah != null ? 140 : 20),
      ],
    ),
  );
}

Widget _buildSurahContentOnPage(SurahContent surahContent) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    child: Column(
      children: [
        // Surah header (if it's the beginning of a surah)
        if (surahContent.showSurahHeader)
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/surahBorder.png',
                  color: Colors.teal,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        surahContent.surahInfo.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  child: Text(
                    surahContent.surahInfo.name,
                    style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        
        // Bismillah (if needed)
        if (surahContent.showBismillah)
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Text(
              'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
              style: TextStyle(
                fontSize: fontSize + 2,
                height: 2.0,
                fontFamily: 'UthmanicHafs',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        
        // Verses
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xfff7e7d0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: RichText(
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            text: TextSpan(
              children: _buildSurahVerses(surahContent),
            ),
          ),
        ),
      ],
    ),
  );
}

List<TextSpan> _buildSurahVerses(SurahContent surahContent) {
  List<TextSpan> spans = [];
  
  for (int ayahNumber in surahContent.ayahsOnThisPage) {
    String ayahText = quran.getVerse(surahContent.surahInfo.number, ayahNumber);
    bool isCurrentlyPlaying = playingAyah == ayahNumber && 
                             currentSurah.number == surahContent.surahInfo.number;

    spans.add(
      TextSpan(
        text: ayahText,
        style: TextStyle(
          fontSize: fontSize,
          wordSpacing: -2.5,
          fontFamily: 'KFGQPC Uthmanic Script HAFS Regular',
          fontWeight: FontWeight.w500,
          color: isCurrentlyPlaying ? Colors.green[800] : Colors.black87,
          backgroundColor: isCurrentlyPlaying ? Colors.green[100] : null,
        ),
        recognizer: TapGestureRecognizer()..onTap = () {
          // Update current surah when ayah is tapped
          currentSurah = surahContent.surahInfo;
          _showAyahOptions(ayahNumber);
        },
      ),
    );

    // Add ayah number
    spans.add(
      TextSpan(
        text: quran.getVerseEndSymbol(ayahNumber),
        style: TextStyle(
          fontSize: fontSize - 2,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()..onTap = () {
          currentSurah = surahContent.surahInfo;
          _showAyahOptions(ayahNumber);
        },
      ),
    );
  }

  return spans;
}
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isPrimary ? Colors.green[700] : Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: isPrimary ? Colors.white : Colors.grey[700],
              size: 24,
            ),
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isPrimary ? Colors.green[700] : Colors.grey[600],
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

String _getRevelationType(int surahNumber) {
  // Meccan surahs (based on traditional order)
  List<int> meccanSurahs = [
    1,
    6,
    7,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    23,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    67,
    68,
    69,
    70,
    71,
    72,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    90,
    91,
    92,
    93,
    94,
    95,
    96,
    97,
    100,
    101,
    102,
    103,
    104,
    105,
    106,
    107,
    108,
    109,
    111,
    112,
    113,
    114
  ];
  return meccanSurahs.contains(surahNumber) ? "Meccan" : "Medinan";
}
