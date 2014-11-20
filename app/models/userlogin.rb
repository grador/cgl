class Userlogin < ActiveRecord::Base

  include MakeString

  def count_missing
    Userlogin.where(ip_addr: self.ip_addr, created_at: (Time.now - TIME_BLOCK_MIN.minutes)..Time.now, user_id: 0).size
  end

  def self.create_log(user,ip)
    create(user_id: user ? user.id : 0, ip_addr: ip,)
  end

end
