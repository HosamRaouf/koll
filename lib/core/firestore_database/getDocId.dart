



Future<String> getDocId({required var docWhere,}) async {
  String id = '';
  await docWhere.get().then((value) {
    for (var element in value.docs) {
      // print(element.id);
      id = element.id;
    }
  });
  return id;
}