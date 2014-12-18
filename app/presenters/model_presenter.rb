class ModelPresenter
  attr_accessor :object, :view_context

  def initialize(object, view_context)
    self.object = object
    self.view_context = view_context
    yield(self) if block_given?
  end

  class << self
    def build(objects, view_context)
      objects.each { |object| yield new(object, view_context) }
    end
  end
end
