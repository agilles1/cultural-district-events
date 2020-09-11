#CLI Controller
class CDE::CLI

    def call 
        CDE::Scraper.new.make_events
        welcome
        view_type_selection
        goodbye
    end 

    def welcome
        puts ""
        puts "----------------------------------------------------------------------------------------------"
        puts "WELCOME TO THE CULTURAL DISTRICT EVENT BROWSER!".center(100)
        puts "----------------------------------------------------------------------------------------------"
        
        
    end 

    def view_type_selection
        puts ""
        puts "Enter the number for how you would like to browse Cultural District events:"
        puts "1. Events by Presenter"
        puts "2. Events by Venue"
        puts "3. All Cultural District Events"
        puts ""
        puts '(enter "exit" at any time to exit the Cultural District Events browser)'
        input = nil   
           
        while input != "exit"
        input = gets.strip.downcase

            if input.to_i == 1
                by_presenter
            elsif input.to_i == 2
                by_venue
            elsif input.to_i == 3
                event_list
            elsif input == "exit"
                goodbye
            end

        end
    end

    def by_presenter
        puts ""
        puts "----------------------------------------------------------------------------------------------"
        puts "Presenters".center(100)
        puts "----------------------------------------------------------------------------------------------"
        CDE::Presenter.all.each.with_index(1) do |presenter, i|
            puts "#{i}. #{presenter.name}"
        end
        puts "----------------------------------------------------------------------------------------------"
        puts "Enter the number for the Presenter who's events you would like to see:"

        input = nil
        while input != "exit"
        input = gets.strip.downcase
            if input == "exit"
                goodbye  
            elsif input.to_i > 0 && input.to_i <= CDE::Presenter.all.count
                presenter = CDE::Presenter.all[input.to_i-1]
                presenter_name = presenter.name
                print_event_list_by_presenter(presenter_name)
            end
        end
    end

    def by_venue
        puts "----------------------------------------------------------------------------------------------"
        puts "Venues".center(100)
        puts "----------------------------------------------------------------------------------------------"
        CDE::Venue.all.each.with_index(1) do |venue, i|
            puts "#{i}. #{venue.name}"
        end   
        puts "----------------------------------------------------------------------------------------------"
        puts "Enter the number for the Venue who's events you would like to see:"

        input = nil

        input = gets.strip.downcase
        if input == "exit"
            goodbye   
        elsif input.to_i > 0 && input.to_i <= CDE::Venue.all.count
        venue = CDE::Venue.all[input.to_i-1]
        venue_name = venue.name
        print_event_list_by_venue(venue_name)
        end
    end

    def event_list
        CDE::Event.all.each.with_index(1) do |event, i|
            puts "#{i}. #{event.title}"
        end
        menu(CDE::Event.all)
    end

    def print_event_list_by_presenter(presenter_name) #maybe remove CANCELLED events later?
        presenter_events = CDE::Event.all.find_all{|event| event.presenter.name == presenter_name}
        puts "----------------------------------------------------------------------------------------------"
        puts presenter_name.center(100)
        puts "----------------------------------------------------------------------------------------------"
        presenter_events.each.with_index(1) do |event, i|
            puts "#{i}. #{event.title}"
        end
        menu(presenter_events)
    end

    def print_event_list_by_venue(venue_name) 
        venue_events = CDE::Event.all.find_all{|event| event.venue.name == venue_name}
        puts "----------------------------------------------------------------------------------------------"
        puts venue_name.center(100)
        puts "----------------------------------------------------------------------------------------------"      
        venue_events.each.with_index(1) do |event, i|
            puts "#{i}. #{event.title}"
        end
        menu(venue_events)
    end

    def menu(events_array)
        puts "----------------------------------------------------------------------------------------------"
        puts "Enter the number for the event you would like to learn more about:"
        input = nil
        while input != "exit"
            
            input = gets.strip.downcase
            
            if input.to_i > 0 && input.to_i <= events_array.count
                chosen_event = events_array[input.to_i-1] 
                puts "----------------------------------------------------------------------------------------------"
                puts ""
                puts "#{chosen_event.title}".center(100)
                puts "presented by #{chosen_event.presenter.name} at #{chosen_event.venue.name}".center(100)
                puts ""
                puts "----------------------------------------------------------------------------------------------"
                puts ""
                puts "Performance(s):"
                chosen_event.date_time.each {|dt| puts dt + "\n"}
                puts ""
                puts "Genre: #{chosen_event.genre}"
                puts ""
                puts "For ticketing and additional details visit:" 
                puts chosen_event.link
                puts ""
                puts "----------------------------------------------------------------------------------------------"
                puts 'Enter "home" to start a new search or "exit" to leave the Cultural District Event Browser!'
            elsif input == "home"
                view_type_selection
            elsif input == "exit"
                goodbye
            end
            
        end
    end

    def goodbye
        puts "See you next time!"
        abort
    end    
end