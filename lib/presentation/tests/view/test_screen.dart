import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import '../../../models/test_model/test_model.dart';
import '../../result/view/results_screen.dart';
import '../../widgets /reusable_timer.dart';
import '../bloc/test_bloc.dart';

class TestScreen extends StatefulWidget {
  final String language;
  final int templateNumber;
  final List<TestModel>? preloadedTests;
  final int? totalQuestionsOverride;
  final bool hideTemplateTitle;
  final bool isMarathon;
  final bool fromRandomTest;

  const TestScreen({
    super.key,
    required this.language,
    this.templateNumber = 1,
    this.preloadedTests,
    this.totalQuestionsOverride,
    this.hideTemplateTitle = false,
    this.isMarathon = false,
    this.fromRandomTest=false,
  });

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final PageController _pageController = PageController();
  final CarouselSliderController _carouselController = CarouselSliderController();

  int _currentPage = 0;
  int _correctAnswers = 0;
  Map<int, String> _selectedAnswers = {}; // Хранит выбранные ответы
  final Map<String, Future<bool>> _imageExistenceCache = {};

  @override
  Widget build(BuildContext context) {
    final fromRandomTest = widget.fromRandomTest;
    final int totalQuestions = widget.totalQuestionsOverride ?? 20;
    if (widget.preloadedTests != null) {
      final tests = widget.preloadedTests!;
      // Do not use bottomNavigationBar here, keep as is
      // The bottom nav bar will be hidden by parent (see bottom_navigation.dart)
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.hideTemplateTitle ? "Марафон" : "Тест ${widget.templateNumber}"),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 18, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      ReusableCountdownTimer(
                        duration: widget.hideTemplateTitle
                            ? const Duration(hours: 1)
                            : const Duration(minutes: 25),
                        onFinished: () => _navigateToResultsScreenWithRandom(widget.fromRandomTest),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$_correctAnswers',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${widget.totalQuestionsOverride ?? 20}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // 🔹 Карусель навигации по вопросам
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: tests.length,
                itemBuilder: (context, index, realIndex) {
                  return GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(index);
                      setState(() {
                        _currentPage = index;
                      });

                      _carouselController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: _getQuestionStatusColor(index, tests),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 50,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.1,
                ),
              ),
            ),

