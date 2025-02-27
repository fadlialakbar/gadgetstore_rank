import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadget_rank/core/error/failure.dart';
import 'package:gadget_rank/domain/repositories/favorites_repository.dart';
import 'package:gadget_rank/domain/usecases/favorites/is_favorite_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock classes
@GenerateMocks([FavoritesRepository])
import 'is_favorite_usecase_test.mocks.dart';

void main() {
  late IsFavoriteUseCase useCase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = IsFavoriteUseCase(mockRepository);
  });

  const testProductId = 'test_product_id';

  group('IsFavoriteUseCase', () {
    test('should return true when product is in favorites', () async {
      // Arrange
      when(
        mockRepository.isFavorite(testProductId),
      ).thenAnswer((_) async => true);

      // Act
      final result = await useCase.execute(testProductId);

      // Assert
      expect(result, equals(const Right<Failure, bool>(true)));
      verify(mockRepository.isFavorite(testProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return false when product is not in favorites', () async {
      // Arrange
      when(
        mockRepository.isFavorite(testProductId),
      ).thenAnswer((_) async => false);

      // Act
      final result = await useCase.execute(testProductId);

      // Assert
      expect(result, equals(const Right<Failure, bool>(false)));
      verify(mockRepository.isFavorite(testProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return GenericFailure when repository throws an exception',
      () async {
        // Arrange
        when(
          mockRepository.isFavorite(testProductId),
        ).thenThrow(Exception('Test exception'));

        // Act
        final result = await useCase.execute(testProductId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<GenericFailure>()),
          (_) => fail('Should return a Left with a Failure'),
        );
        verify(mockRepository.isFavorite(testProductId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
