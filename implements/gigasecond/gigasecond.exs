defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @gigadt round(1.0e9)
  @day_seconds (24 * 60 * 60)
  @hour_seconds (60 * 60)
  @min_seconds 60
  @spec from({{pos_integer, pos_integer, pos_integer},
              {pos_integer, pos_integer, pos_integer}
             }) :: :calendar.datetime()

  #def from({{year, month, day}, {hours, minutes, seconds}}) do
  def from({date, {hours, minutes, seconds}}) do
    days = :calendar.date_to_gregorian_days(date)
    total_seconds = days    * @day_seconds  + 
                    hours   * @hour_seconds + 
                    minutes * @min_seconds  + seconds
    #IO.puts "seconds:#{total_seconds}"
    target_seconds = total_seconds + @gigadt 
    
    sec = rem(target_seconds, 60)
    min = rem(target_seconds = div(target_seconds, 60), 60)
    hour= rem(target_seconds = div(target_seconds, 60), 24)
    days = div(target_seconds, 24) 
    time2 = {hour, min, sec}
    date2 = :calendar.gregorian_days_to_date(days)
    #IO.puts ":#{inspect rst},#{inspect time2}"
    { date2, time2}
    #seconds = :calendar.datetime_to_gregorian_seconds({date, time}) 
    #:calendar.gregorian_seconds_to_datetime(seconds + @gigadt)
    #|> IO.inspect
  end
end
