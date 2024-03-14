module Errors
  class InvalidRecord < Errors::StandardError
    def initialize(err)
      super(
        title: 'Unprocessable Entity',
        status: 422,
        detail: err.record.errors.to_hash
      )
    end
  end
end
