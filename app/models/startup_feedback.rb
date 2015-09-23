class StartupFeedback < ActiveRecord::Base
  belongs_to :startup
  belongs_to :feedback_by, foreign_key: 'feedback_by', class_name: 'AdminUser'
  attr_accessor :send_email

  REGEX_TIMELINE_EVENT_URL = %r{startups/.*event-(?<event_id>[\d]+)}

  # Returns all feedback for a given timeline event.
  def self.for_timeline_event(event)
    where('reference_url LIKE ?', "%event-#{event.id}").order('updated_at desc')
  end

  def for_timeline_event?
    if reference_url.present? && reference_url.match(REGEX_TIMELINE_EVENT_URL).present?
      true
    else
      false
    end
  end

  def timeline_event
    return unless reference_url.present? && reference_url.match(REGEX_TIMELINE_EVENT_URL).present?
    TimelineEvent.find(reference_url.match(REGEX_TIMELINE_EVENT_URL)[:event_id])
  end
end
