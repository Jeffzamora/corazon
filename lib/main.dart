import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(LoveApp());

class LoveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Para Mi Amor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.pacificoTextTheme(),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoveMessagesScreen()),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 1, end: 1.2),
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(Icons.favorite, color: Colors.red, size: 120),
                  );
                },
                onEnd: () {},
              ),
              SizedBox(height: 20),
              Text('Toca el corazón',
                  style: TextStyle(fontSize: 24, color: Colors.red[700])),
            ],
          ),
        ),
      ),
    );
  }
}

class LoveMessagesScreen extends StatefulWidget {
  @override
  _LoveMessagesScreenState createState() => _LoveMessagesScreenState();
}

class _LoveMessagesScreenState extends State<LoveMessagesScreen>
    with SingleTickerProviderStateMixin {
  final List<String> messages = [
    "Hola Mayra Quiero dedicarte unas palabras:",
    "Eres mi niña de ojos dulces",
    "Eres la persona que más amo",
    "Eres todo lo que quiero",
    "Eres mi sol en los días nublados",
    "Contigo todo es mejor",
    "Te amo más de lo que las palabras pueden decir",
    "Gracias por existir en mi vida",
    "Eres mi persona favorita",
    "Y por último...",
    "Esta canción describe cómo me enamoré de ti",
  ];
  int index = 0;
  bool _isButtonEnabled = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();
    _playMusic();
    _heartController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    )..repeat();
  }

  void _playMusic() async {
    await _audioPlayer.play(AssetSource('love_music.mp3'));
  }

  void _stopMusic() async {
    await _audioPlayer.stop();
  }

  void _nextMessage() {
    if (index < messages.length - 1) {
      setState(() {
        index++;
        _isButtonEnabled = false;
      });
    } else {
      _stopMusic();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FinalScreen()),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _heartController,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: HeartPainter(_heartController.value),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AnimatedTextKit(
                        key: ValueKey(index),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            messages[index],
                            textStyle: TextStyle(
                              fontSize: 28,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: Duration(milliseconds: 80),
                          ),
                        ],
                        totalRepeatCount: 1,
                        isRepeatingAnimation: false,
                        onFinished: () {
                          setState(() {
                            _isButtonEnabled = true;
                          });
                        },
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _isButtonEnabled ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: AnimatedScale(
                      scale: _isButtonEnabled ? 1.0 : 0.8,
                      duration: Duration(milliseconds: 500),
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled ? _nextMessage : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child:
                            Text('Siguiente', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Mayra Bocanegra',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinalScreen extends StatefulWidget {
  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/watch?v=LjhCEhWiKXk');
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _restartApp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoveApp()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.pink[100],
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_rounded, color: Colors.red, size: 80),
                  SizedBox(height: 20),
                  Text(
                    'Gracias por ver este pequeño regalo 💝',
                    style: TextStyle(fontSize: 24, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(child: player),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _restartApp,
                    icon: Icon(Icons.restart_alt),
                    label: Text('Verlo otra vez 💖'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HeartPainter extends CustomPainter {
  final double progress;
  final List<FloatingHeart> hearts;

  HeartPainter(this.progress)
      : hearts = List.generate(30, (_) => FloatingHeart());

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var heart in hearts) {
      double y = size.height * (1 - (progress + heart.offset) % 1.0);
      double x =
          heart.x * size.width + sin((progress + heart.offset) * 2 * pi) * 30;
      double sizeHeart = heart.size;
      paint.color = heart.color.withOpacity(0.5);
      _drawHeart(canvas, paint, Offset(x, y), sizeHeart);
    }
  }

  void _drawHeart(Canvas canvas, Paint paint, Offset center, double size) {
    Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.cubicTo(center.dx - size, center.dy - size, center.dx - size * 1.5,
        center.dy + size / 3, center.dx, center.dy + size);
    path.cubicTo(center.dx + size * 1.5, center.dy + size / 3, center.dx + size,
        center.dy - size, center.dx, center.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class FloatingHeart {
  final double x;
  final double size;
  final double offset;
  final Color color;

  FloatingHeart()
      : x = Random().nextDouble(),
        size = 10 + Random().nextDouble() * 15,
        offset = Random().nextDouble(),
        color = [
          Colors.red,
          Colors.pink,
          Colors.purple,
          Colors.deepPurple,
          Colors.pinkAccent
        ][Random().nextInt(5)];
}
