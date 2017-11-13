class Module
  def attribute(argument, &block)
    if argument.is_a?(Hash)
      argument.each do |key, value|
        setter = Proc.new { |arg| @argument = arg }
        getter = Proc.new { @argument||=value}
        query  = Proc.new { true if @argument }
        Object.send(:define_method, "#{key.to_sym}=", setter)
        Object.send(:define_method, "#{key.to_sym}",  getter)
        Object.send(:define_method, "#{key.to_sym}?", query)
      end
    else
      setter = Proc.new { |arg| @argument = arg }
      getter = Proc.new { @argument ||= (instance_variable_set(:"@#{argument}", instance_eval(&block)) if block_given?) }
      query  = Proc.new { true if @argument }
      Object.send(:define_method, "#{argument.to_sym}=", setter)
      Object.send(:define_method, "#{argument.to_sym}",  getter)
      Object.send(:define_method, "#{argument.to_sym}?", query)
    end
  end
end