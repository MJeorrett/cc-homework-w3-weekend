require('minitest/autorun')
require('minitest/rg')

require_relative('../db/query_builder')

class QueryBuilderTest < MiniTest::Test

  def test_all_records()
    expected = "SELECT * FROM customers"
    actual = QueryBuilder.all_records("customers")
    assert_equal(expected, actual)
  end

  def test_all_where__multiple_conditions()
    expected = "SELECT * FROM customers WHERE first_name = 'Matthew' AND last_name = 'Jeorrett'"
    conditions = {
      first_name: "Matthew",
      last_name: "Jeorrett"
    }
    actual = QueryBuilder.all_where("customers", conditions)
    assert_equal(expected, actual)
  end

  def test_all_where__single_condition()
    expected = "SELECT * FROM customers WHERE id = 4"
    actual = QueryBuilder.all_where("customers", { id: 4 })
    assert_equal(expected, actual)
  end

  def test_insert()
    expected = "INSERT INTO customers(first_name, last_name, funds) VALUES ('Matthew', 'Jeorrett', 14.99)"
    data = {
      first_name: "Matthew",
      last_name: "Jeorrett",
      funds: 14.99
    }
    actual = QueryBuilder.insert("customers", data)
    assert_equal(expected, actual)
  end

end
