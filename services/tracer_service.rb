require 'ms/application'

$stdout.sync = true

class TracerService

  def run
    application = MS::Application.new
    application.events do |ev|
      ev.match '*', ->(event) { $stdout.puts(event.inspect) }
    end
    application.run
  end

end

microservice = TracerService.new
microservice.run
