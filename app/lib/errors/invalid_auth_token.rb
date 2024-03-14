module Errors
  class InvalidAuthToken < Errors::StandardError
    def initialize(_err = nil)
      super(
        title: 'Unprocessable Entity',
        status: 422,
        detail: "Can't verify CSRF token authenticity"
      )
    end
  end
end
