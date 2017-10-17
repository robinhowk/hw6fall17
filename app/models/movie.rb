class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    require 'themoviedb'
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    
    begin
      results_list = []
      search_results = Tmdb::Movie.find(string)
      if !search_results.nil?
        search_results.each do |result|
          movie_hash = Hash.new
          results_releases = Tmdb::Movie.releases(result.id)['countries']
          results_releases.each do |release|
            if release['iso_3166_1'] == "US"
              movie_hash[:release_date] = release['release_date']
              movie_hash[:rating] = release['certification']
            end
          end
          movie_hash[:title] = result.title
          movie_hash[:tmdb_id] = result.id
          results_list.push(movie_hash)
        end
      end
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
    results_list
  end
  
  def self.create_from_tmdb(tmdb_id)
    require 'themoviedb'
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    details = Tmdb::Movie.detail(tmdb_id)
    new_movie = Hash.new
    new_movie[:title] = details['title']
    releases = Tmdb::Movie.releases(tmdb_id)['countries']
    releases.each do |release|
      if release['iso_3166_1'] == "US"
        new_movie[:release_date] = release['release_date']
        new_movie[:rating] = release['certification']
      end
    end
    
    Movie.create!(new_movie)
    
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
  end
  
end
