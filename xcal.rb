#!/usr/bin/env ruby

require 'time'
require 'date'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'optparse'

Event = Struct.new(:name, :start_date_time, :end_date_time) do
  def active_during_date_time?(d)
    d >= start_date_time && d < end_date_time
  end
end

THEMES = {
  ascii: {rh: '-', rv: '|', bh: '-', bv: '|', bbbb: '+', bbrb: '+', brbb: '+', rrrr: '+', busy: 'X'},
  lines: {rh: '─', rv: '│', bh: '━', bv: '┃', bbbb: '╋', bbrb: '╇', brbb: '╉', rrrr: '┼', busy: '▓'},
  courier: {rh: '═', rv: '║', bh: '═', bv: '║', bbbb: '╬', bbrb: '╬', brbb: '╬', rrrr: '╬', busy: '▓'},
  courier_x: {rh: '═', rv: '║', bh: '═', bv: '║', bbbb: '╬', bbrb: '╬', brbb: '╬', rrrr: '╬', busy: 'X'}
}

DEFAULT_THEME = :courier_x

def parse_time(s)
  if s =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
    if s.to_i < 13 then s += 'am'
    else s += 'pm' end
  end

  Time.parse s
end

def parse_date(s)
  /\A(?<day>\d{1,2})[\.\/](?<month>\d{1,2})([\.\/](?<year>\d{1,4}))?[\.\/]?\z/ =~ s
  year = Date.today.year if year.blank?
  year = year.to_i; month = month.to_i; day = day.to_i
  if year < 94 then year += 2000 end
  Date.new(year, month, day)
