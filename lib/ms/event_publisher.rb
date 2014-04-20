require 'ms/event_serializer'
require 'poseidon'
require 'securerandom'

module MS
  class EventPublisher

    def initialize
      @producer = Poseidon::Producer.new(['localhost:9092'], SecureRandom.uuid)
    end

    def push(event)
      @producer.send_messages([Poseidon::MessageToSend.new('all', event_serializer.dump(event))])
    end

    protected

    def event_serializer
      EventSerializer.new
    end

  end
end
