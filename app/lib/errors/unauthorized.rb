module Errors
  class Unauthorized < Errors::StandardError
    def initialize
      super(
        title: 'Unauthorized',
        status: 401,
        detail: {
          msg: 'You need to login to authorize this request.'
        }
      )
    end
  end
end
