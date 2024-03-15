module Errors
  class ParameterMissing < Errors::StandardError
    def initialize(err)
      super(
        title: 'Parameter Missing',
        status: 400,
        detail: err.message
      )
    end
  end
end
