Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new {|ex,ctx_hash| Rnotifier.exception(ex, {:context_params => ctx_hash}) }
end
