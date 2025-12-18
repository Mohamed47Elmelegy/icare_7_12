import 'package:flutter/material.dart';

@immutable
abstract class ChatState {
  const ChatState();
}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatSuccessfullyState extends ChatState {}

class ChatErrorState extends ChatState {
  final String errors;

  const ChatErrorState({required this.errors});
}
