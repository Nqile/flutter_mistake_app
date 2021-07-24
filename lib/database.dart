class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
  }
}
