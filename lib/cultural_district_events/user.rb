class CDE::User   
attr_accessor :username, :password, :search_history
@@users = []
#Users have:
    #username
    #password
    #search history

def initialize(username, password)
    @username = username
    @password = password
    @search_history = []
    @@users << self
end

def user_search_history
    self.search_history #array
end

def self.all
    @@users
end

def self.create_or_find_by_username_and_password(username, password)
    if @@users.find {|user| user.username == username && user.password == password}
        @@users.find {|user| user.username == username && user.password == password}
    else
        self.new(username, password)
    end
end




end