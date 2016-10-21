create or replace type body ut_data_value_number as

  constructor function ut_data_value_number(self in out nocopy ut_data_value_number, a_value number) return self as result is
  begin
    self.datavalue := a_value;
    self.datatype := 'number';
    return;
  end;

  overriding member function is_null return boolean is
  begin
    return (self.datavalue is null);
  end;

  overriding member function to_string return varchar2 is
  begin
    return ut_utils.to_string(self.datavalue);
  end;

end;
/
