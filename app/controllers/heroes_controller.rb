class HeroesController < ApplicationController
  def index
    @heroes = Hero.all
    @new_hero = Hero.new
    @events = Event.all

    #piechart data for comic
    @hero_chart_data_comic = []
    @heroes.each do |hero|
      data = []
      data[0] = hero.name
      data[1] = hero.comic_total.to_i

      @hero_chart_data_comic << data
    end

    #piechart data for series
    @hero_chart_data_series = []
    @heroes.each do |hero|
      data = []
      data[0] = hero.name
      data[1] = hero.series_total.to_i

      @hero_chart_data_series << data
    end

    #piechart helper for popularty by comic
    @piechart_comic = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
          series = {
                   :type=> 'pie',
                   :name=> 'Total Comics: ',
                   :data=> @hero_chart_data_comic
          }
          f.series(series)
          f.options[:title][:text] = "Hero Popularity by Comic"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
          f.plot_options(:pie=>{
            :allowPointSelect=>true,
            :cursor=>"pointer" ,
            :dataLabels=>{
              :enabled=>true,
              :color=>"black",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif"
              }
            }
          })
    end

    #piechart helper for popularity by series
    @piechart_series = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
          series = {
                   :type=> 'pie',
                   :name=> 'Total Series: ',
                   :data=> @hero_chart_data_series
          }
          f.series(series)
          f.options[:title][:text] = "Hero Popularity by Series"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
          f.plot_options(:pie=>{
            :allowPointSelect=>true,
            :cursor=>"pointer" ,
            :dataLabels=>{
              :enabled=>true,
              :color=>"black",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif"
              }
            }
          })
    end

  end

  def create
    hero_name = hero_search_params[:name].gsub(/ /,'%20')

    time = Time.now
    public_key = ENV['PUBLIC_KEY']
    private_key = ENV['PRIVATE_KEY']
    encoded_hash = "#{time}#{private_key}#{public_key}"
    md5 = Digest::MD5.new
    md5.update encoded_hash

    #obtaining response and relevant data
    response = HTTParty.get("http://gateway.marvel.com:80/v1/public/characters?name=#{hero_name}&orderBy=name&ts=#{time}&apikey=#{public_key}&hash=#{md5.hexdigest}")
    hero_data = response['data']['results']

    #checking to see if the search was valid
    if !hero_data.empty?
      @hero_results = hero_data[0]
      #if search was valid, create new hero object
      @new_hero = Hero.new
      @new_hero.name = @hero_results['name']
      @new_hero.description = @hero_results['description']
      @new_hero.comic_total = @hero_results['comics']['available']
      @new_hero.series_total = @hero_results['series']['available']
      @new_hero.story_total = @hero_results['stories']['available']
      @new_hero.event_total = @hero_results['events']['available']
      @new_hero.avatar_url = @hero_results['thumbnail']['path'] + '.' + @hero_results['thumbnail']['extension']

      #create new event object
      #checking to see if hero has already been added
      if @new_hero.save

        #if it doesnt exist in our database, it saves successfully

        #save the events associated with the hero. validations will check whether or not the event exists already.
        number_of_events = @hero_results['events']['items']

        number_of_events.each do |event|
          @new_event = Event.new
          @new_event.name = event['name']
          if @new_event.save
            #if the event doesn't exist, save it and pair it with the associating hero
            @new_heroes_event = Meeting.new
            @new_heroes_event.hero = @new_hero
            @new_heroes_event.event = @new_event
            @new_heroes_event.save
          else
            #if the event already exists, find the event of the same name and associate it with the hero.

            @new_heroes_event = Meeting.new
            @new_heroes_event.hero = @new_hero
            @new_heroes_event.event = Event.where(name: @new_event.name)[0]
            @new_heroes_event.save
          end
        end

        flash[:notice] = "#{@new_hero.name} has been added!"
        redirect_to root_path
      else

        #can't have duplicate heroes!
        flash[:notice] = "This hero has already been added to the list!"
        redirect_to root_path
      end
    else

      #invalid search response
      flash[:notice] = "I'm unable to find this hero :( Maybe check if you've entered the name correctly?"
      redirect_to root_path
    end
  end

  def show
    @hero = Hero.find(params[:id])
    @meetings = Meeting.where(hero: @hero)
  end

  private
  def hero_search_params
    params.require(:hero).permit(:name)
  end
end
