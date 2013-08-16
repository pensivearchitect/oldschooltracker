class TrackerController < ApplicationController
  include TrackerHelper
  def index
    @namemappings = NameMappings.all
    @datapoints = DataPoint.all
  end

  def update
    @title = "Update " << params[:name]

    begin
      contents = open('http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=' << get_player_name(params[:name])) { |io| io.read }
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
    rescue OpenURI::HTTPError
      params[:name] = nil
    end

    if(params[:name] != nil)
      @namemap = NameMappings.find_by_name(params[:name])
      if(@namemap == nil)
        @namemap = NameMappings.new(params.permit(:name))
        @namemap.save
      end

      @dp = DataPoint.new(:pid => @namemap.id, :time => Time.now.to_i, :xp => @xphex, :rank => @rankhex)
      @dp.save
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
