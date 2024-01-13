class User {

  final String _userid, _email;
  String _name, _password;

  // Constructor v1
  User(this._userid, this._email, this._name, this._password);

  // getter
  String get id => _userid;
  String get email => _email;
  String get name => _name;
  String get password => _password;

  // setter  
  set name(String value) {
    _name = value;
  }
  set email(String value) {
    _password = value;
  }
}

// userid	integer Auto Increment [nextval('users_userid_seq')]	
// name	character varying(255)	
// email	character varying(255)	
// password	character varying(255)	
// createdon	timestamp	
// lastlogin	timestamp NULL	
// isverified	boolean