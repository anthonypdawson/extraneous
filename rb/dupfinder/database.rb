require 'sqlite3'

class Database

  attr_accessor :db_path, :table_name, :table, :path_column, :size_column, :hash_column

  def initialize(db_path)
    @db_path = db_path
  end

  def initialize(db_path, table)
    @db_path = db_path
    @table = table
  end

  def get_rows(where=nil, table=nil)
    table = table || @table
    where = where || "1=1"
    query("select * from #{table} where #{where};")
  end

  def add_row(values_sql, table=nil)
    table = table || @table
    query = "insert into #{table} values (#{values_sql})"
    query(query)
  end

  def query(q)
    puts q
     begin
       @db = SQLite3::Database.open(@db_path)
       results = @db.execute(q)
     rescue SQLite3::Exception => e
       puts "Exception!"
       puts e
       puts "Original query:"
       puts q
     ensure
       @db.close if @db
       return results
     end
  end
end
