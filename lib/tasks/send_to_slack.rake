class QuoteSourceException < StandardError
end

class SlackNotifierException < StandardError 
end

namespace :postto do 
	desc "This task will post an inspirational quote to a specified slack group"

	task :slackgroup => :environment do 
		begin 
	  	response = HTTParty.get("#{ENV['QUOTE_SRC']}")
	  	@quote =  response['contents']['quotes'][0]['quote']
	  	@author = response['contents']['quotes'][0]['author']
  	rescue Exception => e
  		raise QuoteSourceException
  		logger.fatal "QuoteSourceException #{e}"
  	end
  	begin
  	notifier = Slack::Notifier.new "#{ENV['WEBHOOK_URL']}", channel: "#quote-of-the-day",
                                              username: "#{ENV['BOT_NAME']}"
  	notifier.ping "#{@quote}\nAuthor - #{@author}"
  	rescue => e 
  		raise SlackNotifierException 
  		logger.fatal "SlackNotifierException #{e}"
  	end
	end
end
