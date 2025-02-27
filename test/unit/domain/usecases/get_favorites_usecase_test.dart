import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadget_rank/core/error/failure.dart';
import 'package:gadget_rank/domain/entities/product.dart';
import 'package:gadget_rank/domain/repositories/favorites_repository.dart';
import 'package:gadget_rank/domain/usecases/favorites/get_favorites_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock classes
@GenerateMocks([FavoritesRepository])
import 'get_favorites_usecase_test.mocks.dart';

void main() {
  late GetFavoritesUseCase useCase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = GetFavoritesUseCase(mockRepository);
  });

  final testProducts = [
    Product(
      id: 'test_id_1',
      name: 'Test Product 1',
      brand: 'Test Brand',
      category: 'Electronics',
      description: 'Test Description 1',
      price: 999.99,
      rating: 4.5,
      reviewCount: 100,
      imageUrls: ['image1.jpg', 'image2.jpg'],
      features: ['Feature 1', 'Feature 2'],
      isAvailable: true,
      rank: 1,
    ),
    Product(
      id: 'test_id_2',
      name: 'Test Product 2',
      brand: 'Test Brand',
      category: 'Electronics',
      description: 'Test Description 2',
      price: 1999.99,
      rating: 4.8,
      reviewCount: 200,
      imageUrls: ['image3.jpg', 'image4.jpg'],
      features: ['Feature 3', 'Feature 4'],
      isAvailable: true,
      rank: 2,
    ),
  ];

  group('GetFavoritesUseCase', () {
    test('should get list of favorite products from repository', () async {
      // Arrange
      when(mockRepository.getFavorites()).thenAnswer((_) async => testProducts);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(Right<Failure, List<Product>>(testProducts)));
      verify(mockRepository.getFavorites()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when there are no favorites', () async {
      // Arrange
      when(mockRepository.getFavorites()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return a Right with an empty list'),
        (products) => expect(products, isEmpty),
      );
      verify(mockRepository.getFavorites()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return GenericFailure when repository throws an exception',
      () async {
        // Arrange
        when(
          mockRepository.getFavorites(),
        ).thenThrow(Exception('Test exception'));

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<GenericFailure>()),
          (_) => fail('Should return a Left with a Failure'),
        );
        verify(mockRepository.getFavorites()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
