require 'components/engine'
require 'components/component'

module Components
  def self.path
    Rails.root.join('app', 'components')
  end

  def self.component_names
    Dir.chdir(path) do
      Dir.glob('**/*_component.rb').map do |component|
        component.chomp('_component.rb')
      end.sort
    end
  end
end
