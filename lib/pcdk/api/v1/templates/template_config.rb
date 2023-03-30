# frozen_string_literal: true

module Pcdk
  module Api
    module V1
      module Templates
        # TemplateConfig represents a template config
        class TemplateConfig
          attr_reader :id, :author, :display, :type, :version, :data, :url, :path, :location, :extension, :erb

          # Returns a new TemplateConfig object
          # @param path [String] The path to the template
          # @return [PDK::Templates::TemplateConfig] The template object
          def initialize(path) # rubocop:disable Metrics/AbcSize
            @config = YAML.load_file(path)
            @path = path

            raise Errors::InvalidError, "Template '#{name_from_path}' is invalid." unless valid?

            @id = @config['template']['id']
            @author = @config['template']['author']
            @display = @config['template']['display']
            @type = @config['template']['type']
            @version = @config['template']['version']
            @data = @config['template']['data'] || {}
            @url = @config['template']['url']
            @location = @config['template']['location'] || Dir.pwd
            @extension = @config['template']['extension']
            @erb = erb_path
          end

          # Returns a string representation of the templates config
          def to_s
            @config.to_yaml
          end

          # Returns the path to the erb template associated with the given config path
          # @return [String] The path to the erb template
          def erb_path
            File.join(File.dirname(@path), "#{@config['template']['id']}.erb")
          end

          private

          # Validates a template
          # A template is valid if it meets the following criteria:
          #  - The template is provided with a valid config.yml file
          #  - The template directory name is identical to the id in the config.yml
          #  - The template is provided with a valid erb templatrequire_relative
          # @return [Boolean] True if the template is valid, false otherwise
          def valid?
            name_from_path == @config['template']['id'] && File.exist?(erb_path)
          end

          # Returns the name of the template from the path
          # @return [String] The name of the template
          def name_from_path
            File.basename(File.dirname(@path))
          end
        end
      end
    end
  end
end
