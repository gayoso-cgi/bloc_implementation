enum CategoryContentEnum { VIDEO, ARTICLE, PDF, RESET, SEARCH }

extension contentType on CategoryContentEnum {
  String get name {
    final str = this.toString().split('.').last.toLowerCase();
    return str.split(new RegExp(r"(?<=[a-z])(?=[A-Z])")).join("_");
  }
}
