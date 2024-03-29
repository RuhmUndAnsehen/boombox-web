# frozen_string_literal: true

require 'helpers/navigation_helper'
require 'helpers/show_helper'

# :nodoc:
module ApplicationHelper
  include ::Helpers::NavigationHelper
  include ::Helpers::ShowHelper
  include ::Helpers::TitleTag::Helper

  ##
  # Generates a form with a single button that submits to a controller create
  # action.
  #
  # +params+ is a hash where the key is the singular model name, and the value
  # is a hash containing the model attributes.
  def button_to_create(params, *args, **opts)
    unless params.size == 1
      raise ArgumentError, "expected params.size == 1, got: #{params.size}"
    end

    model, params = params.flatten
    params.transform_keys! { |key| "#{model}[#{key}]" }
    controller = opts.delete(:controller) || model.to_s.pluralize

    button_to(tl(controller, :create), { controller:, action: :create }, *args,
              method: :post, params:, **opts)
  end

  ##
  # Transforms a relation or collection of records for use in a Chartkick chart.
  #
  # [records]
  #             Collection of records
  # [group_by]
  #             A proc like object (i.e. symbol or lambda) that the method
  #             passes to Enumerable#group_by. Use this if you want to display
  #             multiple graphs in the same chart.
  # [klass]
  #             In multiline charts and when +records+ is not a relation, this
  #             Class is used for translation lookup.
  # [block]
  #             Produces graph data points from the actual data, typically by
  #             returning a two-element array. Omit the block if the data is
  #             ready as it is.
  def chart_data(records, group_by: nil, klass: nil, &block)
    return records.map(&block) unless group_by

    data = records.group_by(&group_by)
    return chart_data(records, &block) if data.size == 1

    klass ||= records.klass
    data.map { |name, group| { name: klass.t(name), data: group.map(&block) } }
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize

  ##
  # Provides translations for controller actions.
  #
  # It resolves in I18n like so: +"links.#{controller}.#{action}+
  #
  # The method signatures with positional and named parameters are
  # interchangeable, and positional and named parameters can also occur mixed.
  #
  # :call-seq:
  #     t_link(controller = self, action = :index, default = nil) => ...
  #     t_link(model, action = :show, default = nil) => ...
  #     t_link(controller: self, action: :index, default: nil) => ...
  #     t_link(model:, action: :show, default: nil) => ...
  def t_link(*args, **opts)
    controller, action, default = t_link_params(args, opts)

    if controller.respond_to?(:controller_name)
      controller = controller.controller_name
    elsif controller.respond_to?(:model_name)
      model_name = controller.model_name
      controller = model_name.i18n_key
      action ||= :show

      default ||= t_link_default(action, model_name.singular, model_name.plural)
    end

    action  ||= :index
    default ||= t_link_default(action, controller)

    t(action, default:, scope: [:links, controller])
  end
  alias tl t_link
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def t_link_default(action, singular, plural = nil)
    unless plural
      plural = singular.to_s.pluralize
      singular = singular.to_s.singularize
    end

    (action.to_sym == :index ? plural : "#{action}_#{singular}").titleize
  end

  def t_link_params(args, opts)
    controller = if opts.key?(:controller)
                   opts.delete(:controller)
                 elsif opts.key?(:model)
                   opts.delete(:model)
                 else
                   args.shift
                 end
    action = opts.key?(:action) ? opts.delete(:action) : args.shift
    default = opts.key?(:default) ? opts.delete(:default) : args.shift

    [controller.presence || self, action.presence, default]
  end
end
