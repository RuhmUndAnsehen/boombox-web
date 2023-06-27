# frozen_string_literal: true

require 'rational_column/form_builder'

module Enhanced
  ##
  # Defines field methods that facilitate working with enums and rationals.
  class FormBuilder < ActionView::Helpers::FormBuilder
    include RationalColumn::FormBuilder

    def enum_select(enum)
      collection_select(enum, object.class.human_enum_values(enum),
                        :first, :last, selected: object.__send__(enum))
    end

    def enum_radio_buttons(enum)
      collection_radio_buttons(enum, object.class.human_enum_values(enum),
                               :first, :last, checked: object.__send__(enum))
    end
  end
end
