require 'ms/matcher'
require 'ms/event_publisher'
require 'ms/event_subscriber'

$stdout.sync = true

module MS
  class Application

    def initialize
      @matchers = []
    end

    def events(&block)
      yield self if block_given?
    end

    def match(event_type, handler)
      @matchers << Matcher.new(event_type, handler)
    end

    def run
      loop do
        event_subscriber.fetch do |incoming_event|
        @matchers.select   { |matcher| matcher.match?(incoming_event) }
                 .map      { |matcher| matcher.handler }
                 .map      { |handler| Array(handler.(incoming_event)) }
                 .flatten(1)
                 .each     { |outgoing_event| event_publisher.push(outgoing_event) }
        end
      end
    end

    protected

    def event_subscriber
      @sub ||= EventSubscriber.new
    end

    def event_publisher
      @pub ||= EventPublisher.new
    end

  end
end
