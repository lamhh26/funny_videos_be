module ErrorHandler
  extend ActiveSupport::Concern

  ERRORS = {
    'ActiveRecord::RecordNotFound' => 'Errors::NotFound',
    'ActionController::InvalidAuthenticityToken' => 'Errors::InvalidAuthToken'
  }.freeze

  included do
    rescue_from(StandardError, with: proc { |e| handle_error(e) })
  end

  private

  def handle_error(err)
    logger.error(err)
    mapped = map_error(err)
    # notify about unexpected_error unless mapped
    mapped ||= Errors::StandardError.new
    render_error(mapped)
  end

  def map_error(err)
    return err if Errors::StandardError.descendants.include?(err.class)

    ERRORS[err.class.name]&.constantize&.new
  end

  def render_error(error)
    render json: ErrorSerializer.new(error), status: error.status
  end
end