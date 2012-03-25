class Movie < ActiveRecord::Base
    
    class Movie::InvalidKeyError < StandardError ; end

    def self.api_key
        ''
    end 

    def self.all_ratings
        %w(G PG PG-13 NC-17 R)
    end

    def self.find_in_tmdb(string) 
        begin 
            TmdbMovie.find(:title => string)        
        rescue ArgumentError => tmdb_error
            raise Movie::InvalidKeyError, tmdb_error.message 
        end  
    end
end
