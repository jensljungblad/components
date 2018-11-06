module Components
  module ComponentHelper
    def component(name, attrs = nil, &block)
      component = "#{name}_component".classify.constantize.new(self, attrs, &block)
      component.render

      # view = controller.view_context
      # view.instance_variable_set(:@_component, component)
      #
      # methods = component.public_methods(false)
      # methods << :content
      #
      # methods.each do |method|
      #   view.singleton_class.delegate method, to: :@_component
      # end
      #
      # view.render "#{name}/#{name.split('/')[-1]}"
    end
  end
end
