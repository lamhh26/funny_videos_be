module Errors
  class InvalidRecord < Errors::StandardError
    def initialize(error)
      super(
        title: 'Unprocessable Entity',
        status: 422,
        detail: error.reduce([]) { |r, (field, msg)| r << { field:, msg: msg[0] } })
    end
  end
end
