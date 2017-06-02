require './app'

Thread.abort_on_exception = true

Thread.new do
  begin
    Aloha::Bot.run
    run Aloha::Server.new
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Aloha::Web.new