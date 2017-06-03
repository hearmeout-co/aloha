require './app'

Thread.abort_on_exception = true

Thread.new do
  begin
    Aloha::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

Thread.new do
  begin
    server = Aloha::Server.new(hook_handlers: Aloha::Server::HOOK_HANDLERS)
    server.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Aloha::Web.new