import 'package:flutter/material.dart';
import 'package:untitled/login.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splash.mp4')
      ..initialize().then((_) {
        // Ensure the video loops
        _controller.setLooping(true);
        // Start playing the video
        _controller.play();
        // Once the video has finished playing, navigate to the next screen
        _controller.addListener(() {
          if (_controller.value.isPlaying && !_controller.value.isLooping) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
          }
        });
        // Update the state once the video is initialized
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(), // Or another loading indicator
      ),
    );
  }
}