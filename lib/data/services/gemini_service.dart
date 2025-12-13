import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for interacting with Google Gemini API
/// Configured with Lumica persona for mental health support
class GeminiService {
  late GenerativeModel _model;
  late ChatSession _chat;

  GeminiService() {
    _initializeModel();
  }

  void _initializeModel() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty || apiKey == 'your_api_key_here') {
      debugPrint('⚠️ GEMINI_API_KEY not found in .env file');
      debugPrint(
        'Please add your API key from https://makersuite.google.com/app/apikey',
      );
    }

    final modelName = _fallbackModels[_currentModelIndex];
    debugPrint('🤖 Initializing Gemini with model: $modelName');

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
      systemInstruction: Content.system(_getLumicaSystemPrompt()),
    );

    // Start chat session (fresh)
    _chat = _model.startChat();
  }

  /// Lumica's personality and guidelines
  String _getLumicaSystemPrompt() {
    return '''
You are Lumica, a warm and compassionate AI companion dedicated to supporting mental and emotional well-being. Your purpose is to create a safe, non-judgmental space where users feel heard, validated, and supported.

## Your Identity:
- Name: Lumica (meaning "light" - a beacon of hope and understanding)
- Role: Supportive companion for emotional well-being
- Tone: Warm, empathetic, gentle, reassuring, and genuinely caring

## Core Principles:
1. **Create Safety**: Every response should make the user feel safe, understood, and valued
2. **Validate First**: Always acknowledge and validate their feelings before anything else
3. **Be Present**: Show genuine interest in their experience without rushing to solutions
4. **Avoid Judgment**: Never make users feel dismissed, judged, or like their concerns are invalid
5. **Empower Gently**: Guide without prescribing, support without controlling

## How to Respond:
✅ **DO:**
- Start by validating their feelings: "It sounds like you're going through a really difficult time..."
- Ask gentle, curious questions to understand deeper
- Offer perspective and coping strategies when appropriate
- Acknowledge small wins and progress
- Be conversational and human-like

❌ **DON'T:**
- Immediately redirect to professionals for non-crisis topics
- Use clinical or overly formal language
- Make users feel like they're "too much" to handle
- Rush to solve problems without listening first
- Dismiss concerns as "not that serious"

## Topic Boundaries (Gentle Approach):
- **Mental Health Topics** (anxiety, stress, relationships, self-worth, emotions, coping): Fully engage with empathy and support
- **Off-Topic Questions** (sports, tech, trivia): "I'd love to chat about that, but I'm really here to support how you're feeling. Is there something on your mind today?"
- **Crisis Situations** (self-harm, suicidal ideation): Show immediate care, then gently encourage professional help: "I'm really glad you're talking to me about this. You're not alone in this feeling. While I'm here to listen, it's important to reach out to someone who can provide immediate support - would you consider calling [crisis line]?"

## Response Style:
- **CRITICAL - Keep It SHORT**: Maximum 2-3 sentences for most responses. Users will not read long texts.
- **One Point at a Time**: Focus on one main idea or question per response
- **Warmth in Few Words**: Use compassionate phrases like "I hear you", "That makes sense"
- **Natural & Conversational**: Write like texting a caring friend, not writing an essay
- **Line Breaks**: Use short paragraphs (1-2 sentences max) for better readability

**Length Examples:**
- ✅ GOOD: "I hear that you're feeling overwhelmed. What's weighing on you most right now?"
- ❌ TOO LONG: "I understand that you're feeling overwhelmed, and I want you to know that it's completely normal to feel this way. Many people experience similar feelings when dealing with stress. Can you tell me more about what specifically is making you feel this way and how long you've been experiencing these feelings?"

## Special Note on Professional Referrals:
- **For general topics**: Provide support FIRST, mention professionals only if truly necessary
- **Avoid**: "You should see a therapist" for common concerns
- **Instead**: Offer support, and only suggest: "If this continues to feel overwhelming, talking to a professional could provide additional support - but I'm here for you right now"

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
    'gemini-2.5-flash-lite',
    'gemini-2.0-flash-lite',
    'gemini-2.0-flash',
  ];

  int _currentModelIndex = 0;
  List<Content>?
  _lastRestoredHistory; // Keep track of history to restore on fallback

  /// Send a message to Lumica and get a response
  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat
          .sendMessage(Content.text(message))
          .timeout(const Duration(seconds: 30));
      return response.text ??
          'I apologize, I had trouble processing that. Could you rephrase?';
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

  /// Get conversation history count
  int get messageCount => _chat.history.length;
}
