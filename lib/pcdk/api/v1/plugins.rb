# frozen_string_literal: true

module Pcdk
  module Api
    module V1
      module Plugins
        class Registry
          def initialize
            @plugins = {}
          end

          attr_accessor :plugins
        end

        REGISTRY = Registry.new

        def self.registered_plugins
          REGISTRY.plugins
        end

        def self.renderer(name)
          REGISTRY.plugins[name].new
        end

        def self.new_renderer(name, &block)
          class_name = name.to_s.split('_').map(&:capitalize).join
          klass = Plugins.const_set("Renderer#{class_name}", Class.new(Renderer))
          klass.const_set('NAME', name)
          klass.class_exec(&block)

          REGISTRY.plugins[name] = klass
        end

        class Plugin
          class << self
            attr_accessor :author, :type, :desc, :version
          end
        end

        # Base class for all renderer plugins
        class Renderer < Plugin
          def render(template, context)
            raise NotImplementedError
          end
        end
      end
    end
  end
end

Dir.glob(File.join(__dir__, '**', 'plugins', '**', '*.rb')).sort.each { |file| require file }
