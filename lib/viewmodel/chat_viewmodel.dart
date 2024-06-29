import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/chat.dart';
import 'package:nanyang_application_desktop/model/message.dart';
import 'package:nanyang_application_desktop/service/chat_service.dart';
import 'package:nanyang_application_desktop/viewmodel/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService;
  ChatModel _selectedChat = ChatModel.empty();
  MessageModel _selectedMessage = MessageModel.empty();

  ChatViewModel({required ChatService chatService}) : _chatService = chatService;

  ChatModel get selectedChat => _selectedChat;
  MessageModel get selectedMessage => _selectedMessage;
  set selectedChat(ChatModel chat) {
    _selectedChat = chat;
    notifyListeners();
  }

  set selectedMessage(MessageModel message) {
    _selectedMessage = message;
    notifyListeners();
  }

  SupabaseStreamBuilder? getMessageStream(int chatID) {
    try {
      final stream = _chatService.getUserMessage(chatID);

      return stream;
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Message error: ${e.message}');
      } else {
        debugPrint('Get Message error: ${e.toString()}');
      }
      return null;
    }
  }

  SupabaseStreamBuilder? getChatStream() {
    try {
      final stream = _chatService.getAdminMessage();

      return stream;
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Message error: ${e.message}');
      } else {
        debugPrint('Get Message error: ${e.toString()}');
      }
      return null;
    }
  }

  Future<List<ChatModel>> getChat(List<Map<String, dynamic>> chats) async {
    try {
      List<Map<String, dynamic>> data = await _chatService.getAdminChatList(chats.map((e) => e['id_chat']).toList());

      return ChatModel.fromMapList(data);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Chat: ${e.message}');
      } else {
        debugPrint('Get Chat error: ${e.toString()}');
      }
      return [];
    }
  }

  Future<void> sendMessage(MessageModel model) async {
    try {
      _chatService.sendMessage(_selectedChat, model);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Send Message error: ${e.message}');
      } else {
        debugPrint('Send Message error: ${e.toString()}');
      }
    }
  }

  Future<void> downloadFile() async {
    try {
      String path = _selectedMessage.filePath!;
      String fileName = path.split('/').last;
      Uint8List file = await _chatService.downloadFile(path);

      File(fileName).writeAsBytes(file, flush: true);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Download File error: ${e.message}');
      } else {
        debugPrint('Download File error: ${e.toString()}');
      }
    }
  }

  Future<void> openChat(ChatModel model) async{
    selectedChat = model;
    await _chatService.readMessage(model.id);
  }

  void index(){
    selectedChat = ChatModel.empty();
    navigatorKey.currentContext!.read<DashboardViewmodel>().title = 'Help Chat';
  }
}