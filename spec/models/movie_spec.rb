# spec/models/movie_spec.rb:
require 'spec_helper'

describe Movie do
    describe 'search Tmdb by keyword' do
        it 'should call Tmdb with title keywords given valid API key' do
            TmdbMovie.should_receive(:find).with(hash_including :title => 'Inception')
            Movie.find_in_tmdb('Inception')
        end 

        it 'should raise an InvalidKeyError with no API key' do
            Movie.stub(:api_key).and_return('')
            lambda { Movie.find_in_tmdb('Inception') }.
            should raise_error(Movie::InvalidKeyError)
        end 
    end 

    describe 'find by similar director' do 
        it 'should call the movie find director method' do 
            movie = Movie.create( { :title => 'test' } )
            Movie.should_receive(:find_by_director).exactly(1).times
            Movie.find_by_same_director(movie.id)
        end 

        it 'should return empty array for id = -1' do 
            Movie.find_by_same_director(-1).should == []
        end 
    end 
end