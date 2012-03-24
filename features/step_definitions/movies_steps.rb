#require './../../app/models/movie'
# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
#  assert false, "Unimplmemented"
  assert (page.body =~ /.*#{e1}.*#{e2}.*/m) != nil, "Wrong order"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  #p uncheck
  #p rating_list
  
  if uncheck == 'un'
    rating_list.split(',').each { |x| step %Q{I uncheck "ratings[#{x.strip}]"} }     
  else
    rating_list.split(',').each { |x| step %Q{I check "ratings[#{x.strip}]"} } 
  end
end

Then /I should see all of the movies/ do 
  Movie.all.length.should == 10 
end 

Then /I should see movies sorted alphabetically/ do
  pattern = ".*"
  all_movies = Movie.order(:title)  
  all_movies.each do |movie|
    pattern << "#{movie.title}.*"
  end
  assert page.body =~ Regexp.compile(pattern, Regexp::MULTILINE)
end

Then /I should see movies sorted in increasing order of release date/ do
  pattern = ".*"
  all_movies = Movie.order(:title)  
  all_movies.each do |movie|
    pattern << "#{movie.release_date}.*"
  end
  assert page.body =~ Regexp.compile(pattern, Regexp::MULTILINE)
end 
