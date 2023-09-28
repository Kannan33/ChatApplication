module ConversationHelper
  # get date and time of created message
  def find_date_and_time(time)
    create_at = time.to_date
    date_with_time = String.new
    if create_at.eql? Date.today
      date_with_time = "Today"+" | "+time.strftime('%I:%M:%p')
    elsif create_at.eql? Date.yesterday
      date_with_time = "Yesterday"+" | "+time.strftime('%I:%M:%p')
    else
      date_with_time = time.strftime("%d-%m-%y - %I:%M:%p")
    end
    date_with_time
  end
end