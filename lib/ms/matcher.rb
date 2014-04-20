require 'dependor'
require 'dependor/shorty'

module MS
  class Matcher
    MATCH_ALL = '*'.freeze

    takes :event_type, :handler

    def match?(event)
      [MATCH_ALL, event.type].include? event_type.to_s
    end

  end
end
