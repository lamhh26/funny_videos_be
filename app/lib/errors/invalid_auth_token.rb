module Errors
  class InvalidAuthToken < Errors::StandardError
    def initialize
      super(
        title: 'Unprocessable Entity',
        status: 422,
        detail: { msg: "Can't verify CSRF token authenticity" })
    end
  end
end
