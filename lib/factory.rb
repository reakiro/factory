# * Here you must define your `Factory` class.
# * Each instance of Factory could be stored into variable. The name of this variable is the name of created Class
# * Arguments of creatable Factory instance are fields/attributes of created class
# * The ability to add some methods to this class must be provided while creating a Factory
# * We must have an ability to get/set the value of attribute like [0], ['attribute_name'], [:attribute_name]
#
# * Instance of creatable Factory class should correctly respond to main methods of Struct
# - each
# - each_pair
# - dig
# - size/length
# - members
# - select
# - to_a
# - values_at
# - ==, eql?

require_relative 'class_methods_module'

class Factory
  def self.create_class(attributes, &block)
    Class.new do
      include ClassMethodsModule

      self.send(:attr_accessor, *attributes)

      define_method(:initialize) do |*values|
        raise ArgumentError if values.length > attributes.length

        values.each_with_index do |value, index|
          self.send("#{attributes[index]}=", value)
        end
      end
      
      self.class_eval(&block) if block_given?
    end
  end

  def self.new(new_class, *attributes, &block)   
    if new_class.is_a? String
      Factory.const_set new_class.capitalize, create_class(attributes, &block)
    else attributes.unshift(new_class)
      create_class(attributes, &block)
    end
  end
end
