class Byte < ActiveRecord::Base
  before_save :prepend_http
  after_initialize :set_defaults

  has_many :clicks

  validates :byte, uniqueness: true

  def record_click!(params = {})
    request = params[:request]
    ua = AgentOrange::UserAgent.new(request.env["HTTP_USER_AGENT"])
    location = get_location(request.remote_ip)
    Click.create(
        byte: self,
        ip: request.remote_ip,
        location: "#{location[:city]} (#{location[:country_code]})",
        city: location[:city],
        country: location[:country_name],
        country_code: location[:country_code],
        referrer: request.referrer || 'Direct',
        referrer_domain: get_domain(request.referrer),
        device: "#{ua.device.name} (#{ua.device.platform.name})")
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

  def click_count_by_day
    Click.where(:byte => self).group_by_day(:created_at, format: "%F").count
  end

  def click_count_by_location
    Click.where(:byte => self).count(:group => :location).sort_by{|k,v| -v}
  end

  private
  def get_domain(url)
    return 'Direct' if url.nil?
    host = URI.parse(url).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
  def get_location(ip)
    Timeout::timeout(5) { JSON.parse(
        Net::HTTP.get_response(
            URI.parse('http://api.hostip.info/get_json.php?ip=' + ip )
        ).body
    )} rescue resuce_location_defaults
  end
  def resuce_location_defaults
    {
      :country_name => 'Unkown',
      :country_code => 'XX',
      :city => 'Unkown'
    }
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
