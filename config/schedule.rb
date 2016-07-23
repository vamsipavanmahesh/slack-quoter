every 1.day, :at => '11:00 am' do 
	rake "postto:slackgroup", :environment => "development"
end