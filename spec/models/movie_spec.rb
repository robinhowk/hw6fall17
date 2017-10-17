require 'spec_helper'
require 'rails_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      it 'should return an array if movies are found' do
        expect(Movie.find_in_tmdb('batman').empty?).to be_falsy
      end
      it 'should return an empty array if no movies are found' do
        expect(Movie.find_in_tmdb('batman ted').empty?).to be_truthy
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  
  describe 'adding movie' do
    context 'with valid key' do
      it 'should create a new movie' do
        fake_movie = double('Movie')
        allow(Movie).to receive(:create_from_tmdb).and_return fake_movie
        expect(Movie.create_from_tmdb('941')).to eq(fake_movie)
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:create_from_tmdb).and_raise(Tmdb::InvalidApiKeyError)
        expect{Movie.create_from_tmdb('941')}.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
end
