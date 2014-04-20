require 'ms/event_publisher'
require 'ms/event'
require 'securerandom'


event = MS::Event.new(SecureRandom.uuid, Time.new.utc, :order_accepted)
MS::EventPublisher.new.push(event)
