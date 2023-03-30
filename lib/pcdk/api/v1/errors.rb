# frozen_string_literal: true

module Pcdk
  module Api
    module V1
      module Errors
        class RenderError < StandardError; end

        class TemplateVariableError < StandardError; end

        class FileSaveError < StandardError; end

        class NotFoundError < StandardError; end

        class DirectoryEmptyError < StandardError; end

        class MissingVariableError < StandardError; end
      end
    end
  end
end
