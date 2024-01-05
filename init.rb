require 'redmine'

Redmine::Plugin.register :redmine_incoming_mail_log do
  name 'Redmine Incoming Mail Log plugin'
  author 'Alex Shulgin <ash@commandprompt.com>'
  description 'A plugin to record incoming mails and statuses of handling them.'
  version '0.3.0'
  url 'http://github.com/commandprompt/redmine_incoming_mail_log'
  requires_redmine :version_or_higher => '5.0'
  menu :admin_menu, :incoming_mails,
    { :controller => 'incoming_mails', :action => 'index' },
    :caption => :label_incoming_mail_plural,
    :html => { :class => 'icon icon-email' }

  settings :default => {},
    :partial => 'settings/redmine_incoming_mail_log_settings'
end

MailHandler.send(:include, RedmineIncomingMailLog::MailHandlerPatch)
Mailer.send(:include, RedmineIncomingMailLog::MailerPatch)


# require_dependency 'redmine_incoming_mail_log/view_hooks'
