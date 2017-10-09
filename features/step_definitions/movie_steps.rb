# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^\"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these

When /^I have opted to sort movies alphabetically$/ do
    visit movies_path
    click_link 'title_header'
end

Then /^I should see the list of movies in alphabetical order$/ do
    total_count = 0
    page.all('table#movies tr/td[1]').each do |tr|
        first = tr.text
        inner_count = 0
        page.all('table#movies tr/td[1]').each do |tr_2|
            if (total_count < inner_count)
                second = tr_2.text
                expect(first < second).to be_truthy
            end
            inner_count += 1
        end
        total_count += 1
    end
end

When /^I have opted to sort movies in increasing order of release date$/ do
    visit movies_path
    click_link 'release_date_header'
end

Then /^I should see older movies before I see newer movies$/ do
    total_count = 0
    page.all('table#movies tr/td[3]').each do |tr|
        first = tr.text
        inner_count = 0
        page.all('table#movies tr/td[3]').each do |tr_2|
            if (total_count < inner_count)
                second = tr_2.text
                expect(first < second).to be_truthy
            end
            inner_count += 1
        end
        total_count += 1
    end
end
    
# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
      Movie.create(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
    visit movies_path
    ['G', 'PG', 'PG-13', 'NC-17', 'R'].each { |rating| uncheck( "ratings_#{rating}" ) }
    rating_list = arg1.split( /[\s,]+/ )
    rating_list.each { |rating| check( "ratings_#{rating}" ) }
    click_button 'ratings_submit'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    rating_list = arg1.split( /[\s,]+/ )
    page.all('table#movies tr/td[2]').each do |tr|
        expect(rating_list.include? tr.text).to be_truthy
    end
end

Then /^I should see all of the movies$/ do
    #add one to consider the title header
    page.all('table#movies tr').count.should == Movie.all.count + 1
end



