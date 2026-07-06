import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/bank_store.dart';
import '../theme/alinma_colors.dart';

// Screens 3 & 4: Wadhah Chat (وضح - مساعدك البنكي) — mirrors
// WadhahApp/WadhahChatView.swift. Presentable pushed (from history)
// and as a bottom sheet (from the dashboard).

/// Opens the chat as a full-height bottom sheet.
void showWadhahChatSheet(BuildContext context, ChatScenario? scenario) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.94,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: WadhahChatView(scenario: scenario, asSheet: true),
      ),
    ),
  );
}

class WadhahChatView extends StatefulWidget {
  const WadhahChatView({super.key, this.scenario, this.asSheet = false});

  final ChatScenario? scenario;
  final bool asSheet;

  @override
  State<WadhahChatView> createState() => _WadhahChatViewState();
}

class _WadhahChatViewState extends State<WadhahChatView> {
  late final WadhahChatEngine _engine;
  final _draft = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _engine = WadhahChatEngine(widget.scenario);
    _engine.addListener(_scrollToEnd);
  }

  @override
  void dispose() {
    _engine.dispose();
    _draft.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    _engine.send(_draft.text);
    _draft.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlinmaColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: !widget.asSheet,
        // RTL Row: first child renders on the right — avatar sits right of the
        // title, next to the back button, matching the design.
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _wadCircle(diameter: 38, imageSize: 26),
            const SizedBox(width: 10),
            const Text(
              'وضّح - مساعدك البنكي',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          if (widget.asSheet)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 20),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _engine,
              builder: (context, _) {
                final messages = _engine.messages;
                return ListView(
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final message in messages) ...[
                      if (message.role == ChatRole.user)
                        _userBubble(message)
                      else
                        _assistantBubble(message),
                      const SizedBox(height: 16),
                    ],
                    const Text(
                      'وضح · الآن',
                      style: TextStyle(
                          fontSize: 10, color: AlinmaColors.textSecondary),
                    ),
                  ],
                );
              },
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _wadCircle({required double diameter, required double imageSize}) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        color: AlinmaColors.copper,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/wad.png',
        width: imageSize,
        height: imageSize,
        fit: BoxFit.contain,
      ),
    );
  }

  // Bubbles

  Widget _userBubble(WadhahChatMessage message) {
    return Align(
      // RTL: start = right, matching the design's user side.
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsetsDirectional.only(end: 40),
        decoration: BoxDecoration(
          color: AlinmaColors.userBubble,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _assistantBubble(WadhahChatMessage message) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AlinmaColors.assistantBubble,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isTyping)
                    const _TypingDots()
                  else
                    Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AlinmaColors.assistantInk,
                        height: 1.75,
                      ),
                    ),
                  if (message.actions.length >= 2) ...[
                    const SizedBox(height: 14),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _actionButton(message.actions[0], filled: true),
                        const SizedBox(width: 10),
                        _actionButton(message.actions[1], filled: false),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Wadhah logo as the assistant's bubble avatar.
          _wadCircle(diameter: 26, imageSize: 17),
        ],
      ),
    );
  }

  Widget _actionButton(String title, {required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: filled ? AlinmaColors.accent : null,
        border: filled ? null : Border.all(color: AlinmaColors.accent, width: 1.5),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: filled ? Colors.white : AlinmaColors.accent,
        ),
      ),
    );
  }

  // Input bar

  Widget _inputBar() {
    return Container(
      color: AlinmaColors.background,
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, 10 + MediaQuery.paddingOf(context).bottom),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child: TextField(
                controller: _draft,
                onSubmitted: (_) => _send(),
                style: const TextStyle(
                    fontSize: 13, color: AlinmaColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'اسأل عن عملية أو رسوم أو اشتراك...',
                  hintStyle: const TextStyle(
                      fontSize: 13, color: AlinmaColors.textSecondary),
                  filled: true,
                  fillColor: AlinmaColors.card,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 46,
            height: 46,
            child: IconButton(
              onPressed: _send,
              style: IconButton.styleFrom(
                backgroundColor: AlinmaColors.accent,
                shape: const CircleBorder(),
              ),
              // Flipped horizontally so the plane points left, like the design.
              icon: Transform.flip(
                flipX: true,
                child: const Icon(Icons.send, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: 5),
                Opacity(
                  opacity: _dotOpacity(i),
                  child: const CircleAvatar(
                    radius: 3.5,
                    backgroundColor: Color(0xFFB7AB9E),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  double _dotOpacity(int index) {
    final phase = (_controller.value - index * 0.17) % 1.0;
    final wave = phase < 0.35 ? phase / 0.35 : 1 - (phase - 0.35) / 0.65;
    return 0.25 + 0.75 * wave.clamp(0.0, 1.0);
  }
}
