require_relative '../../lib/entity'
require_relative '../../lib/validation'

class Node < Entity
  PRODUCT_LINES = [:mr, :ms, :mx, :mv, :mg, :mt]
  TYPES = [:virtual, :wired, :wireless]
  MAC_ADDRESS_FORMAT = /[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}/i
  IP_ADDRESS_FORMAT = /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/

  include Validation

  validates :name
  validates :product_line, list: PRODUCT_LINES
  validates :model
  validates :type, list: TYPES
  validates :mac_address, regex: MAC_ADDRESS_FORMAT
  validates :serial
  validates :ip_address, regex: IP_ADDRESS_FORMAT

  attr_accessor :name, :product_line, :model, :type, :mac_address, :serial, :ip_address, :network_id
end
