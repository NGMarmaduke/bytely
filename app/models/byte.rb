class Byte < ActiveRecord::Base
  before_save :prepend_http
  after_initialize :set_defaults

  validates :byte, uniqueness: true

  private
  def prepend_http
    return if self.full_url.start_with?('http') and self.full_url.include? ('://')
    self.full_url = "http://#{self.full_url}"
  end
  def set_defaults
    generate_byte if self[:byte].nil?
  end
  def generate_byte
    begin
      self[:byte] = SecureRandom.urlsafe_base64 3
    end while Byte.exists?(:byte => self[:byte])
  end
end
