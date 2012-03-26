require 'spec_helper'

describe MoviesController do

  describe 'searching TMDb' do
    before :each do 
        @fake_results = [mock('Movie'), mock('Movie')]
    end 

    it 'should call the model method that performs TMDb search' do        
        Movie.should_receive(:find_in_tmdb).with("hardware").and_return(@fake_results)
        post :search_tmdb, { :search_terms => "hardware" }
    end

    describe 'after valid search' do 
        before :each do 
            Movie.stub(:find_in_tmdb).with("hardware").and_return(@fake_results)
            post :search_tmdb, { :search_terms => "hardware" }
        end 

        it 'should select the Search Results template for rendering' do
            response.should render_template('search_tmdb')
        end

        it 'should make the TMDb search results available to that template' do
            assigns(:movies).should == @fake_results
        end 
    end 
  end

  describe 'find with same director' do

    it 'should call the model method that find movie with id' do 
        Movie.should_receive(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => 'test'))
        Movie.stub(:directed_by_director).and_return([])
        post :find_by_same_director, { :id => "1" } 
    end 

    it 'should redirect to home page if the movie has no director info' do
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => nil, :title => 'test'))
        post :find_by_same_director, { :id => "1" }
        response.should redirect_to(:controller => 'movies', :action => 'index')
    end 

    it 'should call the model method that find movies by director' do 
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => 'test'))
        Movie.should_receive(:directed_by_director).with("test").and_return(
            [mock('Movie', :id => 1, :director => 'test')])
        post :find_by_same_director, { :id => "1" }
    end     

    it 'should select index template for rendering with non-nil director info' do
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => 'test'))
        Movie.should_receive(:directed_by_director).with("test").and_return(
            [mock('Movie', :id => 1, :director => 'test')])
        post :find_by_same_director, { :id => "1" }
        response.should render_template('index')
    end 
    
    it 'should make results available to the template' do 
        fake_results = [mock('Movie', :id => 1, :director => 'test')]
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => 'test'))
        Movie.should_receive(:directed_by_director).with("test").and_return(
            fake_results)
        post :find_by_same_director, { :id => "1" }
        assigns(:movies).should == fake_results
    end 

  end 

end