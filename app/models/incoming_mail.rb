class IncomingMail < ActiveRecord::Base
  unloadable

  scope :for_project, -> (project) { where(:target_project => project) }
  scope :sender_like, -> (sender) { where(["sender_email ILIKE ?", "%#{sender}%"]) }
  scope :subject_like, -> (subject) { where(["subject ILIKE ?", "%#{subject}%"]) }
  scope :unhandled, -> { where(:handled => false) }
  scope :received_on, -> (date) { where(["created_on::date = ?", date]) }
  default_scope { order("created_on DESC") }

  def self.report!
    console = Logger.new(STDOUT)
    settings = Setting['plugin_redmine_incoming_mail_log']
    should_notify = ActiveModel::Type::Boolean.new.cast(settings[:notify_failed])
    console.warn("Incoming Mail Log -> notify failed setting is disabled, skipping report") unless should_notify
    return unless should_notify

    recipient = EmailAddress.find_by(address: settings[:notify_email]).try(:user)
    Mailer.deliver_unhandled_mail_report(recipient, reorder("target_project, created_on DESC")) and return if recipient
    console.warn("Incoming Mail Log -> report recipient notification email address not found, skipping report")
  end

  def project
    @project ||= Project.visible.find_by_identifier(target_project)
  end

  def target_project=(project_identifier)
    @project = nil
    super project_identifier
  end

  def sender
    @sender ||= User.find_by_mail(sender_email)
  end

  def sender_email=(email)
    @sender = nil
    super email
  end

  def reload(*args)
    @project = nil
    @sender = nil
    super *args
  end

  def display_subject
    subject.present? ? subject : "(no subject)"
  end
end
