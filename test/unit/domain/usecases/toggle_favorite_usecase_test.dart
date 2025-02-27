import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadget_rank/core/error/failure.dart';
import 'package:gadget_rank/domain/entities/product.dart';
import 'package:gadget_rank/domain/repositories/favorites_repository.dart';
import 'package:gadget_rank/domain/usecases/favorites/toggle_favorite_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock classes
@GenerateMocks([FavoritesRepository])
import 'toggle_favorite_usecase_test.mocks.dart';

void main() {
  late ToggleFavoriteUseCase useCase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = ToggleFavoriteUseCase(mockRepository);
  });

  final testProduct = Product(
    id: 'test_id',
    name: 'Test Product',
    brand: 'Test Brand',
    category: 'Electronics',
    description: 'Test Description',
    price: 999.99,
    rating: 4.5,
    reviewCount: 100,
    imageUrls: ['image1.jpg', 'image2.jpg'],
    features: ['Feature 1', 'Feature 2'],
    isAvailable: true,
    rank: 1,
  );

  group('ToggleFavoriteUseCase', () {
    test('should toggle favorite status when repository succeeds', () async {
      // Arrange
      when(
        mockRepository.toggleFavorite(testProduct),
      ).thenAnswer((_) async => true);

      // Act
      final result = await useCase.execute(testProduct);

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockRepository.toggleFavorite(testProduct)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return GenericFailure when repository throws an exception',
      () async {
        // Arrange
        when(
          mockRepository.toggleFavorite(testProduct),
        ).thenThrow(Exception('Test exception'));

        // Act
        final result = await useCase.execute(testProduct);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<GenericFailure>()),
          (_) => fail('Should return a Left with a Failure'),
        );
        verify(mockRepository.toggleFavorite(testProduct)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
