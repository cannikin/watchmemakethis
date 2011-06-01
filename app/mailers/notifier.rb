class Notifier < ActionMailer::Base
  
  default :from => "rob@watchmemake.com"
  
  def welcome(user, site, host)
    @user = user
    @site = site
    @host = host
    
    mail  :to => user.email,
          :from => 'Watch Me Make <noreply@watchmemake.com>',
          :subject => 'Welcome to Watch Me Make!'
  end


  # sent when there's a problem importing an image via twitter
  def twitter_error(user, build=nil)
    @greeting = "Hi"

    mail :to => "to@example.org"
  end


  # sent when there's a problem importing an image via twitter
  def email_error(user, build=nil)
    @greeting = "Hi"

    mail :to => "to@example.org"
  end
  
  
  # sent when you invite someone to your build
  def invite(build, emails)
    @greeting = "Hi"

    mail :to => "to@example.org"
  end


  def forgot_password(user)
    @greeting = "Hi"

    mail :to => "to@example.org"
  end
end
