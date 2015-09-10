# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer          not null
#  url_id     :integer          not null
#

class Visit < ActiveRecord::Base
  validates :user_id, presence: true
  validates :url_id, presence: true

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, url_id: shortened_url.id)
  end

  belongs_to :visitor,
    class_name: :User,
    foreign_key: :user_id,
    primary_key: :id

  belongs_to :visited_url,
    class_name: :ShortenedUrl,
    foreign_key: :url_id,
    primary_key: :id
end
