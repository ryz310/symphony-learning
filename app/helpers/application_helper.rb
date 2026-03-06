require "rdoc"
require "rdoc/markdown"
require "rdoc/markup"
require "rdoc/markup/to_html"
require "rdoc/options"

module ApplicationHelper
  MARKDOWN_ALLOWED_TAGS = %w[
    a
    blockquote
    br
    code
    em
    h1
    h2
    h3
    h4
    h5
    h6
    li
    ol
    p
    pre
    strong
    ul
  ].freeze
  MARKDOWN_ALLOWED_ATTRIBUTES = %w[href].freeze

  def render_markdown(markdown)
    return if markdown.blank?

    document = RDoc::Markdown.new([]).parse(markdown.to_s)
    html = RDoc::Markup::ToHtml.new(RDoc::Options.new, RDoc::Markup.new).convert(document)
    sanitize(html, tags: MARKDOWN_ALLOWED_TAGS, attributes: MARKDOWN_ALLOWED_ATTRIBUTES)
  end
end