            // 🔹 Свайповый PageView для тестов
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: tests.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: _buildTestCardWithRandom(context, tests[index], index, widget.fromRandomTest),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return BlocProvider(
        create: (context) => TestBloc()..add(LoadTests(
          widget.language,
          widget.templateNumber,
          fromRandomTest: widget.fromRandomTest,
        )),
        // Do not use bottomNavigationBar here, keep as is
        // The bottom nav bar will be hidden by parent (see bottom_navigation.dart)
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.hideTemplateTitle ? "Марафон" : "Тест ${widget.templateNumber}"),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 18, color: Colors.blueGrey),
                        const SizedBox(width: 4),
                        ReusableCountdownTimer(
                          duration: widget.hideTemplateTitle
                              ? const Duration(hours: 1)
                              : const Duration(minutes: 25),
                          onFinished: () => _navigateToResultsScreenWithRandom(widget.fromRandomTest),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_correctAnswers',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: ' / ${widget.totalQuestionsOverride ?? 20}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: BlocBuilder<TestBloc, TestState>(
            builder: (context, state) {
              if (state is TestLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TestLoaded) {
                return Column(
                  children: [
                    // 🔹 Карусель навигации по вопросам
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CarouselSlider.builder(
                        carouselController: _carouselController,
                        itemCount: state.tests.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () {
                              _pageController.jumpToPage(index);
                              setState(() {
                                _currentPage = index;
                              });

                              _carouselController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: _getQuestionStatusColor(index, state.tests),
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 50,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.1,
                        ),
                      ),
                    ),

                    // 🔹 Свайповый PageView для тестов
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: state.tests.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: _buildTestCardWithRandom(context, state.tests[index], index, widget.fromRandomTest),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is TestError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("Нет данных"));
            },
          ),
        ),
      );
    }
  }

  /// Виджет карточки теста (старый, теперь обертка)
  Widget _buildTestCard(BuildContext context, TestModel test, int questionIndex) {
    // Для обратной совместимости
    return _buildTestCardWithRandom(context, test, questionIndex, widget.fromRandomTest);
  }

  /// Виджет карточки теста с передачей fromRandomTest
  Widget _buildTestCardWithRandom(BuildContext context, TestModel test, int questionIndex, bool fromRandomTest) {
    final imagePath = 'assets/tests/parse_ru_RU/${widget.templateNumber}/${questionIndex + 1}.jpeg';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Вопрос
              Text(
                test.question,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 🔹 Картинка (если есть)
              FutureBuilder<bool>(
                future: _imageExistenceCache.putIfAbsent(
                  imagePath,
                  () => _imageExists(imagePath),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              // 🔹 Варианты ответов (убираем пустые)
              ...test.options.where((option) => option.isNotEmpty).map((option) {
                return _buildAnswerOptionWithRandom(context, option, test, questionIndex);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Виджет одного варианта ответа
  Widget _buildAnswerOptionWithRandom(BuildContext context, String option, TestModel test, int questionIndex) {
    bool isSelected = _selectedAnswers.containsKey(questionIndex);
    bool isCorrect = option.trim() == test.correctAnswer.trim();
    bool isUserChoice = _selectedAnswers[questionIndex] == option;
    final int totalQuestions = widget.totalQuestionsOverride ?? 20;

    return InkWell(
      onTap: isSelected
          ? null
          : () {
        setState(() {
          _selectedAnswers[questionIndex] = option;
          if (isCorrect) {
            _correctAnswers++;
          }
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          if (_selectedAnswers.length == totalQuestions) {
            print('➡️ Ответ завершён, fromRandomTest: ${widget.fromRandomTest}');
            context.pushNamed(
              'results',
              pathParameters: {
                'correctAnswers': _correctAnswers.toString(),
                'wrongAnswers': (totalQuestions - _correctAnswers).toString(),
                'totalQuestions': totalQuestions.toString(),
              },
              queryParameters: {
                'source': widget.fromRandomTest
                    ? 'random'
                    : (widget.isMarathon ? 'marathon' : 'templates'),
              },
            );
          } else {
            _moveToNextQuestion();
          }
        });
      },
      child: Card(
        color: isUserChoice
            ? (isCorrect ? Colors.green : Colors.red)
            : Theme.of(context).colorScheme.surfaceVariant,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: ListTile(
          title: Text(
            option,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  /// Переключаемся на следующий вопрос
  void _moveToNextQuestion() {
    final int totalQuestions = widget.totalQuestionsOverride ?? 20;
    if (_currentPage < totalQuestions - 1) {
      setState(() {
        _currentPage++;
      });

      Future.delayed(Duration.zero, () {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentPage);
        }
        if (_carouselController.ready) {
          _carouselController.animateToPage(_currentPage);
        }
      });
    }
  }

  /// Определяем цвет карусели для вопроса
  Color _getQuestionStatusColor(int questionIndex, List<TestModel> tests) {
    if (!_selectedAnswers.containsKey(questionIndex)) {
      return Colors.grey.shade300; // Еще не отвечен
    }
    bool isCorrect = _selectedAnswers[questionIndex] == tests[questionIndex].correctAnswer;
    return isCorrect ? Colors.green : Colors.red;
  }

  // Новый метод для передачи fromRandomTest
  void _navigateToResultsScreenWithRandom(bool fromRandomTest) {
    print('➡️ Переход из таймера в ResultsScreen с fromRandomTest: ${widget.fromRandomTest}');
    final int totalQuestions = widget.totalQuestionsOverride ?? 20;
    context.pushNamed(
      'results',
      pathParameters: {
        'correctAnswers': _correctAnswers.toString(),
        'wrongAnswers': (totalQuestions - _correctAnswers).toString(),
        'totalQuestions': totalQuestions.toString(),
      },
      queryParameters: {
        'source': widget.fromRandomTest
            ? 'random'
            : (widget.isMarathon ? 'marathon' : 'templates'),
      },
    );
  }

  Future<bool> _imageExists(String path) async {
    try {
      await DefaultAssetBundle.of(context).load(path);
      return true;
    } catch (_) {
      return false;
    }
  }
}
