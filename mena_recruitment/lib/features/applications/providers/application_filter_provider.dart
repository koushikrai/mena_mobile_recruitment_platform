import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationFilterProvider = StateProvider<String>((ref) => 'All');
