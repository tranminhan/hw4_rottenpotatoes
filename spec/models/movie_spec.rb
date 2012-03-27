# spec/models/movie_spec.rb:
require 'spec_helper'

describe Movie do

    describe 'all ratings' do
        it 'should return [G PG PG-13 NC-17 R]' do
            Movie.all_ratings.should == %w(G PG PG-13 NC-17 R)
        end 
    end

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

        it 'should raise an InvalidKeyError when INVALID key' do
            Movie.stub(:api_key).and_return('INVALID')
            lambda { Movie.find_in_tmdb('Inception') }.
                should raise_error(Movie::InvalidKeyError)
        end 

        it 'should raise an InvalidKeyError when tmdb throws RuntimeError and 404 status code' do
            TmdbMovie.stub(:find).and_raise(RuntimeError.new("status code '404'"))
            lambda { Movie.find_in_tmdb('Inception') }.
                should raise_error(Movie::InvalidKeyError)
        end 

        it 'should raise an RuntimeError when tmdb throws RuntimeError and a message different from 404 status code' do
            TmdbMovie.stub(:find).and_raise(RuntimeError.new("someting went wrong"))
            lambda { Movie.find_in_tmdb('Inception') }.
                should raise_error(RuntimeError)
        end 
    end 

    describe 'find by director' do 
        it 'should call the movie find director method' do 
            director = 'director'
            Movie.create( { :title => 'test', :director => director } )            
            Movie.should_receive(:find_all_by_director).with(director).exactly(1).times
            Movie.directed_by(director)
        end 

        it 'should return empty array for director = INVALID' do 
            Movie.directed_by(-1).should == Array.new
        end 

        it 'should return an non-empty array with valid input' do
            movies = [  Movie.create( { :title => 'test', 
                                    :director => 'test' } ) ,
                        Movie.create( { :title => 'test 2', 
                                    :director => 'test' } )  ]          
            Movie.directed_by('test').should == movies
        end 
    end 
end