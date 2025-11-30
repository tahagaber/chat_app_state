import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 1. تحويل إلى StatefulWidget لإدارة الـ Animation
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

// 2. استخدام TickerProviderStateMixin لإدارة AnimationController
class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();

  // 3. تعريف الـ Animation Controller
  late AnimationController _controller;

  // 4. تعريف حركات المقياس والانزلاق
  late Animation<double> _iconScaleAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );


    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.3,
              1.0,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // يجب التخلص من الـ Controller عند الخروج
    _emailController.dispose();
    super.dispose();
  }

  // الدالة الخاصة بإرسال الإيميل (كما كانت)
  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    // ... (الكود الخاص بـ Firebase كما هو)
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("📧 Password reset email sent successfully!"),
          backgroundColor: const Color(0xFF3FB950),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "No account found with this email.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: const Color(0xFFDA3633),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const githubDark = Color(0xFF0E0F1F);
    const githubCard = Color(0xFF161B22);
    const githubBorder = Color(0xFF30363D);
    const githubText = Color(0xFFC9D1D9);
    const githubSubtext = Color(0xFF8B949E);
    const githubBlue = Color(0xFF1F6FEB);
    const githubGreen = Color(0xFF3FB950);

    return Scaffold(
      backgroundColor: githubDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 زر العودة - نستخدم Opacity و SlideTransition لإضافة حركة خفيفة له
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.2, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
                  ),
                ),
                child: FadeTransition(
                  opacity: _controller,
                  child: Container(
                    decoration: BoxDecoration(
                      color: githubCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: githubBorder),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: githubText),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // 🔒 أيقونة القفل - تم تطبيق حركة التكبير (من الصفر إلى الحجم الأصلي)
              Center(
                child: ScaleTransition(
                  scale: _iconScaleAnimation, // استخدام حركة التكبير
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [githubBlue, githubGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🧾 العنوان والوصف - نستخدم Opacity و SlideTransition لإضافة حركة خفيفة
              Center(
                child: FadeTransition(
                  opacity: _controller,
                  child: SlideTransition(
                    position: _cardSlideAnimation,
                    child: const Column(
                      children: [
                        Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: githubText,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Enter your registered email below and we’ll send you\ninstructions to reset your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: githubSubtext,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 📩 كارت إدخال البريد - تم تطبيق حركة الانزلاق (من الأسفل إلى الأعلى)
              SlideTransition(
                position: _cardSlideAnimation, // استخدام حركة الانزلاق
                child: FadeTransition(
                  opacity: _controller,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    decoration: BoxDecoration(
                      color: githubCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: githubBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ... (باقي محتوى الكارت كما هو)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: githubBlue.withOpacity(0.15),
                              ),
                              child: const Icon(
                                Icons.mail_outline_rounded,
                                color: githubBlue,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Recovery Email",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: githubText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 🧠 حقل إدخال البريد
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: githubText),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: const TextStyle(color: githubSubtext),
                            hintText: "Enter your email",
                            hintStyle: const TextStyle(color: githubSubtext),
                            filled: true,
                            fillColor: githubDark,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: githubBorder, width: 1.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: githubBlue, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // 🚀 زر الإرسال بجريدنت
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [githubBlue, githubGreen],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: githubBlue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => _sendPasswordResetEmail(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Send Recovery Email",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🔙 العودة لتسجيل الدخول - نستخدم Opacity و SlideTransition لإضافة حركة خفيفة
              Center(
                child: FadeTransition(
                  opacity: _controller,
                  child: SlideTransition(
                    position: _cardSlideAnimation,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back to Login",
                        style: TextStyle(
                          color: githubBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}