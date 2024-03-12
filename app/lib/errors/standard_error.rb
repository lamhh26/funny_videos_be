module Errors
  class StandardError < ::StandardError
    attr_reader :title, :detail, :status, :source

    def initialize(title: nil, status: nil, detail: nil)
      super()
      @title = title || 'Something went wrong'
      @status = status || 500
      @detail = detail.nil? ? { msg: 'We encountered unexpected error' } : detail
    end

    def to_h
      {
        status: @status,
        title: @title,
        detail: @detail
      }
    end

    def serializable_hash
      to_h
    end

    def to_s
      to_h.to_s
    end
  end
end
