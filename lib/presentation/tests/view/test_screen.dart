import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../models/test_model/test_model.dart';
import '../bloc/test_bloc.dart';

class TestScreen extends StatefulWidget {
  final String language;
  final int templateNumber;

  const TestScreen({super.key, required this.language, required this.templateNumber});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final PageController _pageController = PageController();
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestBloc()..add(LoadTests(widget.language, widget.templateNumber)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Тест ${widget.templateNumber} (${widget.language})"),
          centerTitle: true,
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

                            // Плавный переход в карусели
                            _carouselController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: _currentPage == index ? Colors.blue : Colors.grey.shade300,
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: _currentPage == index ? Colors.white : Colors.black,
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
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });

                        // Обновляем карусель при смене страницы
                        _carouselController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: _buildTestCard(context, state.tests[index]),
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

  /// Виджет карточки теста
  Widget _buildTestCard(BuildContext context, TestModel test) {
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
              if (test.imagePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      test.imagePath!,
                      height: 250, // 🔥 Увеличен размер
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              // 🔹 Варианты ответов
              ...test.options.map((option) {
                return _buildAnswerOption(context, option, test);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Виджет одного варианта ответа
  Widget _buildAnswerOption(BuildContext context, String option, TestModel test) {
    return InkWell(
      onTap: () {
        bool isCorrect = option.trim() == test.correctAnswer.trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isCorrect ? "✅ Правильно!" : "❌ Неправильно"),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Card(
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: ListTile(
          title: Text(option, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

}
