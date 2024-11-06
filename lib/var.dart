import 'package:flutter/material.dart';

double height = 0;
double width = 0;

List<int> numbers = [33, 55, 99];

List<String> backgroundImages = [
  'assets/images/mashged/1.png',
  'assets/images/mashged/2.png',
  'assets/images/mashged/3.png',
  'assets/images/mashged/4.png',
  'assets/images/mashged/5.png',
  'assets/images/mashged/6.png',
  'assets/images/mashged/7.png',
  'assets/images/mashged/8.png',
  'assets/images/mashged/9.png',
];

List<String> clickerImages = [
  'assets/images/clicker/1.png',
  'assets/images/clicker/2.png',
  'assets/images/clicker/3.png',
  'assets/images/clicker/4.png',
  'assets/images/clicker/5.png',
  'assets/images/clicker/6.png',
  'assets/images/clicker/7.png',
  'assets/images/clicker/8.png',
];

Widget chickImage = Image.asset(
  'assets/images/chick.png',
  fit: BoxFit.contain,
  width: (width - 200) / 5,
);

List<Widget> chickImages = [];

const String mosqueVideo = 'assets/videos/mosque_transition.mp4';
