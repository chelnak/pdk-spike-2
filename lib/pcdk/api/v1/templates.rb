# frozen_string_literal: true

module Pcdk
  module Api
    module V1
      # Module for template related classes
      module Templates
        autoload :Resolver, 'pcdk/api/v1/templates/resolver'
        autoload :Renderer, 'pcdk/api/v1/templates/renderer'
        autoload :TemplateConfig, 'pcdk/api/v1/templates/template_config'
      end
    end
  end
end
