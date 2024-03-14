module Errors
  class Unauthorized < Errors::StandardError
    def initialize(_err = nil)
      super(
        title: 'Unauthorized',
        status: 401,
        detail: 'You need to login to authorize this request.'
      )
    end
  end
end
