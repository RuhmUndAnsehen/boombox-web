module Alpha3Indexable
  extend ActiveSupport::Concern

  class_methods do
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
  end

  def to_param = alpha3_code
end
