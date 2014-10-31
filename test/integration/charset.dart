part of integrationtests;

void runCharsetTests(String user, String password, String db, int port, String host) {
  MySqlConnectionPool pool;
  group('charset tests:', () {
    test('setup', () {
      pool = new MySqlConnectionPool(user:user, password:password, db:db, port:port, host:host, max:1);
      return setup(pool, "cset", "create table cset (stuff text character set utf8)",
        "insert into cset (stuff) values ('здрасти')");
    });

    test('read data', () {
      var c = new Completer();
      pool.query('select * from cset').then(expectAsync1((Results results) {
        results.listen((row) {
          expect(row[0].toString(), equals("здрасти"));
        }, onDone: () {
          c.complete();
        });
      }));
      return c.future;
    });

    test('close connection', () {
      pool.closeConnectionsWhenNotInUse();
    });
  });
}
