require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      fake_results = [double('movie1'), double('movie2')]
      allow(Movie).to receive(:find_in_tmdb).and_return fake_results
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end
    describe 'it should check if results are found' do
      context 'results found' do
        it 'should make the TMDb search results available to that template' do
          fake_results = [double('Movie'), double('Movie')]
          allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
          post :search_tmdb, {:search_terms => 'Ted'}
          expect(assigns(:movies)).to eq(fake_results)
        end
      end
      context 'no results found' do
        it 'should redirect to the movie index if no results are found' do
          post:search_tmdb, {:search_terms => 'batman ted'}
          expect(response).to redirect_to movies_path
        end
      end
    end
    it 'should redirect to movies index if search terms are invalid' do
      post :search_tmdb, {:search_terms => ''}
      expect(response).to redirect_to movies_path
    end
  end
  
  describe 'adding selected movie to rotten potatoes' do
    context 'no movies selected' do
      it 'should redirect to movies index' do
        post :add_tmdb, {:tmdb_movies => ''}
        expect(response).to redirect_to movies_path
      end
    end
    context 'movies selected' do
      it 'should redirect to movies index' do
        post :add_tmdb, {:tmdb_movies => {'941' => 1}}
        expect(response).to redirect_to movies_path
      end
    end
  end
end
