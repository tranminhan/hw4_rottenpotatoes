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

    it 'should call the model method that find movies with same director' do 
        Movie.should_receive(:find_by_same_director).with("1")
        post :find_by_same_director, { :id => "1" }
    end 

    it 'should select index templte for rendering' do
        Movie.stub(:find_by_same_director).with("1")
        post :find_by_same_director, { :id => "1" }
        response.should render_template('index')
    end 

    it 'should make search results available to that templte' do 
        @fake_results = [mock('Movie')]
        Movie.stub(:find_by_same_director).with("1").and_return(@fake_results)
        post :find_by_same_director, { :id => "1" }
        assigns(:movies).should == @fake_results
    end 
  end 

end