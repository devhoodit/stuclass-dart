class BaseInfo {
  String id = '';
  String session = '';
  String wmonid = '';
  BaseInfo(this.id, this.session, this.wmonid);

  call(String id, String session, String wmonid) {
    this.id = id;
    this.session = session;
    this.wmonid = wmonid;
  }
}
