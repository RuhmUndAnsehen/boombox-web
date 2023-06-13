# frozen_string_literal: true

require 'rational_column/model'
require 'rational_column/schema'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.prepend(RationalColumn::Model)
  ActiveRecord::ConnectionAdapters::ColumnMethods
    .include(RationalColumn::Schema)
end
