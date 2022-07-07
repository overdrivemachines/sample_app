class ApplicationController < ActionController::Base
  include SessionsHelper # Make SessionsHelper available in all controllers
  def hello
    render html: "hello, world!"
  end
end
