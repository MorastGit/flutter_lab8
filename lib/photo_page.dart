import 'package:flutter/material.dart';

enum PhotoType { dog, landscapes }

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final List<String> _localPhotos = [
    'images/one.jpeg',
    'images/two.jpg',
    'images/three.png',
  ];

  String? _photoUrl;
  bool _isLoading = false;
  String? _errorMessage;
  PhotoType _animalType = PhotoType.dog;

  Future<void> _fetchPhoto() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _photoUrl = null;
    });

    try {
      // Имитация сетевой задержки
      await Future.delayed(const Duration(seconds: 2));

      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % _localPhotos.length;
      final photoUrl = _localPhotos[randomIndex];

      setState(() {
        _photoUrl = photoUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Не удалось загрузить изображение. Пожалуйста, попробуйте ещё раз.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фото дня'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildAnimalToggle(),
          const SizedBox(height: 20),
          Expanded(child: _buildContent()),
          const SizedBox(height: 20),
          _buildLoadButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAnimalToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildChoiceChip(label: '🐶 Собаки', type: PhotoType.dog),
        const SizedBox(width: 12),
        _buildChoiceChip(label: '🌄 Пейзаж', type: PhotoType.landscapes),
      ],
    );
  }

  Widget _buildChoiceChip({required String label, required PhotoType type}) {
    return ChoiceChip(
      label: Text(label),
      selected: _animalType == type,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _animalType = type;
            _photoUrl = null;
            _errorMessage = null;
          });
        }
      },
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }
    if (_photoUrl != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              _photoUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      );
    }
    return const Center(
      child: Text(
        'Нажмите кнопку,\nчтобы загрузить фото',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildLoadButton() {
    final label =
        _animalType == PhotoType.dog ? '🐶 Новая собака' : '🌄 Новый пейзаж';

    return ElevatedButton(
      onPressed: _isLoading ? null : _fetchPhoto,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}