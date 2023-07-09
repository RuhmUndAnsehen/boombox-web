# frozen_string_literal: true

require 'enhanced/form_builder'

# :nodoc:
module ApplicationHelper
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
  # Decorates the built-in #form_with by switching the default form builder with
  # Enhanced::FormBuilder.
  def form_with(*, **opts, &)
    super(*, **{ builder: Enhanced::FormBuilder }.merge(opts), &)
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
    klass ||= records.klass

    if group_by
      result = records.group_by(&group_by)
      return chart_data(records, &block) if result.size == 1

      result.map do |name, group|
        { name: klass.t(name), data: group.map(&block) }
      end
    else
      records.map(&block)
    end
  end

  ##
  # Provides translations for controller actions.
  #
  # It resolves in I18n like so: +"links.#{controller}.#{action}+
  #
  # :call-seq:
  #     t_link(controller, action, default: nil) => "..."
  #     t_link(action, default: nil) => "..."
  #     t_link(model, action, default: nil) => "..."
  def t_link(controller, action = nil, default: nil)
    controller, action = action, controller unless action

    controller ||= controller_name
    if controller.respond_to?(:model_name)
      model_name = controller.model_name
      controller = model_name.i18n_key

      default ||= t_link_default(action, model_name.singular, model_name.plural)
    else
      default ||= t_link_default(action, controller)
    end

    t(action, default:, scope: [:links, controller])
  end
  alias tl t_link

  def t_link_default(action, singular, plural = nil)
    unless plural
      plural = singular.to_s.pluralize
      singular = singular.to_s.singularize
    end

    (action.to_sym == :action ? plural : "#{action}_#{singular}").titleize
  end
end
