# frozen_string_literal: true

Pcdk::Api::V1::Plugins.new_renderer('epp') do
  require 'erb'

  @author = 'Puppet, Inc.'
  @type = 'renderer'
  @desc = 'Render an EPP template'
  @version = '1.0.0'

  def render(template, context)
    ERB.new(template).result(context)
  end
end
