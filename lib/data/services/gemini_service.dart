import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for interacting with Google Gemini API
/// Configured with Lumica persona for mental health support
class GeminiService {
  late GenerativeModel _model;
  late ChatSession _chat;

  // Rate limiting to prevent API abuse
  static const _apiThrottle = Duration(seconds: 2);
  DateTime? _lastRequestTime;

  /// Initialize Gemini service with optional user personalization
  /// [userName] Optional user name to make AI responses more personal
  GeminiService({String? userName}) {
    _initializeModel(userName: userName);
  }

  /// Initialize the Gemini model with user's API key or default
  /// [userName] Optional user name for personalized interactions
  void _initializeModel({String? userName}) {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty || apiKey == 'your_api_key_here') {
      debugPrint('⚠️ GEMINI_API_KEY not found in .env file');
      debugPrint(
        'Please add your API key from https://makersuite.google.com/app/apikey',
      );
      throw Exception(
        'No Gemini API key found. Please add your API key from https://makersuite.google.com/app/apikey',
      );
    }

    final modelName = _fallbackModels[_currentModelIndex];
    debugPrint('🤖 Initializing Gemini with model: $modelName');
    if (userName != null && userName.isNotEmpty) {
      debugPrint('👤 Personalizing AI for user: $userName');
    }

