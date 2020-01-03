require_relative '../../lib/entity'
require_relative '../../lib/validation'

class Device < Entity
  TYPES = [:virtual, :wired, :wireless]
  MAC_ADDRESS_FORMAT = /[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}/i
  IP_ADDRESS_FORMAT = /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/

  include Validation

  validates :name
  validates :type, list: TYPES
  validates :mac_address, regex: MAC_ADDRESS_FORMAT
  validates :ip_address, regex: IP_ADDRESS_FORMAT

  attr_accessor :name, :type, :mac_address, :ip_address
end
