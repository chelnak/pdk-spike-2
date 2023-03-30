# frozen_string_literal: true

require 'fileutils'
require_relative '..//errors'
require_relative '../plugins'

module Pcdk
  module Api
    module V1
      module Templates
        # The list of variables that are reserved and cannot be used in templates
        RESERVED_VARIABLES = ['name', 'data'].freeze

        # The Renderer class is responsible for rendering a template with the given data
        class Renderer
          def initialize(template, name, data, renderer = :erb)
            @template = template
            @name = name
            @data = data
            @renderer = Plugins.renderer(renderer)

            make_instance_variables
          end

          # Returns the content of the template
          # @return [String] The content of the template
          def content
            File.read(@template.erb)
          end

          # Validates that all required variables are present
          # @return [void]
          # @raise [MissingVariableError] if a required variable is missing
          def validate
            given_keys = @data.map { |k, _v| k.downcase }
            expected_keys = @template.data.reject { |_k, v| v['required'] == false }.map { |k, _v| k.downcase }

            missing_keys = expected_keys - given_keys

            return if missing_keys.empty?

            raise Errors::MissingVariableError, "Missing required variables: #{missing_keys.join(', ')}"
          end

          # Renders the template with the given data
          # @return [String] The rendered template
          # @raise [RenderError] if there is an error rendering the template
          # @raise [TemplateVariableError] if an invalid variable is used in the template
          def render
            @renderer.render(content, binding)
          end

          def save(path, force)
            create_path(path)
            if File.exist?(path) && !force
              raise Errors::FileSaveError, "The file at path '#{path}' already exists.\nPlease choose a different name."
            end

            File.write(path, render)
          end

          private

          def make_instance_variables
            @data.reject { |k, _v| RESERVED_VARIABLES.include? k }.each_key do |key|
              instance_variable_set("@#{key}", @data[key])
            end
          end

          def create_path(path)
            return if File.exist?(path)

            FileUtils.mkdir_p(File.dirname(path))
          end
        end
      end
    end
  end
end
