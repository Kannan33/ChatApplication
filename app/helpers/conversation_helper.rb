module ConversationHelper
  def find_date_and_time(time)
    create_at = time.to_date
    date_with_time = String.new
    if create_at.eql? Date.today
      date_with_time = "Today"+" | "+time.strftime('%H:%M')
    elsif create_at.eql? Date.yesterday
      date_with_time = "Yesterday"+" | "+time.strftime('%H:%M')
    else
      date_with_time = time.strftime("%d-%m-%y - %H:%M")
    end
    date_with_time
  end
end