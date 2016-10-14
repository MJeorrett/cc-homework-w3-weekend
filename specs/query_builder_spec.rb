require('minitest/autorun')
require('minitest/rg')

require_relative('../db/query_builder')

class QueryBuilderTest < MiniTest::Test

  def test_all_records_sql()
    expected = "SELECT * FROM customers"
    actual = QueryBuilder.all_records_sql("customers")
    assert_equal(expected, actual)
  end

  def test_all_where_sql__multiple_conditions()
    expected = "SELECT * FROM customers WHERE first_name = 'Matthew' AND last_name = 'Jeorrett'"
    conditions = {
      first_name: "Matthew",
      last_name: "Jeorrett"
    }
    actual = QueryBuilder.all_where_sql("customers", conditions)
    assert_equal(expected, actual)
  end

  def test_all_where_sql__single_condition()
    expected = "SELECT * FROM customers WHERE id = 4"
    actual = QueryBuilder.all_where_sql("customers", { id: 4 })
    assert_equal(expected, actual)
  end

  def test_insert_sql()
    expected = "INSERT INTO customers(first_name, last_name, funds) VALUES ('Matthew', 'Jeorrett', 14.99)"
    data = {
      first_name: "Matthew",
      last_name: "Jeorrett",
      funds: 14.99
    }
    actual = QueryBuilder.insert_sql("customers", data)
    assert_equal(expected, actual)
  end

end
