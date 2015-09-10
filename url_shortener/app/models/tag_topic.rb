# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  tag        :string
#

class TagTopic < ActiveRecord::Base
  has_many(
    :taggings,
    class_name: :Tagging,
    foreign_key: :tag_topic_id,
    primary_key: :id
    )

  has_many :urls, through: :taggings, source: :url

  def most_popular_url
    #nice
    query = <<-SQL
    SELECT
      shortened_urls.*
    FROM
      shortened_urls
    JOIN
      taggings on taggings.url_id = shortened_urls.id
    LEFT OUTER JOIN
      visits on visits.url_id = shortened_urls.id
    WHERE
      taggings.tag_topic_id = :id
    GROUP BY
      shortened_urls.id
    ORDER BY
      COUNT(visits.id) DESC
    LIMIT
      1
    SQL
    ShortenedUrl.find_by_sql([query, id: id])
  end

  def self.most_popular_tags

    TagTopic.find_by_sql(<<-SQL)
    SELECT
      tag_topics.tag, shortened_urls.long_url
    FROM
      tag_topics
    LEFT OUTER JOIN
      taggings ON taggings.tag_topic_id = tag_topics.id
    LEFT OUTER JOIN
      shortened_urls ON taggings.url_id = shortened_urls.id
    LEFT OUTER JOIN
      visits ON visits.url_id = shortened_urls.id
    GROUP BY
      tag_topics.tag, shortened_urls.long_url
    HAVING
      MAX(COUNT(*))
    SQL
    # TagTopics.select(:tag.distinct, :urls.long_url).order_by(urls.num_clicks)
  end
end
