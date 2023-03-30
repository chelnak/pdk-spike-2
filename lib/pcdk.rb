# frozen_string_literal: true

require 'thor'
require 'puppet-lint'

require 'pcdk/api'
require 'pcdk/commands'

module Pcdk
  # The CLI class is the entry point for the pcdk executable.
  class CLI < Thor
    class_options debug: false
    # Top level commands
    # Ideally these would be defined in the subcommands themselves
    desc 'new [template]', 'Create a new project from a template'
    option :name, type: :string, required: true
    option :data, type: :hash, default: {}
    option :renderer, type: :string, default: 'erb'
    option :force, type: :boolean, default: false
    def new(id)
      begin
        template = Pcdk::Api::V1::Templates::Resolver.template(id)
      rescue Pcdk::Api::V1::Errors::NotFoundError
        # TODO: Is there a better way to do this?
        raise Pcdk::Api::V1::Errors::NotFoundError,
              "Template not found! You can run 'pdk templates list' to see installed templates."
      end
      renderer = Pcdk::Api::V1::Templates::Renderer.new(template, options[:name], options[:data], options[:renderer])

      path = [Dir.pwd, template.location, "#{options[:name]}.#{template.extension}"]
      renderer.save(File.join(path), options[:force])
    end

    # Subcommands
    desc 'templates', 'Commands for managing templates used to create project items'
    subcommand 'templates', Pcdk::Commands::Templates

    desc 'plugins', 'Commands for managing plugins used by the PDK'
    subcommand 'plugins', Pcdk::Commands::Plugins

    desc 'version', 'Print the version number'
    def version
      puts Pcdk::VERSION
    end

    desc 'default', 'Print the help information', hide: true
    def default
      puts 'Puppet Development Kit'
      puts 'The shortest path to better content.'
      puts ''
      invoke :help
    end

    default_task :default
  end
end
