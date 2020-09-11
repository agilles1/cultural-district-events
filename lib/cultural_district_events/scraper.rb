
class CDE::Scraper
  attr_reader :page

  def get_page
   Nokogiri::XML(open("https://culturaldistrict.org/feed?format=rss"))
  end

  def productions
    self.get_page.css("item") 
  end

  def make_events
    self.productions.each do |event| 
      if CDE::Event.all.any? do |e| #this the event already exists, just add date_time
        if e.title == event.css("title")[0].text.strip
          e.date_time << event.css("datetime").text.strip
        end
      end
      else
        create_from_scraper(event)
      end
    end
  end

 
  def add_presenter(event)
      presenter = event.css("presenter").text.strip
      if presenter == ""
        CDE::Presenter.all.find {|p| p.name == "Pittsburgh Cultural Trust"}
      elsif CDE::Presenter.all.any? {|p| p.name == presenter}
        CDE::Presenter.all.find {|p| p.name == presenter}
      else
        CDE::Presenter.new(presenter) 
      end
  end

  def add_venue(event)
    venue = event.css("venue").text.strip
    if CDE::Venue.all.any? {|v| v.name == venue}
        CDE::Venue.all.find {|v| v.name == venue}
      else
        CDE::Venue.new(venue) 
      end
  end
 

  def create_from_scraper(event)   
       CDE::Event.new(
        event.css("title")[0].text.strip,
        add_presenter(event),
        event.css("datetime").text.strip,
        event.css("time").text.strip,
        event.css("genre").text.strip,
        add_venue(event),
        event.css("link")[1].text.strip)
  end

end