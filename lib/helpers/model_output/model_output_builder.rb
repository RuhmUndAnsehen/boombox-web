# frozen_string_literal: true

require_relative 'builder'
require_relative 'attribute_output_builder'
require_relative 'association_output_builder'
require_relative 'spawn_helper'

##
# A HTML builder for ActiveRecord models.
class Helpers::ModelOutput::ModelOutputBuilder
  include ::Helpers::ModelOutput::Builder
  include ::Helpers::ModelOutput::SpawnHelper

  class InvalidConfigError < ::ArgumentError; end

  attr_accessor :model

  tag_names dom_id: :div, association_list: :ul, attribute_list: :dl

  def initialize(*, model:, associations: [],
                 attributes: { except: %i[id created_at updated_at] },
                 **opts, &block)
    @embed = opts.delete(:embed)
    @spawn_options = opts

    super(*, **opts)

    self.model = model

    initialize_associations(associations)
    initialize_attributes(attributes)

    @block = block
  end

  ##
  # Generates HTML for the associations matching +config+.
  #
  # @see #attribute_filter
  def association(config = nil, &block)
    safe_join(
      associations(config).map { |assoc| association_builder(assoc, &block) }
    )
  end

  ##
  # Returns the list of associations associated with the #model matching
  # +config+.
  #
  # @see #attribute_filter
  def associations(config = nil)
    return @associations.then(&attribute_filter(config)) if @associations

    @associations = model.class.reflect_on_all_associations
                         .map(&:name).map(&:to_s).to_set
                         .then(&attribute_filter(config))
  end

  ##
  # Generates HTML for the attributes matching +config+.
  #
  # @see #attribute_filter
  def attribute(config = nil, &block)
    safe_join(
      attributes(config).map { |attr| attribute_builder(attr, &block) }
    )
  end

  ##
  # Returns the list of #model attributes matching +config+.
  #
  # @see #attribute_filter
  def attributes(config = nil)
    return @attributes.then(&attribute_filter(config)) if @attributes

    @attributes = model.attributes.each_key.to_set
                       .then(&attribute_filter(config))
  end

  ##
  # Generates a HTML tag with the +id+ attribute set to #model's +dom_id+.
  def dom_id_tag(content = nil, options = {}, &block)
    if block_given?
      options = content
      content = capture(&block)
    end

    options = add_attribute(class: 'model-contents', id: dom_id(model),
                            to: options)

    content_tag(dom_id_tag_name, content, options)
  end

  ##
  # Returns the value of the embed flag.
  def embed? = @embed

  ##
  # Returns a HTML representation for #model.
  def to_s
    if @block
      content = capture(&@block)
    else
      attrs = content_tag_if_name(attribute_list_tag_name, attribute,
                                  class: 'model-attributes-list')
      assocs = content_tag_if_name(association_list_tag_name, association,
                                   class: 'model-associations-list')
      content = safe_join([attrs.presence, assocs.presence].compact)
    end

    embed? ? content : dom_id_tag(content)
  end

  private

  ##
  # Returns a Proc that takes a Set and returns the transformed Set.
  #
  # Depending on +config+, one of the following procs is returned:
  # +nil+ :: matches all elements
  # +true+ :: matches all elements
  # +false+ :: matches no elements
  # String :: matches only the string itself
  # +only:+ :: matches the value like a String or Enumerable
  # +except:+ :: excludes all elements +only:+ would match and returns the
  #              others
  # Enumerable :: matches only the elements in the Enumerable object
  # Proc :: returns the config unchanged
  def attribute_filter(config) # rubocop:disable Metrics/MethodLength
    case config
    in nil | true | false
      attribute_filter_bool(config)
    in Symbol | String
      attribute_filter_symbol(config)
    in only: config
      attribute_filter_only(config)
    in except: config
      attribute_filter_except(config)
    in Enumerable
      attribute_filter_enumerable(config)
    in Proc
      config
    else
      raise InvalidConfigError, "`#{config.inspect}' is invalid"
    end
  end

  def attribute_filter_bool(config)
    config == false ? ->(_) { Set[] } : lambda(&:itself)
  end

  def attribute_filter_enumerable(config) = ->(set) { set & config.map(&:to_s) }

  def attribute_filter_except(config)
    config = config.then unless config.is_a?(Enumerable)

    ->(set) { set - config.map(&:to_s) }
  end

  def attribute_filter_only(config)
    case config
    when Enumerable
      attribute_filter_enumerable(config)
    else
      attribute_filter_symbol(config)
    end
  end

  def attribute_filter_symbol(config) = attribute_filter_enumerable(config.then)

  def initialize_attributes(config = nil) = attributes(config)
  def initialize_associations(config = Set[]) = associations(config)

  def spawn_options(opts) = @spawn_options.merge(opts)
end
