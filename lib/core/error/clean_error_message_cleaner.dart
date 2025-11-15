///! extension on String to clean error messages by removing common exception prefixes
extension ErrorMessageCleaner on String? {
  ///? cleans the error message by removing common exception prefixes
  ///? treturns a default message if the original message is null
  String get cleanErrorMessage {
    if (this == null) return 'An error occurred';

    String cleanMessage = this!;

    if (cleanMessage.startsWith('EmptyException: ')) {
      cleanMessage = cleanMessage.replaceFirst('EmptyException: ', '');
    }
    if (cleanMessage.startsWith('GeneralException: ')) {
      cleanMessage = cleanMessage.replaceFirst('GeneralException: ', '');
    }
    if (cleanMessage.startsWith('ServerException: ')) {
      cleanMessage = cleanMessage.replaceFirst('ServerException: ', '');
    }
    if (cleanMessage.startsWith('ClientException with SocketException: ')) {
      cleanMessage = "Something Error with Server";
    }
    if (cleanMessage.startsWith('ClientException: ')) {
      cleanMessage = "Something Error with Server";
    }
    if (cleanMessage.startsWith('SocketException: ')) {
      cleanMessage = "Something Error with Server";
    }

    return cleanMessage;
  }
}

/// Utility function to clean error messages
String cleanErrorMessage(String? errorMessage) {
  return errorMessage.cleanErrorMessage;
}
