require 'singleton'

class MessageStore

  include Singleton

  attr_accessor :name, :body, :status

  def initialize
    @name, @body, @status = '', '', 'new'
  end

  # MessageStore.instance

  # def publish(name, body,status)
  #   self.name = name
  #   self.body = body
  #   self.status = status
  # end
  #
  def self.clean
    instance.name = ''
    instance.body = ''
    instance.status = 'new'
    instance
  end

end