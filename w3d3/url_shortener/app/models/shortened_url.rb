# == Schema Information
#
# Table name: shortened_urls
#
#  id            :integer          not null, primary key
#  long_url      :string           not null
#  shortened_url :string           not null
#  submitter_id  :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :submitter_id, presence: true
  validates :shortened_url, presence: true, uniqueness: true
  # validates :long_url, presence: true

  belongs_to(
    :submitter,
    class_name: :User,
    foreign_key: :submitter_id,
    primary_key: :id
    )

  has_many(
    :visits,
    class_name: :Visit,
    foreign_key: :url_id,
    primary_key: :id
    )

  has_many(
    :visitors,
    # class_name: :User,
    Proc.new { distinct },
    through: :visits,
    source: :visitor
    )

  has_many(
    :taggings,
    class_name: :Tagging,
    foreign_key: :url_id,
    primary_key: :id
    )
    
  has_many :tag_topics, through: :taggings, source: :tag_topic

  def self.random_code
    code = SecureRandom::urlsafe_base64

      while ShortenedUrl.exists?(shortened_url: code)
        code = SecureRandom::urlsafe_base64
      end

    code
  end

  def self.create_for_user_and_long_url!(submitter, long_url)
    ShortenedUrl.create!(
      long_url: long_url,
      submitter_id: submitter.id,
      shortened_url: self.random_code
    )
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where("visits.created_at > ?", 10.minutes.ago).count
    # self.num_uniques.where("visits.created_at > ?", Time.now - 6000)
  end
end
