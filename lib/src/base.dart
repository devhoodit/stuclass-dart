class BaseInfo {
  String session = '';
  String wmonid = '';
  BaseInfo(this.session, this.wmonid);

  call(String session, String wmonid) {
    this.session = session;
    this.wmonid = wmonid;
  }
}
