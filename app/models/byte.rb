class Byte < ActiveRecord::Base
  before_save :prepend_http

  def prepend_http
    return if self.full_url.start_with?('http') and self.full_url.include? ('://')
    self.full_url = "http://#{self.full_url}"
  end
end
