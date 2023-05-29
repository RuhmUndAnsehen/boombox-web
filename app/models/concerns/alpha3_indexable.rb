module Alpha3Indexable
  extend ActiveSupport::Concern

  class_methods do
    ##
    # Returns the first record from a #smart_lookup.
    #
    # Raises ActiveRecord::RecordNotFound if no record is found.
    def smart_find!(id) = smart_lookup(id).first!

    ##
    # Like #smart_find, but returns +nil+ when a record can't be found.
    def smart_find(id)
      smart_find!(id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    ##
    # If the method name consists of three uppercase letters, retrieve the
    # respective record from the database.
    def method_missing(name, *, **, &)
      if name.match?(/\A[[:upper:]]{3}\z/)
        record = find_by_abc(name)
        return record if record
      end

      super
    end

    ##
    # Returns a relation that searches multiple indexable columns for +id+.
    #
    # The default columns are (in that order): #alpha3_code, #id, #numeric_code
    def smart_lookup(id) = smart_lookup_helper(id)
  end

  included do
    scope :smart_lookup_helper,
          ->(id) {
            where(alpha3_code: id).or(where(id:)).or(where(numeric_code: id))
          }
  end

  prepended { raise 'include this Concern to define scopes' }

  def to_param = alpha3_code
end
