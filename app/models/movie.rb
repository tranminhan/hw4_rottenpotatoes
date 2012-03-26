class Movie < ActiveRecord::Base
    
    class Movie::InvalidKeyError < StandardError ; end

    def self.api_key
        'cc4b67c52acb514bdf4931f7cedfd12b' # replace with YOUR Tmdb key
    end 

    def self.all_ratings
        %w(G PG PG-13 NC-17 R)
    end

    def self.find_in_tmdb(string) 
        Tmdb.api_key = self.api_key
        begin 
            TmdbMovie.find(:title => string)        
        rescue ArgumentError => tmdb_error
            raise Movie::InvalidKeyError, tmdb_error.message 
        rescue RuntimeError => tmdb_error     
            if tmdb_error.message =~ /status code '404'/
                raise Movie::InvalidKeyError, tmdb_error.message 
            else
                raise RuntimeError, tmdb_error.message
            end
        end  
    end

    def self.find_by_same_director(id)
        movie = Movie.find_by_id(id)
        if movie.nil?
            []  
        else 
            Movie.find_all_by_director(movie.director)
        end         
    end 
end
