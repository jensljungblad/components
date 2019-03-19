module Components
  class Element
    include ActiveModel::Validations

    def self.model_name
      ActiveModel::Name.new(Components::Element)
    end

    def self.attributes
      @attributes ||= {}
    end

    def self.attribute(name, default: nil)
      attributes[name] = { default: default }

      define_method(name) do
        get_instance_variable(name)
      end
    end

    def self.elements
      @elements ||= {}
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def self.element(name, multiple: false, &config)
      plural_name = name.to_s.pluralize.to_sym if multiple

      elements[name] = {
        multiple: plural_name || false, class: Class.new(Element, &config)
      }

      define_method(name) do |attributes = nil, &block|
        return get_instance_variable(multiple ? plural_name : name) unless attributes || block

        element = self.class.elements[name][:class].new(@view, attributes, &block)

        if multiple
          get_instance_variable(plural_name) << element
        else
          set_instance_variable(name, element)
        end
      end

      return if !multiple || name == plural_name

      define_method(plural_name) do
        get_instance_variable(plural_name)
      end
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    attr_reader :block_content

    def initialize(view, attributes = nil, &block)
      @view = view
      initialize_attributes(attributes || {})
      initialize_elements
      @block_content = block_given? ? @view.capture(self, &block) : nil
      validate!
    end

    def block_content?
      block_content.present?
    end

    def to_s
      block_content
    end

    protected

    def initialize_attributes(attributes)
      self.class.attributes.each do |name, options|
        set_instance_variable(name, attributes[name] || (options[:default] && options[:default].dup))
      end
    end

    def initialize_elements
      self.class.elements.each do |name, options|
        if (plural_name = options[:multiple])
          set_instance_variable(plural_name, [])
        else
          set_instance_variable(name, nil)
        end
      end
    end

    private

    def get_instance_variable(name)
      instance_variable_get(:"@#{name}")
    end

    def set_instance_variable(name, value)
      instance_variable_set(:"@#{name}", value)
    end
  end
end