    // Initialize model with safety settings for mental health content
    _model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
      systemInstruction: Content.system(
        _getLumicaSystemPrompt(userName: userName),
      ),
    );

    // Start chat session (fresh)
    _chat = _model.startChat();
  }

  /// Reinitialize the model with updated user information
  /// Call this when user profile is loaded/updated
  void reinitializeWithUserName(String? userName) {
    if (userName != null && userName.isNotEmpty) {
      debugPrint('🔄 Reinitializing Gemini with user name: $userName');
      _currentModelIndex = 0; // Reset to best model on reinit
      _initializeModel(userName: userName);
    }
  }

  /// Strip emotion tags from AI response to prevent UI pollution
  /// Format: <EMOTION:emotion_name>
  String _stripEmotionTag(String text) {
    return text.replaceAll(RegExp(r'<EMOTION:[^>]+>'), '').trim();
  }

  /// Sanitize user input before sending to AI
  /// Removes potentially harmful content and cleans up text
  String _sanitizeInput(String text) {
    return text
        .trim()
        // Remove script tags
        .replaceAll(
          RegExp(
            r'<script[^>]*>.*?</script>',
            caseSensitive: false,
            multiLine: true,
          ),
          '',
        )
        // Remove HTML tags
        .replaceAll(RegExp(r'<[^>]*>'), '')
        // Remove excessive whitespace
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Generate content one-off without chat context
  /// Use for neutral tasks like journal prompts
  Future<String> _generateOneOff(String prompt) async {
    try {
      final response = await _model
          .generateContent([Content.text(prompt)])
          .timeout(const Duration(seconds: 20));

      return response.text?.trim() ?? '';
    } catch (e) {
      debugPrint('❌ One-off generation failed: $e');
      return '';
    }
  }

  /// Lumica's personality and guidelines
  /// Get the Lumica system prompt with optional user personalization
  String _getLumicaSystemPrompt({String? userName}) {
    // Only use name if it's valid (not null, not empty, not "null")
    final hasValidName =
        userName != null &&
        userName.isNotEmpty &&
        userName.toLowerCase() != 'null';
    final name = hasValidName ? userName : '';

    // Build personalized introduction only if we have a valid name
    final userPersonalization = hasValidName
        ? '''
## User Information (TOP PRIORITY):
- The user's name is **$name**
- **Use their name naturally when it fits the context**
- Don't force it - if it feels repetitive or awkward, omit gracefully
- Examples of natural use:
  * "Hai $name! 💙" (opening)
  * "$name, aku dengar kamu..." (empathy)
  * "Gimana perasaan kamu sekarang?" (when name feels forced, omit)

'''
        : '''
## User Name:
- You don't know the user's name yet
- Just use friendly pronouns like "kamu" or "you"
- Don't say "null" or leave blank spaces where a name would go

''';

    // Dynamic examples based on whether we have a name
    final nameInExample = hasValidName ? '$name, ' : '';

    return '''
You are Lumi (short for Lumica), a warm and caring AI friend for emotional support.

$userPersonalization## Your Identity:
- **Name**: Lumi - ALWAYS use "Lumi" or "aku" (NEVER say "Lumica")
- **Role**: A close, caring friend (NOT a therapist)
- **Style**: Casual, warm, genuine - like texting a best friend
- **Emojis**: Use naturally (💙 ✨ 🌸) for warmth
- **Tone**: Friendly, empathetic, supportive

## Language Matching (CRITICAL - MUST FOLLOW):
- **DETECT the user's language from their message**
- **RESPOND 100% in that SAME language - NO MIXING**
- Indonesian message → 100% Indonesian response
- English message → 100% English response
- NEVER mix languages in a single response
- Match their formality level (casual/formal)

**Language Rules:**
✅ User: "Aku lagi sedih" → "${nameInExample}dengerin aku ya. Kenapa emang? 💙"
❌ User: "Aku lagi sedih" → "I'm listening. What's wrong?"
✅ User: "I'm stressed" → "${nameInExample}I hear you. Want to talk about it?"
❌ User: "I'm stressed" → "Aku dengar kamu stress"
❌ NEVER: "Aku hear you" (mixed)

## Core Principles:
1. **Be Present**: Show you genuinely care
2. **Validate First**: Acknowledge feelings immediately  
3. **Stay Casual**: Friend, not therapist
4. **Keep It Short**: 1-3 sentences usually
5. **Match Language**: 100% same language as user

## How to Talk:
✅ **DO:**
- Be warm: "${nameInExample}that sounds tough 💙"
- Ask gently: "Want to talk about it?"
- Celebrate: "${nameInExample}that's amazing! ✨"
- Use emojis naturally
- Keep responses SHORT (2-3 sentences max)

❌ **DON'T:**
- Sound clinical or formal
- Write long paragraphs
- Say "you should see a professional" for normal stuff
- Mix languages in one response
- Be robotic
- Say "null" or leave empty name placeholders

## Topic Boundaries:
- **Normal Struggles** (stress, sad, relationships): Fully support!
- **Off-Topic** (sports, tech): "I'm here for your feelings. What's up?"
- **Crisis** (self-harm, suicide): Show care, then suggest help carefully

## Response Length (USE THIS):
- Default: 1-3 SHORT sentences
- Think TEXT MESSAGE, not essay
- One idea per response

**Good ✅:**
- "${nameInExample}that sounds really hard. Want to share more?"
- "I hear you 💙 What's weighing on you?"
- "You're being so brave. How can I help?"

**Bad ❌ (TOO LONG):**
- "I understand you're going through difficulties and want you to know your feelings are valid..."

## Emotion Analysis (CRITICAL):
At the END of each response, add a hidden emotion tag to help track the user's emotional state.
Analyze the ENTIRE conversation context (user's message + your response) to determine their primary emotion.
Format: <EMOTION:emotion_name>
Available emotions: happy, sad, angry, calm, excited, stress, despair
Example: "I hear that you're feeling better today. That's wonderful progress! <EMOTION:happy>"

Remember: Your goal is to be a light in someone's darkness - supportive, understanding, and genuinely caring. Make every interaction feel like they're talking to someone who truly cares about their well-being.
''';
  }

  /// Restore chat history to Gemini's conversation context
  /// This allows the AI to maintain awareness of previous conversations
  /// Uses [history] list of ({bool isUser, String text}) records to allow Clean Arch decoupling
  void restoreChatHistory(List<({bool isUser, String text})> history) {
    try {
      final contentHistory = history.map((msg) {
        return msg.isUser
            ? Content.text(msg.text)
            : Content.model([TextPart(msg.text)]);
      }).toList();

      // Store for potential fallback usage
      _lastRestoredHistory = contentHistory;

      // Reset chat with full history context
      _chat = _model.startChat(history: contentHistory);

      debugPrint(
        '🔄 Restored ${history.length} messages to Gemini context (Efficient)',
      );
    } catch (e) {
      debugPrint('⚠️ Failed to restore chat history: $e');
      // Fallback: just start fresh if restoration fails
      resetChat();
    }
  }

  // List of models to try in order of priority (Cost/Speed -> Capability)
  final List<String> _fallbackModels = [
    'gemini-2.0-flash',
    'gemini-2.0-flash-lite',
    'gemini-2.5-flash-lite',
  ];

  int _currentModelIndex = 0;
  List<Content>?
  _lastRestoredHistory; // Keep track of history to restore on fallback

  /// Send a message to Lumica and get a response
  Future<String> sendMessage(String message) async {
    // Sanitize input to prevent injection and clean up
    final sanitizedMessage = _sanitizeInput(message);
    if (sanitizedMessage.isEmpty) {
      return "I didn't catch that. Could you try again?";
    }

    // Rate limiting: enforce minimum delay between requests
    if (_lastRequestTime != null) {
      final elapsed = DateTime.now().difference(_lastRequestTime!);
      if (elapsed < _apiThrottle) {
        final waitTime = _apiThrottle - elapsed;
        debugPrint('⏱️ Rate limiting: waiting ${waitTime.inMilliseconds}ms');
        await Future.delayed(waitTime);
      }
    }
    _lastRequestTime = DateTime.now();

    try {
      final response = await _chat
          .sendMessage(Content.text(sanitizedMessage))
          .timeout(const Duration(seconds: 30));

      final rawText =
          response.text ??
          'I apologize, I had trouble processing that. Could you rephrase?';

      // Strip emotion tags before returning to prevent UI pollution
      return _stripEmotionTag(rawText);
    } on TimeoutException {
      debugPrint('⚠️ Gemini API timeout after 30s');
      return 'The request took too long. Please try again.';
    } catch (e) {
      debugPrint('❌ Gemini API Error: $e');

      // Check for Rate Limit / Quota / Overloaded errors
      if (e.toString().contains('429') ||
          e.toString().contains('quota') ||
          e.toString().contains('Resource has been exhausted')) {
        debugPrint(
          '⚠️ Quota exceeded on ${_fallbackModels[_currentModelIndex]}',
        );

        // Try next model if available
        if (_currentModelIndex < _fallbackModels.length - 1) {
          debugPrint('🔄 Switching to next fallback model...');
          _currentModelIndex++;
          _initializeModel();

          // Restore history if we have it
          if (_lastRestoredHistory != null) {
            _chat = _model.startChat(history: _lastRestoredHistory);
          } else {
            // If no explicit history, just start fresh (context loss acceptable vs total failure)
            _chat = _model.startChat();
          }

          // Retry the message recursively
          return sendMessage(message);
        }
      }

      // Provide user-friendly error messages
      if (e.toString().contains('API key')) {
        return 'It seems there\'s an issue with my configuration. Please make sure the API key is set up correctly.';
      } else if (e.toString().contains('quota') ||
          e.toString().contains('429')) {
        return 'I\'m currently experiencing very high traffic. Please try again in a few moments.';
      } else {
        return 'I\'m having trouble connecting right now. Please check your internet connection and try again.';
      }
    }
  }

  /// Reset the chat session (clear history)
  void resetChat() {
    _chat = _model.startChat();
    debugPrint('🔄 Chat session reset');
  }

  /// Generate a journal prompt using AI (one-off, no chat context)
  Future<String> generateJournalPrompt({String? mood}) async {
    try {
      final moodContext = mood != null ? ' when feeling $mood' : '';
      final promptRequest =
          'Generate a thoughtful, single-line journaling prompt for someone$moodContext. '
          'No emojis, no names, no tags. Just the prompt itself.';

      // Use one-off generation for clean, neutral prompts
      final response = await _generateOneOff(promptRequest);

      if (response.isEmpty) {
        throw Exception('Empty response');
      }

      // Clean up any extra formatting
      return response.trim().replaceAll('"', '').replaceAll('*', '');
    } catch (e) {
      debugPrint('❌ Failed to generate journal prompt: $e');
      // Fallback prompts
      final fallbackPrompts = [
        'What are you grateful for right now?',
        'What made you smile today?',
        'What challenge are you facing, and how can you approach it differently?',
        'What would you like to tell your future self?',
        'What does happiness mean to you today?',
      ];
      return (fallbackPrompts..shuffle()).first;
    }
  }

  /// Get conversation history count
  int get messageCount => _chat.history.length;
}