end

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: xcal [options] [startdate [enddate]]'

  opts.on('-bTIME', '--begin-time=TIME', 'Time day starts at, default: 08:00') do |time|
    options[:day_start_time] = parse_time(time)
  end

  opts.on('-eTIME', '--end-time=TIME', 'Time day ends at, default: 19:59') do |time|
    options[:day_end_time] = parse_time(time)
  end

  opts.on('-sMINUTES', '--step-size=MINUTES', 'Step size that time proceeds with, default: 60') do |min|
    options[:day_hour_step] = min.to_f/60.0
  end

  opts.on('-wCHARS', '--day-width=CHARS', 'Width of one day in characters, default: 6') do |c|
    options[:day_width] = c.to_i
  end

  opts.on('-tTHEMENAME', '--theme=THEMENAME', "Available themes: #{THEMES.keys.map(&:to_s).join(', ')}; default: #{DEFAULT_THEME}") do |s|
    options[:theme] = s.to_sym
  end

  opts.on('-d', '--hide-weekday', 'Hide name of weekday, default: off') do |b|
    options[:hide_weekday] = b
  end

  opts.on('-n', '--show-event-name', 'Prints the name of each event, default: off') do |b|
    options[:show_event_name] = b
  end

  opts.on_tail('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

# Set default options
options[:day_start_time] ||= Time.parse('08:00')
options[:day_end_time] ||= Time.parse('19:59')
options[:day_hour_step] ||= 1.0
options[:day_width] ||= 6
options[:theme] ||= DEFAULT_THEME
options[:hide_weekday] ||= false
options[:show_event_name] ||= false

ARGV.map! do |s|
  if s =~ /\A\d{1,2}\.\d{1,2}\.\z/
    s += Date.today.year.to_s
  end
  s
end

p_start_date, p_end_date = nil
case ARGV.size
  when 0 then
    p_start_date = Date.today - Date.today.wday + 1 # last Monday
    p_end_date = p_start_date.next_day(6)
  when 1
    p_start_date = parse_date(ARGV[0])
    p_end_date = p_start_date.next_day(6)
  else
    p_start_date = parse_date(ARGV[0])
    p_end_date = parse_date(ARGV[1])
end

# Aggregate days
days = []
cur_date = p_start_date
while cur_date <= p_end_date do
  days << cur_date
  cur_date = cur_date.next_day
end

# Aggregate time slots
time_slots = []
cur_time = options[:day_start_time]
while cur_time <= options[:day_end_time] do
  time_slots << cur_time
  cur_time += options[:day_hour_step] * 60 * 60
end

events_text = `icalbuddy -b "* " -nrd -df "%m/%d/%y" -eep "location, url, notes, attendees" -ec "Holidays in Germany, US Holidays, Birthdays" eventsFrom:#{p_start_date.month}/#{p_start_date.day}/#{p_start_date.year} to:#{p_end_date.month}/#{p_end_date.day}/#{p_end_date.year}`
events_text = events_text.split(/^\*/).map { |s| s.strip.presence }.compact

events = events_text.map do |s|
  /\A(?<m_name>.*$)\n\s*(?<m_start_date>\d{2}\/\d{2}\/\d{2})( at )?(?<m_start_time>\d{2}:\d{2})?( - )?(?<m_end_date>\d{2}\/\d{2}\/\d{2})?( at )?(?<m_end_time>\d{2}:\d{2})?\z/ =~ s

  next if m_start_date.blank?

  start_date_time = if m_start_time.present? then
    DateTime.strptime("#{m_start_date} #{m_start_time}", '%m/%d/%y %H:%M')
  else
    DateTime.strptime(m_start_date, '%m/%d/%y')
  end

  end_date_time = if m_end_date.present? && m_end_time.present? then
    DateTime.strptime("#{m_end_date} #{m_end_time}", '%m/%d/%y %H:%M')
  elsif m_end_date.present? && !m_end_time.present?
    DateTime.strptime("#{m_end_date} 23:59", '%m/%d/%y %H:%M')
  elsif !m_end_date.present? && m_end_time.present?
    DateTime.strptime("#{m_start_date} #{m_end_time}", '%m/%d/%y %H:%M')
  else
    start_date_time.next_day - 1.0/(24*60*60)
  end

  Event.new(m_name, start_date_time, end_date_time)
end.compact

# Generate calendar
cal = []
days.each do |d|
  cal_day = []
  time_slots.each do |t|
    dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
    event_index = events.find_index { |e| e.active_during_date_time? dt }
    busy = event_index.present?

    cal_day << [busy, event_index]
  end

  cal << cal_day
end

# Print calendar
thm = THEMES[options[:theme]]

weekday_row = '      ' + days.map { |d| "#{thm[:bv]}#{(d.strftime('%a')).center(options[:day_width])}" }.join + "\n"
date_row = '      ' + days.map { |d|
  day_str = d.strftime('%-d.%-m.')
  day_str = " #{day_str}" if day_str.size == 5
  "#{thm[:bv]}#{day_str.center(options[:day_width])}"
}.join + "\n"

top_line = (thm[:bh] * 6) + thm[:bbbb] + (thm[:bh] * options[:day_width]) +
               days[1..-1].map { |d| "#{thm[:bbrb]}#{''.ljust(options[:day_width], thm[:bh])}"}.join + "\n"
line = (thm[:bh] * 6) + thm[:brbb] + (thm[:rh] * options[:day_width]) +
           days[1..-1].map { |d| "#{thm[:rrrr]}#{''.ljust(options[:day_width], thm[:rh])}"}.join + "\n"

print weekday_row unless options[:hide_weekday]
print date_row
print top_line

for i_time_slot in 0...time_slots.size do
  print "#{time_slots[i_time_slot].strftime('%H:%M')} #{thm[:bv]}"
  for i_day in 0...days.size do
    print thm[:rv] unless i_day == 0

    # Check if busy
    if cal[i_day][i_time_slot][0]
      if options[:show_event_name]
        event = events[cal[i_day][i_time_slot][1]]
        last_event_row = cal[i_day][i_time_slot][1] != cal[i_day][i_time_slot + 1].try(:[], 1)
        event_name = event.name.slice!(0...options[:day_width]).ljust(options[:day_width], thm[:busy])
        event_name[-1] = thm[:busy][0] if last_event_row
        print event_name
      else
        print ''.ljust(options[:day_width], thm[:busy])
      end

    else
      print ' ' * options[:day_width]
    end
  end
  print "\n"

  print line if ((i_time_slot + 1) % 4 == 0) && i_time_slot != time_slots.size - 1
end
