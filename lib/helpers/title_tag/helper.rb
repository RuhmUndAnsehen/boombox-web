# frozen_string_literal: true

##
# Provides an interface to generate a page title tag.
module ::Helpers::TitleTag::Helper
  ##
  # Generates a title tag for the site headers.
  def title_tag
    ::Helpers::TitleTag::Builder.new(self)
  end
end
