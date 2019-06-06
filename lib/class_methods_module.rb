module ClassMethodsModule
  define_method(:[]) do |attribute|
    case attribute
      when String, Symbol
        self.send(:instance_variable_get, "@#{attribute}".to_sym)
      when Integer
        self.send(:instance_variable_get, instance_variables[attribute].to_sym)
    end
  end

  define_method(:[]=) do |attribute, value|
    case attribute
      when String, Symbol
        self.send(:instance_variable_set, "@#{attribute}".to_sym, value)
      when Integer
        self.send(:instance_variable_set, instance_variables[attribute].to_sym, value)
    end
  end

  define_method(:each) do |&block|
    to_a.each(&block)
  end
  
  define_method(:each_pair) do |&block|
    get_instance_values.each_pair(&block)
  end

  define_method(:dig) do |*values|
    digged_value = values.inject(self) do |next_value, value|
        next_value.nil? ? break : next_value = next_value[value]
    end
  end

  define_method(:size) do 
    get_instance_values.size
  end

  define_method(:length) do 
    get_instance_values.length
  end

  define_method(:members) do
    members_array = instance_variables.map do |variable|
      variable.to_s[1..-1].to_sym
    end
  end

  define_method(:select) do |&block|
    to_a.select(&block)
  end

  define_method(:to_a) do 
    get_instance_values.values
  end

  define_method(:values_at) do |*indexes|
    values = indexes.map do |index|
      self.send(:instance_variable_get, instance_variables[index].to_sym)
    end
  end

  define_method(:==) do |other|
    self.class == other.class && self.get_instance_values == other.get_instance_values
  end

  define_method(:eql?) do 
    self.class == other.class && self.get_instance_values == other.get_instance_values
  end

  define_method(:get_instance_values) do 
    instance_values = instance_variables.each_with_object(Hash.new) do |variable, hash|
        hash[variable.to_s[1..-1].to_sym] = self.send(:instance_variable_get, variable.to_sym)
    end
  end
end
