# frozen_string_literal: true

##
# A title tag builder class that facilitates configuration of the page title.
class ::Helpers::TitleTag::Builder
  include ::Helpers::Builder

  def initialize(...)
    super

    @title ||= {}
  end

  attr_reader :separator, :title

  ##
  # Returns +true+ if the current page is the site root.
  def homepage? = respond_to?(:root_path) && current_page?(root_path)

  ##
  # Returns an HTML string representation for this object.
  #
  # If #title is a Hash, extracts the values for the keys +:page+,
  # +page_description+, +:app+ and +:app_description+ and joins them in that
  # order using #separator.
  #
  # If #title is not a Hash, elements are joined using #separator.
  #
  # For all title components including the separator, and if not specified by
  # the user, an I18n lookup is performed.
  def to_s
    tag.title(title_array.compact.join(@separator || separator_i18n))
  end

  ##
  # Updates the title configuration.
  #
  # Expects either one positional argument or keyword arguments, not both. The
  # +separator+ may be given with either option as it is also stored separately.
  # If keyword arguments other than +separator+ are given and #title is not a
  # Hash, #title is initialized to a new Hash.
  #
  # If +title+ is given, semantics depend on its type (also see #to_s for
  # details):
  # [Hash] Replaces the existing configuration. Hash contents have the usual
  #        semantics (#to_s).
  # [Enumerable] Replaces the existing #title. Elements are joined
  #              with the configured #separator.
  # [other] The argument is treated like the +page+ keyword argument.
  #
  # @see #to_s
  #
  # :call-seq:
  #     update(title = nil, page: nil, page_description: nil, app: nil,
  #                         app_description: nil, separator: nil) -> self
  def update(title = nil, separator: nil, **args)
    params = new_params_hash(args)
    if title && !params.empty?
      raise ArgumentError,
            'expected either one positional or keyword arguments, got both'
    end

    @separator = separator
    @title = new_title_params(title, params)

    self
  end

  private

  def new_params_hash(args)
    args.slice(:page, :page_description, :app, :app_description)
        .select { |_, val| val.present? }
  end

  def new_title_params(title, params)
    return title if title.is_a?(Enumerable)

    params.merge!(page: title) if title.is_a?(String)

    title = @title.is_a?(Hash) ? @title : {}
    title.merge(params)
  end

  def title_array
    return [*@title] unless @title.is_a?(Hash)

    page, page_description, app, app_description =
      @title.values_at(:page, :page_description, :app, :app_description)

    unless homepage?
      page             ||= page_i18n
      page_description ||= page_description_i18n
    end
    app             ||= app_name_i18n
    app_description ||= app_description_i18n

    [page, page_description, app, app_description]
  end

  def page_i18n = tl(controller_name, action_name)
  def page_description_i18n = nil
  def app_name_i18n = t('app.name.long.text', default: 'Boombox')
  def app_description_i18n = t('app.description.short.text', default: nil)
  def separator_i18n = t('app.title.separator', default: ' — ')
end
