import 'package:portfolio_steve/domain/exceptions/failure.exception.dart';

class NotFoundException extends Failure {
  NotFoundException(String category, String id)
    : super("$category with $id not found");
}
