# frozen_string_literal: true

require 'thor'
require 'terminal-table'
require_relative '../api/v1/templates'
require_relative 'subcommand'

module Pcdk
  module Commands
    # The templates subcommand
    class Plugins < SubCommand
      desc 'list', 'List all plugin'
      def list
        plugins = Pcdk::Api::V1::Plugins.registered_plugins

        table = Terminal::Table.new do |t|
          plugins.each do |name, plugin|
            t.add_row([name, plugin.type, plugin.author, plugin.desc, plugin.version])
          end
        end

        table.headings = ['name', 'type', 'author', 'desc', 'version']
        table.style = { border: :unicode }
        puts table
      end
    end
  end
end
