class CDE::Event
    attr_accessor :presenter, :venue
    
    attr_reader :title, :date_time, :time, :genre, :link

    @@all = []

    #Events have:
        #title
        #presenter
        #date
        #time
        #genre
        #venue
        #link

    def initialize(title, presenter, date_time, time, genre, venue, link)
        @title = title
        @presenter = presenter
        @date_time = []
        @date_time << date_time
        @genre = genre
        @venue = venue
        @link = link
        @@all << self
    end

    def self.all
        @@all
    end

end

#97 as of 9/2