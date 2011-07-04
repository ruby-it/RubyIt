class LoginController < ApplicationController

  def index
    flash.keep
    @question, answer = question()

    flash["answer"]= answer
    @login_name = cookies["author_name"] || "Ruby Fan"

    if answer_ok?
      @session["authenticated"] = true
      cookies["author_name"] = {
        :value => @params["name"],
        :expires =>(Time.now + 1.month) 
      }
      @session["author_name"] = @params['name']

      redirect_to :controller     => 'revisions',
        :action         => 'new',
        :page_title     => flash['page_title'],
        :revision_number => flash["revision_number"]
    end
  end

  private
  def answer_ok?
    @params["answer"] == flash["answer"] and @params["name"]
  end

  def question
    ["2+2?","4"]
  end
end
