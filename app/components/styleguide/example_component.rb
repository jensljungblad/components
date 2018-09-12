module Styleguide
  class ExampleComponent < Components::Component
    has_one :example do
      attribute :width
      attribute :height
    end
    has_one :example_source

    def iframe_id
      @iframe_id ||= SecureRandom.uuid
    end
  end
end
