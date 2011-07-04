class ApplicationController < ActionController::Base
  protect_from_forgery
  include ExceptionNotifiable
end

ExceptionNotifier.exception_recipients = %w(rff_rff@yahoo.it)
