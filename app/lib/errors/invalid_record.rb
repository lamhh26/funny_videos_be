module Errors
  class InvalidRecord < Errors::StandardError
    def initialize(error)
      super(
        title: 'Unprocessable Entity',
        status: 422,
        detail: error
      )
    end
  end
end
