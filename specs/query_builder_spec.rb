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
    expected = "INSERT INTO customers(first_name, last_name, funds) VALUES ('Matthew', 'Jeorrett', 14.99) RETURNING id"
    data = {
      first_name: "Matthew",
      last_name: "Jeorrett",
      funds: 14.99
    }
    actual = QueryBuilder.insert_sql("customers", data)
    assert_equal(expected, actual)
  end

  def test_update_sql()
    expected = "UPDATE customers SET first_name = 'Matthew', last_name = 'Jeorrett', funds = 13.22 WHERE id = 4"
    data = {
      first_name: "Matthew",
      last_name: "Jeorrett",
      funds: 13.22
    }
    actual = QueryBuilder.update_sql("customers", data, 4)
    assert_equal(expected, actual)
  end

  def test_delete_all_sql()
    expected = "DELETE FROM customers"
    actual = QueryBuilder.delete_all_sql("customers")
    assert_equal(expected, actual)
  end

  def test_delete_with_id_sql()
    expected = "DELETE FROM customers WHERE id = 4"
    actual = QueryBuilder.delete_with_id_sql("customers", 4)
    assert_equal(expected, actual)
  end

  def test_many_to_many_sql()
    expected = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE tickets.customer_id = 4"
    actual = QueryBuilder.many_to_many_sql( 4, 'customer_id', 'tickets', 'film_id', 'films' )
    assert_equal(expected, actual)
  end

  def test_get_table_columns_sql()
    expected = "SELECT * FROM cinema.information_schema.columns WHERE table_name = 'customers'"
    actual = QueryBuilder.get_table_columns_sql( 'customers' )
    assert_equal(expected, actual)
  end

  def test_value_to_sql__string()
    assert_equal("'Matthew'", QueryBuilder.value_to_sql("Matthew"))
  end

  def test_value_to_sql__fixnum()
    assert_equal("14", QueryBuilder.value_to_sql(14))
  end

  def test_value_to_sql__float()
    assert_equal("14.33", QueryBuilder.value_to_sql(14.33))
  end

end
