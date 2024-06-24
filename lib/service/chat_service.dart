import 'dart:io';
import 'dart:typed_data';
import 'package:nanyang_application_desktop/model/chat.dart';
import 'package:nanyang_application_desktop/model/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  SupabaseClient supabase = Supabase.instance.client;

  SupabaseStreamBuilder getAdminMessage() {
    try {
      final stream = supabase.from('chat').stream(primaryKey: ['id_chat']);

      return stream;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  SupabaseStreamBuilder getUserMessage(int chatID) {
    try {
      final stream = supabase.from('pesan').stream(primaryKey: ['id_pesan']).eq('id_chat', chatID).order('waktu_kirim', ascending: false);

      return stream;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAdminChatList(List<dynamic> chatIds) async {
    try {
      final data = await supabase.from('chat').select('''
        *,
        user!inner(*,karyawan!inner(*, posisi!inner(*))),
        pesan!inner(*)
      ''').inFilter('id_chat', chatIds).limit(1, referencedTable: 'pesan').order('waktu_kirim', referencedTable: 'pesan', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendMessage(ChatModel chat, MessageModel model) async {
    try {
      String? path;
      if (model.file != null) {
        String fileName = model.file!.path.split('/').last;
        path = await supabase.storage.from('chat').upload(
              '${chat.id}/$fileName',
              model.file!,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
      }

      List<Map<String, dynamic>> message = await supabase.from('pesan').insert({
        'id_chat': chat.id,
        'id_user': model.userId,
        'is_admin': model.isAdmin,
        'pesan': model.message,
        'file': path,
        'waktu_kirim': DateTime.now().toIso8601String(),
      }).select('id_pesan');

      await supabase.from('chat').update({
        'id_pesan_terakhir': message[0]['id_pesan'],
        'jumlah_belum_dibaca': chat.unreadCount + 1,
      }).eq('id_chat', chat.id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Uint8List> downloadFile(String path) async {
    try {
      String bucketID = path.split('/')[0];
      String objectPath = path.split('/').sublist(1).join('/');
      Uint8List file = await supabase.storage.from(bucketID).download(objectPath);
      return file;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> readMessage(int id) async {
    try {
      await supabase.from('chat').update({
        'jumlah_belum_dibaca': 0,
      }).eq('id_chat', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}