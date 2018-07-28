module Before
  def before(*names)
    binding.pry
    names.each do |name|
      m = instance_method(name)
      define_method(name) do |*args, &block|
        yield
        m.bind(self).call(*args, &block)
      end
    end
  end
end