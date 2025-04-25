module RedmineIncomingMailLog
  module MailerPatch
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        helper IncomingMailsHelper
        helper ActionView::Helpers::UrlHelper
        include InstanceMethods
      end
    end

    module ClassMethods
      def deliver_failed_incoming_mail(recipient, incoming_mail)
        failed_incoming_mail(recipient, incoming_mail).deliver_now
      end

      def deliver_unhandled_mail_report(recipient, mails)
        unhandled_mail_report(recipient, mails).deliver_now
      end
    end

    module InstanceMethods
      def unhandled_mail_report(recipient, mails)
        @mails = mails
        mail :to => recipient,
          :subject => l(:mail_subject_unhandled_mail_report)
      end

      def failed_incoming_mail(recipient, incoming_mail)
        @mail = incoming_mail
        @url = url_for({:action => 'show', :controller => 'incoming_mails', :id => incoming_mail.id})
        mail :to => recipient,
          :subject => l(:mail_subject_failed_incoming_mail)
      end
    end
  end
end
