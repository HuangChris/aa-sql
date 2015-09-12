# == Schema Information
#
# Table name: taggings
#
#  id           :integer          not null, primary key
#  created_at   :datetime
#  updated_at   :datetime
#  url_id       :integer
#  tag_topic_id :integer
#

class Tagging < ActiveRecord::Base
  belongs_to(
    :tag_topic,
    class_name: :TagTopic,
    foreign_key: :tag_topic_id,
    primary_key: :id
    )

  belongs_to(
    :url,
    class_name: :ShortenedUrl,
    foreign_key: :url_id,
    primary_key: :id
    )

  def self.create_by_url_and_tag_topic!(url, tagtopic)
    self.create!(url_id: url.id, tag_topic_id: tagtopic.id)
  end
end
