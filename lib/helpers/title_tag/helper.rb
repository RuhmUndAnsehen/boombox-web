# frozen_string_literal: true

##
# Provides an interface to generate a page title tag.
module ::Helpers::TitleTag::Helper
  ##
  # Generates a title tag for the site headers.
  def title_tag
    unless respond_to?(:root_path) && current_page?(root_path)
      page = tl(controller_name, action_name)
    end
    appname = t('app.name.long.text', default: 'Boombox')
    description = t('app.description.short.text', default: nil)
    separator = t('app.title.separator', default: ' — ')

    tag.title([page, appname, description].compact.join(separator))
  end
end
