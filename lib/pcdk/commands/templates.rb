# frozen_string_literal: true

require 'thor'
require 'terminal-table'
require_relative '../api/v1/templates'
require_relative 'subcommand'

module Pcdk
  module Commands
    # The templates subcommand
    class Templates < SubCommand
      desc 'list', 'List all templates'
      def list
        templates = Pcdk::Api::V1::Templates::Resolver.templates

        table = Terminal::Table.new do |t|
          templates.each do |template|
            t.add_row([template.id, template.display, template.author, template.version])
          end
        end

        table.headings = ['id', 'display', 'author', 'version']
        table.style = { border: :unicode }
        puts table
      end

      desc 'show', 'Show a templates configuration'
      option :id, required: true
      def show
        template = Pcdk::Api::V1::Templates::Resolver.template(options[:id])
        puts template.to_s
      end
    end
  end
end
