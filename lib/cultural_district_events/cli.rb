#CLI Controller
class CDE::CLI
    attr_accessor :current_user

    def call 
        CDE::Scraper.new.make_events
        welcome
        view_type_selection
        goodbye
    end 

    def recall
        welcome
        view_type_selection
        goodbye
    end 

    def welcome
        system("clear")
        puts ""
        puts "----------------------------------------------------------------------------------------------"
        puts "WELCOME TO THE PITTSBURGH CULTURAL DISTRICT EVENT BROWSER!".center(100)
        puts "----------------------------------------------------------------------------------------------"
        user_login
    end 

    def user_login
        puts ""
        puts 'Please login to continue...'
        puts "Username: "
        username = gets.strip
        if username == "TERMINATE!"
            abort
        end
        puts "Password:"
        password = gets.strip
        @current_user = CDE::User.create_or_find_by_username_and_password(username, password)
    end

    def view_type_selection
        puts ""
        puts "Enter the number for how you would like to browse Cultural District events:"
        puts "1. Events by Presenter"
        puts "2. Events by Venue"
        puts "3. All Cultural District Events"
        puts "4. Browse History"
        puts ""
        puts '(enter "log out" at any time to log out of the Cultural District Events browser)'
        input = nil   
           
        while input != "log out"
        input = gets.strip.downcase

            if input.to_i == 1
                by_presenter
            elsif input.to_i == 2
                by_venue
            elsif input.to_i == 3
                event_list
            elsif input.to_i == 4
                user_search_history
            elsif input == "log out"
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
        while input != "log out"
        input = gets.strip.downcase
            if input == "log out"
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
        if input == "log out"
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
        while input != "log out"
            
            input = gets.strip.downcase
            
            if input.to_i > 0 && input.to_i <= events_array.count
                chosen_event = events_array[input.to_i-1]
                add_to_current_user_search_history(chosen_event)
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
                puts 'Enter "home" to browse more events.'
            elsif input == "home"
                view_type_selection
            elsif input == "log out"
                goodbye
            end
            
        end
    end

    def add_to_current_user_search_history(chosen_event)
        @current_user.search_history << chosen_event unless @current_user.search_history.include? chosen_event
    end


    def search_history_menu(events_array)
        if @current_user.search_history.count == 0
            puts "Sorry you have no browse history!"
            view_type_selection
        else
            puts 'Enter the number for the event you would like to learn more about or type "home" to browse more events.'
        input = nil
        while input != "log out"
            
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
                puts 'Enter "home" to browse more events or type "back" to go back to your browse history'
            elsif input == "home"
                view_type_selection
            elsif input == "log out"
                goodbye
            elsif input == "back"
                user_search_history
            end
            
        end
    end
    end
    
    def user_search_history
        puts "----------------------------------------------------------------------------------------------"
        puts "#{current_user.username.upcase} Browse History".center(100)
        puts "----------------------------------------------------------------------------------------------"
        @current_user.search_history.each.with_index(1) do |event, i|
            puts "#{i}. #{event.title}"
        end
        search_history_menu(@current_user.search_history)
    end

    def goodbye
        system("clear")
        recall
    end    
end