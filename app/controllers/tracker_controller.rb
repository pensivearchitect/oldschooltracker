class TrackerController < ApplicationController
  include TrackerHelper
  require 'open-uri'

  def index
    @namemappings = NameMappings.all
    @datapoints = DataPoint.all
  end

  def update
    @title = "Update " << params[:name]

    begin
      get_current_stats params[:name]

      @namemap = NameMappings.find_by_name(params[:name])
      if(@namemap == nil)
        @namemap = NameMappings.new(params.permit(:name))
        @namemap.save
      end

      @dp = DataPoint.new(:pid => @namemap.id, :time => Time.now.to_i, :xp => @xphex, :rank => @rankhex)
      @dp.save
    rescue OpenURI::HTTPError
      params[:name] = nil
    end
  end

  def track
    @time = (params[:time] == nil ? 86400 : params[:time].to_i)
    @skill = get_skill(params[:skill] == nil ? 0 : params[:skill].to_i)

    @namemap = NameMappings.find_by_name(params[:name])
    if(@namemap != nil)
      @datapoints = DataPoint.where(pid: @namemap.id).where(updated_at: (Time.now - @time)..Time.now)
    end
  end

  def nametopid
    @namemap = NameMappings.find_by_name(params[:name])
  end

  def pidtoname
    @namemap = NameMappings.find_by(params.permit(:pid))
  end

  def formatname
    @name = get_player_name params[:name]
    @test = get_skill_name(1)
  end
end
