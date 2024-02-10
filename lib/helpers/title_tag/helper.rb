# frozen_string_literal: true

##
# Provides an interface to generate a page title tag.
module ::Helpers::TitleTag::Helper
  ##
  # Generates a title tag for the site headers.
  def title_tag
    # rubocop:disable Naming/MemoizedInstanceVariableName
    @_title_tag ||= ::Helpers::TitleTag::Builder.new(self)
    # rubocop:enable  Naming/MemoizedInstanceVariableName
  end

  ##
  # Configures the title tag builder.
  #
  # :call-seq: title_tag!(title = nil, page: nil, page_description: nil,
  #                       app: nil, app_description: nil, separator: nil)
  def title_tag!(title = nil, **args)
    @_title_tag ||= ::Helpers::TitleTag::Builder.new(self)
    @_title_tag.update(title, **args)
  end
end
