require 'spec_helper'

describe MoviesController do

  describe 'show a movie' do 
    it 'should call the movie method to load from db' do 
      Movie.should_receive(:find).with("1").and_return(
        mock(:id => 'test', :title => 'test'))
      get :show, { :id => "1" }
    end

    describe 'valid execution' do 
      before :each do 
        @movie = Movie.stub(:find).with("1").and_return(
          mock(:id => 'test', :title => 'test'))
        get :show, { :id => "1" }
      end 

      it 'should use show template for rendering' do             
        response.should render_template 'show'
      end 
      
      it 'should make a movie object available to the template' do 
        assigns(:movie) == @movie
      end 
    end 
  end 

  describe 'show input page' do 
    it 'should not call movie find method' do 
      Movie.should_not_receive(:find) 
      get :new 
    end 

    it 'should select new template for rendering' do 
      get :new 
      response.should render_template 'new'
    end 
  end 

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
        Movie.stub(:directed_by).and_return([])
        post :find_by_same_director, { :id => "1" } 
    end 

    it 'should redirect to home page if the movie has no director info' do
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => nil, :title => 'test'))
        post :find_by_same_director, { :id => "1" }
        response.should redirect_to movies_path
    end 

    it 'should redirect to home page if the movie has blank director info' do
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => "  ", :title => 'test'))
        post :find_by_same_director, { :id => "1" }
        response.should redirect_to movies_path
    end 

    it 'should has flash notice' do
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => "  ", :title => 'test'))
        post :find_by_same_director, { :id => "1" }
       flash[:notice].should =~ /'test' has no director info/i
    end 

    it 'should call the model method that find movies by director' do 
        Movie.stub(:find_by_id).with("1").and_return(
            mock('Movie', :id => 1, :director => 'test'))
        Movie.should_receive(:directed_by).with("test").and_return(
            [mock('Movie', :id => 1, :director => 'test')])
        post :find_by_same_director, { :id => "1" }
    end     
    
    describe 'after valid find' do
        before :each do 
            @fake_results = [mock('Movie', :id => 1, :director => 'test')]
            Movie.stub(:find_by_id).with("1").and_return(
                mock('Movie', :id => 1, :director => 'test'))
            Movie.stub(:directed_by).with("test").and_return(
                @fake_results)
            post :find_by_same_director, { :id => "1" }
        end 

        it 'should select index template for rendering with non-nil director info' do
            response.should render_template('index')
        end 
    
        it 'should make results available to the template' do 
            assigns(:movies).should == @fake_results
        end 

        it 'should make all_ratings available to the template when rendering with non-nil director' do 
            assigns(:all_ratings).should == Movie.all_ratings
        end 

        it 'should make selected_rating non-nil to the template' do 
            assigns(:selected_ratings).should_not nil
            assigns(:selected_ratings).should be_kind_of Hash
        end 
    end 
  end 
end