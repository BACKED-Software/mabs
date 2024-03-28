# frozen_string_literal: true

class HelpController < ApplicationController
  layout 'authenticated_layout'

  before_action :load_articles, only: %i[index show]

  def index
    # Optionally implement search functionality here
    # @articles is already available from the before_action
  end

  def show
    file_path = Rails.root.join('app', 'assets', 'documents', "#{params[:id]}.md")
    if File.exist?(file_path)
      @content = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(File.read(file_path))
    else
      render 'not_found'
    end
  end

  private

  def load_articles
    @articles = Dir.glob(Rails.root.join('app', 'assets', 'documents', '*.md')).map do |file_path|
      File.basename(file_path, '.md')
    end
  end
end
