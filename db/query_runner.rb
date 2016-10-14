require('pg')

class QueryRunner

  DB_NAME = 'cinema'

  def self.run( sql )
    begin
      db = PG.connect(dbname: DB_NAME, host: 'localhost')
      result = db.exec( sql )
    ensure
      db.close()
    end
    return result
  end

end
