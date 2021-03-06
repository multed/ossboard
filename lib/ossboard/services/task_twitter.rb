module Services
  class TaskTwitter
    include Import[:twitter, 'services.url_shortener']

    def call(task)
      tweet text(task)
    end

    private

    def link_to_task(task_id)
      url_shortener.call("http://www.ossboard.org/tasks/#{task_id}")
    end

    def text(task)
      tag_and_link = "#ossboard #{link_to_task(task.id)}"
      length_left = TWEET_MAX_LENGTH - tag_and_link.size
      title = task.title
      title = "#{title[0..length_left]}..." if title.size > length_left
      "#{title} #{tag_and_link}"
    end

    def tweet(text)
      return text unless Hanami.env?(:production)
      twitter.update(text)
    end

    # Keep extra 5 symbols for spaces and ...
    # TODO: update length to 200
    TWEET_MAX_LENGTH = 135
  end
end
