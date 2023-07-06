# frozen_string_literal: true

require 'enhanced/form_builder'

# :nodoc:
module ApplicationHelper
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
end
