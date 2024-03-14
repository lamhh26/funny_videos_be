module Errors
  class NotFound < Errors::StandardError
    def initialize(_err = nil)
      super(
        title: 'Record not Found',
        status: 404,
        detail: 'We could not find the record you were looking for.'
      )
    end
  end
end
