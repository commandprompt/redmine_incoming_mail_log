require 'redmine'
require 'dispatcher'

require_dependency 'redmine_incoming_mail_log/view_hooks'

Dispatcher.to_prepare :redmine_incoming_mail_log do
  require_dependency 'mail_handler'
  require_dependency 'mailer'

  unless MailHandler.included_modules.include? RedmineIncomingMailLog::MailHandlerPatch
    MailHandler.send(:include, RedmineIncomingMailLog::MailHandlerPatch)
  end

  unless Mailer.included_modules.include? RedmineIncomingMailLog::MailerPatch
    Mailer.send(:include, RedmineIncomingMailLog::MailerPatch)
  end
end

Redmine::Plugin.register :redmine_incoming_mail_log do
  name 'Redmine Incoming Mail Log plugin'
  author 'Alex Shulgin <ash@commandprompt.com>'
  description 'A plugin to record incoming mails and statuses of handling them.'
  version '0.0.1'
  url 'http://github.com/commandprompt/redmine_incoming_mail_log'
  #  author_url 'http://example.com/about'

  menu :admin_menu, :incoming_mails,
    { :controller => 'incoming_mails', :action => 'index' },
    :caption => :label_incoming_mail_plural,
    :html => { :class => 'incoming_mails' }

  settings :default => {}, :partial => 'settings/settings'
end
