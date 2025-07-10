import 'package:flutter/material.dart';

class ChatBotView extends StatelessWidget {
  const ChatBotView({super.key});

  void _showChatBot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ChatBotSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: FloatingActionButton(
        onPressed: () => _showChatBot(context),
        backgroundColor: const Color(0xFFFF6B6B),
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
    );
  }
}

class _ChatBotSheet extends StatefulWidget {
  const _ChatBotSheet();

  @override
  State<_ChatBotSheet> createState() => _ChatBotSheetState();
}

class _ChatBotSheetState extends State<_ChatBotSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          'Hi! 👋 I am your Mitho Bites assistant. Ask me anything about food, orders, or the app!',
      'isUser': false,
    },
  ];
  bool _isLoading = false;

  // Sample Q&A pairs
  final List<Map<String, String>> _qaPairs = [
    {
      'q': 'How do I place an order?',
      'a':
          'To place an order, browse the menu, add items to your cart, and proceed to checkout.',
    },
    {
      'q': 'What payment methods are accepted?',
      'a':
          'We accept cash on delivery, eSewa, Khalti, and major credit/debit cards.',
    },
    {
      'q': 'How can I track my order?',
      'a':
          'Go to the Orders section in your profile to track your current orders in real-time.',
    },
    {
      'q': 'Can I cancel my order?',
      'a':
          'Yes, you can cancel your order before it is confirmed by the restaurant.',
    },
    {
      'q': 'How do I reset my password?',
      'a':
          'On the login page, tap "Forgot Password" and follow the instructions.',
    },
    {
      'q': 'Is there a delivery charge?',
      'a':
          'Delivery charges depend on your location and order amount. Orders above Rs. 1000 are delivered free!',
    },
    {
      'q': 'How do I contact customer support?',
      'a':
          'You can contact support via the Help section in the app or call our hotline.',
    },
    {
      'q': 'Can I schedule an order for later?',
      'a': 'Yes, you can choose a delivery time during checkout.',
    },
    {
      'q': 'Are there any discounts or offers?',
      'a':
          'Check the Offers section on the home page for the latest deals and discounts.',
    },
    {
      'q': 'How do I add a new delivery address?',
      'a': 'Go to your profile, select Addresses, and add a new address.',
    },
    {
      'q': 'What is Mitho Bites?',
      'a':
          'Mitho Bites is a food delivery app bringing delicious meals from your favorite restaurants to your doorstep.',
    },
    {
      'q': 'How do I become a restaurant partner?',
      'a':
          'Contact us via the Partner With Us section in the app or on our website.',
    },
    {
      'q': 'Can I order from multiple restaurants at once?',
      'a': 'Currently, you can order from one restaurant per order.',
    },
    {
      'q': 'How do I apply a promo code?',
      'a': 'Enter your promo code at checkout to get discounts.',
    },
    {
      'q': 'What if my food is late?',
      'a':
          'We apologize for delays. You can track your order and contact support if needed.',
    },
    {
      'q': 'How do I rate a restaurant?',
      'a':
          'After your order is delivered, you can rate and review the restaurant from the Orders section.',
    },
    {
      'q': 'Can I reorder previous orders?',
      'a': 'Yes, go to your order history and tap Reorder on any past order.',
    },
    {
      'q': 'Is there a minimum order amount?',
      'a':
          'Some restaurants may have a minimum order amount. It will be shown at checkout.',
    },
    {
      'q': 'How do I update my profile information?',
      'a': 'Go to your profile and tap Edit to update your details.',
    },
    {
      'q': 'What cuisines are available?',
      'a':
          'We offer Nepali, Indian, Chinese, Continental, and many more cuisines.',
    },
    {
      'q': 'How do I know if a restaurant is open?',
      'a':
          'Open restaurants are marked as "Open" and you can filter by open status.',
    },
    {
      'q': 'Can I tip the delivery person?',
      'a': 'Yes, you can add a tip during checkout or after delivery.',
    },
    {
      'q': 'How do I report a problem with my order?',
      'a': 'Go to your order details and tap Report a Problem.',
    },
    {
      'q': 'Are there vegetarian options?',
      'a': 'Yes, you can filter the menu to show only vegetarian dishes.',
    },
    {
      'q': 'How do I change my password?',
      'a': 'Go to profile settings and select Change Password.',
    },
    {
      'q': 'Can I save my favorite dishes?',
      'a': 'Yes, tap the heart icon on any dish to add it to your favorites.',
    },
    {
      'q': 'What areas do you deliver to?',
      'a': 'We deliver to most areas in Kathmandu, Lalitpur, and Bhaktapur.',
    },
    {
      'q': 'How do I get a refund?',
      'a':
          'If eligible, refunds are processed within 3-5 business days to your original payment method.',
    },
    {
      'q': 'Can I order for a group?',
      'a': 'Yes, you can add multiple items to your cart for group orders.',
    },
    {
      'q': 'How do I delete my account?',
      'a': 'Contact support to request account deletion.',
    },
    {
      'q': 'Is my payment information secure?',
      'a': 'Yes, we use secure payment gateways to protect your information.',
    },
    {
      'q': 'How do I check restaurant ratings?',
      'a': 'Restaurant ratings are shown on their profile and menu page.',
    },
    {
      'q': 'Can I request contactless delivery?',
      'a': 'Yes, select the contactless delivery option at checkout.',
    },
    {
      'q': 'How do I refer a friend?',
      'a': 'Go to the Refer & Earn section to invite friends and earn rewards.',
    },
    {
      'q': 'What if I have food allergies?',
      'a':
          'Check dish details for allergy info or contact the restaurant directly.',
    },
    {
      'q': 'How do I change my delivery address after ordering?',
      'a': 'Contact support as soon as possible to update your address.',
    },
    {
      'q': 'Can I pay with digital wallets?',
      'a': 'Yes, we support eSewa, Khalti, and IME Pay.',
    },
    {
      'q': 'How do I see my order history?',
      'a': 'Go to your profile and select Order History.',
    },
    {
      'q': 'What if I receive the wrong order?',
      'a':
          'Report the issue via your order details and we will resolve it quickly.',
    },
    {'q': 'How do I log out?', 'a': 'Go to profile settings and tap Log Out.'},
    {
      'q': 'Can I get an invoice for my order?',
      'a': 'Yes, invoices are available in your order details.',
    },
  ];

  List<Map<String, String>> _sampleQuestions = [];

  @override
  void initState() {
    super.initState();
    _refreshSampleQuestions();
  }

  void _refreshSampleQuestions() {
    _sampleQuestions = List<Map<String, String>>.from(_qaPairs)..shuffle();
    _sampleQuestions = _sampleQuestions.take(6).toList();
    setState(() {});
  }

  void _sendMessage({String? overrideText}) {
    final text = overrideText ?? _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _isLoading = true;
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    // Improved answer matching: case-insensitive, whitespace-insensitive, partial match
    String normalized(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
    final normText = normalized(text);
    final match = _qaPairs.firstWhere(
      (qa) =>
          normalized(qa['q']!).contains(normText) ||
          normText.contains(normalized(qa['q']!)),
      orElse:
          () => _qaPairs.firstWhere(
            (qa) => normalized(qa['q']!) == normText,
            orElse:
                () => {
                  'a':
                      "Sorry, I don't have an answer for that. Please contact support.",
                },
          ),
    );
    final answer = match['a'];
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _messages.add({'text': answer, 'isUser': false});
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
      _refreshSampleQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.7,
      maxChildSize: 0.98,
      builder:
          (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.smart_toy, color: Color(0xFFFF6B6B)),
                      const SizedBox(width: 8),
                      const Text(
                        'Mitho Bites Chatbot',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoading && index == _messages.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Thinking...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      final msg = _messages[index];
                      return Align(
                        alignment:
                            msg['isUser']
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                msg['isUser']
                                    ? const Color(0xFFFF6B6B)
                                    : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Text(
                            msg['text'],
                            style: TextStyle(
                              fontSize: 17,
                              color: msg['isUser'] ? Colors.white : Colors.black,
                              fontWeight: msg['isUser'] ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: 'Type your question...',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xFFFF6B6B),
                            ),
                            onPressed: _isLoading ? null : _sendMessage,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              _sampleQuestions
                                  .map(
                                    (qa) => ActionChip(
                                      label: Text(qa['q']!),
                                      onPressed:
                                          _isLoading
                                              ? null
                                              : () {
                                                _controller.text = qa['q']!;
                                                // Do NOT send immediately; let user press send
                                              },
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sample Questions:',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
