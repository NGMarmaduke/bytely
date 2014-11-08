class Byte < ActiveRecord::Base
  before_save :prepend_http
  after_initialize :set_defaults

  has_many :clicks

  validates :byte, uniqueness: true

  def record_click!(params = {})
    request = params[:request]

    Click.create(
        byte: self,
        ip: request.remote_ip,
        referrer: request.referrer || 'Direct',
        referrer_domain: get_domain(request.referrer),
        device: request.env['mobvious.device_type'])
  end

  def click_count
    self.clicks.count
  end

  def click_count_by_domains
    Click.where(:byte => self).count(:group => :referrer_domain).sort_by{|k,v| -v}
  end

  def click_count_by_devices
    Click.where(:byte => self).count(:group => :device).sort_by{|k,v| -v}
  end

  private
  def get_domain(url)
    return 'Direct' if url.nil?
    host = URI.parse(url).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
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
