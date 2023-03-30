# frozen_string_literal: true

require 'thor'

module Pcdk
  module Commands
    # The base class for all subcommands
    # See https://github.com/rails/thor/wiki/Subcommands#subcommands-that-work-correctly-with-help
    class SubCommand < Thor
      def self.banner(command, *_args)
        "#{basename} #{subcommand_prefix} #{command.usage}"
      end

      def self.subcommand_prefix
        name.gsub(/.*::/, '').gsub(/^[A-Z]/) { |match| match[0].downcase }.gsub(/[A-Z]/) do |match|
          "-#{match[0].downcase}"
        end
      end
    end
  end
end
