# coding: utf-8
module ActionView
  module Helpers
    module DateHelper
      def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
        from_time = from_time.to_time if from_time.respond_to?(:to_time)
        to_time = to_time.to_time if to_time.respond_to?(:to_time)
        distance_in_minutes = (((to_time - from_time).abs)/60).round
        distance_in_seconds = ((to_time - from_time).abs).round

        case distance_in_minutes
        when 0..1
          return (distance_in_minutes == 0) ? 'меньше минуты' : '1 минута' unless include_seconds
          case distance_in_seconds
          when 0..4   then 'меньше 5 секунд'
          when 5..9   then 'меньше 10 секунд'
          when 10..19 then 'меньше 20 секунд'
          when 20..39 then 'пол минуты'
          when 40..59 then 'меньше минуты'
          else             '1 минута'
          end

        when 2..44           then "#{distance_in_minutes} минут"
        when 45..89          then 'около 1 часа'
        when 90..1439        then "около #{(distance_in_minutes.to_f / 60.0).round} часов"
        when 1440..2879      then '1 день'
        when 2880..43199     then "#{(distance_in_minutes / 1440).round} дней"
        when 43200..86399    then 'около 1 месяца'
        when 86400..525599   then "#{(distance_in_minutes / 43200).round} месяцев"
        when 525600..1051199 then 'около 1 года'
        else                      "больше #{(distance_in_minutes / 525600).round} лет"
        end
      end
    end
  end
end