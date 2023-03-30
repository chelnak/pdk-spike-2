# frozen_string_literal: true

require 'yaml'
require_relative 'template_config'

module Pcdk
  module Api
    module V1
      module Templates
        # A template resolver class
        class Resolver
          @configdir = File.join('.', '.pdk', 'templates')

          # Returns the path to the template with the given id
          # @param id [String] The id of the template to find
          # @return [TemplateConfig] An object that represents the template config
          def self.template(id)
            path = File.join(@configdir, id, 'config.yml')
            raise Errors::NotFoundError, "Template '#{id}' not found." unless File.exist?(path)

            TemplateConfig.new(path)
          end

          # Returns a list of all template paths
          # @return [Array[TemplateConfig] An array of objects that represent the template configs
          def self.templates
            if !Dir.exist?(@configdir) || Dir.empty?(@configdir)
              raise Errors::DirectoryEmptyError, "No templates found in #{@configdir}"
            end

            Dir[File.join(@configdir, '*', 'config.yml')].sort.map do |path|
              TemplateConfig.new(path)
            end
          end
        end
      end
    end
  end
end
