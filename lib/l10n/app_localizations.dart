class AppLocalizations {
  static Map<String, String> en = {
    "user_name": "Username",
    "save": "Save",
    "search": "Search",
    "village": "Village",
    "add": "Add",
    "collect": "Collect",
    "choose_an_option": "Choose an option",
    "count": "Count",
    "adult": "ADULT",
    "child": "CHILD",
    "details": "Details",
    "version": "Version",
    "visit_date": "Visit date",
    "collection": "Collection",
    "input_collection": "Input Collection",
    "accounts_payable": "Accounts payable",
    "back": "Back",
    "ring_up": "Ring up",
    "send": "Send",
    "cancel": "Cancel",
    "sheet": "sheet",
    "resend": "resend",
    "ok": "ok",
    "all": "All",
    "box": "Box",
    "station": "Station",
    "ringup_use": "use",
    "customer_count": "Count",
    "resend_by_sms": "Resend by SMS",
    "resend_again": "Please send again when your network works.",
    "resend_error": "Some messages cant be sent properly.",
    "message_sent": "Message sent",
    "failed_messages": "Failed Messages",
    "processing": "Processing...",
    "all_villages": "All villages",
    "all_stations": "All stations",
    "reloading": "Reloading..."
  };

  static Map<String, String> es = {
    "user_name": "Jina la mutumiaji",
    "save": "Hifadhi",
    "search": "Tafuta",
    "village": "Kijiji",
    "add": "Ongeza",
    "collect": "Collect",
    "choose_an_option": "Chagua kwenye orodha",
    "count": "Hesabu",
    "adult": "MTU MZIMA",
    "child": "MTOTO",
    "details": "Maelezo",
    "version": "Toleo",
    "visit_date": "Tarehe ya ziara",
    "collection": "Ukusanyaji",
    "input_collection": "Input Collection",
    "accounts_payable": "Akaunti zinazolipwa",
    "back": "Nyuma",
    "ring_up": "Jumla",
    "send": "Tuma",
    "cancel": "Ghairi",
    "sheet": "karatasi",
    "resend": "Tuma tena",
    "ok": "sawa",
    "all": "Vyote",
    "box": "Sanduku",
    "station": "Kituo",
    "ringup_use": "tumia",
    "customer_count": "Hesabu",
    "resend_by_sms": "Tuma tena kwa SMS",
    "resend_again": "Tafadhali tuma tena mtandao Wako unapopatikana. ",
    "resend_error": "Ujumbe haukutumwa vizuri. ",
    "message_sent": "Ujumbe umetumwa",
    "failed_messages": "Ujumbe ulioshindwa",
    "processing": "Usindikaji...",
    "all_villages": "Vijiji vyote",
    "all_stations": "Vituo vyote",
    "reloading": "Inapakia upya..."
  };

  static of(context) {
    // @todo 言語設定に合わせて変更する
    final Person person = Person.fromMap(en);
    return person;
  }
}

class Strings {}

class Person {
  final String processing;
  final String user_name;
  final String save;
  final String search;
  final String village;
  final String add;
  final String collect;
  final String choose_an_option;
  final String count;
  final String adult;
  final String child;
  final String details;
  final String version;
  final String visit_date;
  final String collection;
  final String input_collection;
  final String accounts_payable;
  final String back;
  final String ring_up;
  final String send;
  final String cancel;
  final String sheet;
  final String resend;
  final String ok;
  final String all;
  final String box;
  final String station;
  final String ringup_use;
  final String customer_count;
  final String resend_by_sms;
  final String resend_again;
  final String resend_error;
  final String message_sent;
  final String failed_messages;
  final String all_villages;
  final String all_stations;
  final String reloading;

  Person({
    required this.processing,
    required this.user_name,
    required this.save,
    required this.search,
    required this.village,
    required this.add,
    required this.collect,
    required this.choose_an_option,
    required this.count,
    required this.adult,
    required this.child,
    required this.details,
    required this.version,
    required this.visit_date,
    required this.collection,
    required this.input_collection,
    required this.accounts_payable,
    required this.back,
    required this.ring_up,
    required this.send,
    required this.cancel,
    required this.sheet,
    required this.resend,
    required this.ok,
    required this.all,
    required this.box,
    required this.station,
    required this.ringup_use,
    required this.customer_count,
    required this.resend_by_sms,
    required this.resend_again,
    required this.resend_error,
    required this.message_sent,
    required this.failed_messages,
    required this.all_villages,
    required this.all_stations,
    required this.reloading,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      processing: map['processing'],
      user_name: map['user_name'],
      save: map['save'],
      search: map['search'],
      village: map['village'],
      add: map['add'],
      collect: map['collect'],
      choose_an_option: map['choose_an_option'],
      count: map['count'],
      adult: map['adult'],
      child: map['child'],
      details: map['details'],
      version: map['version'],
      visit_date: map['visit_date'],
      collection: map['collection'],
      input_collection: map['input_collection'],
      accounts_payable: map['accounts_payable'],
      back: map['back'],
      ring_up: map['ring_up'],
      send: map['send'],
      cancel: map['cancel'],
      sheet: map['sheet'],
      resend: map['resend'],
      ok: map['ok'],
      all: map['all'],
      box: map['box'],
      station: map['station'],
      ringup_use: map['ringup_use'],
      customer_count: map['customer_count'],
      resend_by_sms: map['resend_by_sms'],
      resend_again: map['resend_again'],
      resend_error: map['resend_error'],
      message_sent: map['message_sent'],
      failed_messages: map['failed_messages'],
      all_villages: map['all_villages'],
      all_stations: map['all_stations'],
      reloading: map['reloading'],
    );
  }
}
