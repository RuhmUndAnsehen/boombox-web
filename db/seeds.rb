# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'csv'

# Proc that transforms human readable CSV column names into Model columns.
def key_transform_proc
  ->(str) { str.titleize.gsub(' ', '').underscore.to_sym }
end

# Returns a proc that transforms column values based on the column name.
def col_transform_proc(**col_transforms)
  transforms = Hash.new(:itself).merge(col_transforms)
  proc { |key, value| [key, transforms[key].to_proc[value]] }
end

# Read data from CSV file and convert into Hash.
def read_csv(file)
  file = Pathname.new(file)
  file = Pathname.new(__dir__) / 'seeds' / file unless file.absolute?

  CSV.parse(file.read, headers: true, return_headers: false).map(&:to_h)
end

# Read data from CSV file and process into record attributes.
def read_csv_to_attributes(file, col_transforms: {})
  data = read_csv(file)
  data.each { |row| row.transform_keys!(&key_transform_proc) }
  data.map! { |row| row.to_h(&col_transform_proc(**col_transforms)) }
end
