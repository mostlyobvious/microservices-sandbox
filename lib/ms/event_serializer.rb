require 'ms/event'
require 'time'
require 'json'

module MS
  class EventSerializer

    def load(data)
      hash = JSON.load(data)
      Event.new(hash['id'], Time.parse(hash['timestamp']), hash['type'])
    end

    def dump(event)
      hash = event.to_h
      hash[:timestamp] = hash[:timestamp].iso8601
      JSON.dump(hash)
    end

  end
end
