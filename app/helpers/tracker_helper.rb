module TrackerHelper
  def get_skill_name i
    return @@skills[i]
  end

  def get_skill unsafe_id
    skill = unsafe_id.to_i
    if(-1 < skill && skill < 24)
      return skill
    else
      return 0
    end
  end

  def pluralize( count, unit )
    return count.to_s << " " << unit << (count == 1 ? "" : "s")
  end

  def items_in_series( item_array )
    ret = ""
    item_array.each_with_index do |item, i|
      ret << item << (item_array.length - 1 == i ? "" : ", ") << (item_array.length - 2 == i ? "and " : "")
    end
    return ret
  end

  def get_current_stats player_name
      contents = open('http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=' << NameMappings.get_player_name(player_name)) { |io| io.read }
      @xp = Array.new(24)
      @ranks = Array.new(24)
      skillarr = contents.split /\r?\n/

      @xphex = ""
      @rankhex = ""

      0.upto 23 do |i|
        skillarr[i] = skillarr[i].split(',')
        @ranks[i] = skillarr[i][0].to_i
        @xp[i] = skillarr[i][2].to_i
        @xphex << @xp[i].to_s(16).rjust(8, '0')
        @rankhex << @ranks[i].to_s(16).rjust(8, '0')
      end
  end


  @@skills = [
    "Overall","Attack","Defence","Strength","Hitpoints",
    "Ranged","Prayer","Magic","Cooking","Woodcutting",
    "Fletching","Fishing","Firemaking","Crafting","Smithing",
    "Mining","Herblore","Agility","Thieving","Slayer",
    "Farming","Runecrafting","Hunter","Construction"
  ]

  @@time_units = [
      [31536000, 2678400, 604800, 86400, 3600, 60, 1],
      %w(y M w d h m s),
      %w(year month week day hour minute second)
    ]

  @@time_seconds = 0
  @@time_symbols = 1
  @@time_names = 2

  def time_to_short_string( time )
    if(time == 0)
      return "0s"
    end
    
    ret = ""
    for i in (3...7)
      count = time / @@time_units[@@time_seconds][i]
      if(count > 0)
        ret << count.to_s << @@time_units[@@time_symbols][i]
      end 
      time %= @@time_units[@@time_seconds][i]
    end
    return ret
  end

  def time_to_string( time )
    if(time == 0)
      return "0s"
    end
    
    time_counts = Array.new(4)
    non_zeo_count = 0
    
    for i in (3...7)
      count = time / @@time_units[@@time_seconds][i]
      if(count > 0)
        non_zeo_count += 1
        time_counts[i-3] = pluralize( count, @@time_units[@@time_names][i] )
      end
      time %=  @@time_units[@@time_seconds][i]
    end
    time_counts.compact!
    return items_in_series( time_counts )
  end

  def short_string_to_time( short_time_string )
    ret = 0
    current_number = ""
    for i in (0...short_time_string.length)
      if(is_numeric_char(short_time_string[i]))
        current_number << short_time_string[i]
      else
        for k in (0...7)
          if(short_time_string[i] == @@time_units[@@time_symbols][k])
            ret += @@time_units[@@time_seconds][k] * current_number.to_i
            current_number = ""
          end
        end
      end
    end
    ret += current_number.to_i
    return ret
  end

  def get_icon_url( skill )
      return "ico/" + (skill).to_s + ".gif"
  end

  def track_path( name, skill, time )
    return ('/tracker/track/' << name << '/' << skill.to_s << '/' << time.to_s)
  end
end
