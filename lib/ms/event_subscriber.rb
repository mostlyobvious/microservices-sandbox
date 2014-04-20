require 'ms/event_serializer'
require 'poseidon'
require 'securerandom'

module MS
  class EventSubscriber

    def initialize
      @consumer = Poseidon::PartitionConsumer.new(SecureRandom.uuid, 'localhost', 9092, 'all', 0, :latest_offset)
    end

    def fetch
      @consumer.fetch.each do |message|
        yield event_serializer.load(message.value)
      end
    end

    protected

    def event_serializer
      EventSerializer.new
    end

  end
end
