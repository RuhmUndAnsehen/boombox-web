# frozen_string_literal: true

##
# A title tag builder class that facilitates configuration of the page title.
class ::Helpers::TitleTag::Builder
  include ::Helpers::Builder

  def to_s
    unless respond_to?(:root_path) && current_page?(root_path)
      page = tl(controller_name, action_name)
    end
    appname = t('app.name.long.text', default: 'Boombox')
    description = t('app.description.short.text', default: nil)
    separator = t('app.title.separator', default: ' — ')

    tag.title([page, appname, description].compact.join(separator))
  end
end
