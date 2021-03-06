part of integrationtests;

void runStoredProcedureTests(String user, String password, String db, int port, String host) {
  MySqlConnectionPool pool;
  group('error tests:', () {
    test('setup', () {
      pool = new MySqlConnectionPool(user:user, password:password, db:db, port:port, host:host, max:1);
//      return setup(pool, "stream", "create table stream (id integer, name text)");
    });
    
    test('store data', () {
      var c = new Completer();
//      pool.query('''
//CREATE PROCEDURE getall ()
//BEGIN
//select * from stream;
//END
//''').then((results) {
//        return query.query('call getall()');
      pool.query('call getall()')
      .then((results) {
        results.listen((row) {
        }, onDone: () {
          c.complete();
        });
        c.complete();
      });
      return c.future;
    });

    test('close connection', () {
      pool.closeConnectionsWhenNotInUse();
    });
  });
}
