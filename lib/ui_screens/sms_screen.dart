import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageProvider with ChangeNotifier {
  List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  void addMessage(Map<String, String> message) {
    _messages.add(message);
    notifyListeners();
  }

  void loadMessages(List<Map<String, String>> loadedMessages) {
    _messages = loadedMessages;
    notifyListeners();
  }
}

class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  @override
  void initState() {
    super.initState();
    // Load messages from SharedPreferences when the screen initializes
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('messages') ?? [];
    final messages = storedMessages.map((m) {
      final split = m.split(': ');
      return {'sender': split[0], 'message': split[1]};
    }).toList();

    // Load messages into the MessageProvider
    Provider.of<MessageProvider>(context, listen: false).loadMessages(messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Listener'),
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          if (kDebugMode) {
            print('length:${messageProvider.messages.length}');
          }
          return ListView.builder(
            itemCount: messageProvider.messages.length,
            itemBuilder: (context, index) {
              final message = messageProvider.messages[index];
              return ListTile(
                title: Text(message['sender'] ?? 'Unknown'),
                subtitle: Text(message['message'] ?? 'No message'),
              );
            },
          );
        },
      ),
    );
  }
}
