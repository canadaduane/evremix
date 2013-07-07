require 'selenium-webdriver'

def set_text(driver, input_name, text)
  element = driver.find_element(:name => input_name)
  element.clear
  element.send_keys text
end

def ngram_query driver, query
  driver.navigate.to "http://books.google.com/ngrams/"
  set_text driver, 'content', query
  set_text driver, 'year_start', '1500'
  set_text driver, 'year_end', '1830'

  option = Selenium::WebDriver::Support::Select.new(driver.find_element(:name => "smoothing"))
  option.select_by(:text, "0")

  button = driver.find_element(:css => '.query_submit_line > input:nth-child(1)')
  button.click

  sleep 1
end

def suggested_book_searches(driver)
  driver.find_elements(:css => "#container > blockquote a").select do |a|
    a.text =~ /^\d+$/
  end.map do |a|
    a.attribute("href")
  end
end

driver = Selenium::WebDriver.for :firefox

# ngram_query driver, "knowledge concerning these things"
# p suggested_book_searches(driver)
# exit

File.open("rare-4grams-remaining.txt") do |file|
  file.each_line do |line|
    begin
      words = line.split(" ")[0..-2].join(" ")
      puts words

      ngram_query driver, words
      suggested_book_searches(driver).each do |search_url|
        driver.navigate.to search_url

        wait = Selenium::WebDriver::Wait.new(:timeout => 15)
        wait.until { driver.find_element(:css => "li.g") }

        sleep 3

        begin
          no_results = driver.find_element(:css => "div.s:nth-child(1) > div:nth-child(1)")
          if no_results.text =~ /no results found/i
            puts "No results found"
          end
        rescue Selenium::WebDriver::Error::NoSuchElementError
          driver.find_elements(:css => "li.g").each do |element|
            puts element.text
            puts
          end
        end

        sleep 3 + rand(4) + rand(2)
      end
    rescue Selenium::WebDriver::Error::StaleElementReferenceError,
           Selenium::WebDriver::Error::TimeOutError
      puts "Not found"
    ensure
      puts
    end
  end
end


driver.quit