require 'selenium-webdriver'
require 'debugger'

def click_search_tools(driver)
  driver.find_element(:id, 'hdtb_tls').click

  wait = Selenium::WebDriver::Wait.new(:timeout => 15)
  wait.until { driver.find_element(:css => "div.hdtb-mn-hd:nth-child(6)") }
end

def set_date_range(driver, min, max)
  wait = Selenium::WebDriver::Wait.new(:timeout => 15)

  driver.find_element(:css, 'div.hdtb-mn-hd:nth-child(6)').click
  wait.until { driver.find_element(:id => "cdrlnk") }

  driver.find_element(:id, 'cdrlnk').click
  wait.until { driver.find_element(:id => "cdr_min") }

  begin # submit date range
    element = driver.find_element(:id => 'cdr_min')
    element.clear
    element.send_keys "#{min}"

    element = driver.find_element(:id => 'cdr_max')
    element.clear
    element.send_keys "#{max}"

    element = driver.find_element(:css => '#cdr_frm input[type=submit]')
    element.click
  end
  wait.until { driver.find_element(:name => 'q') }
  sleep 0.2
end

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://books.google.com"

element = driver.find_element(:name => 'q')
element.send_keys "testy"
element.submit

sleep 1

click_search_tools driver
set_date_range driver, 1500, 1830

File.open("rare-4grams-remaining.txt") do |file|
  file.each_line do |line|
    begin
      words = line.split(" ")[0..-2].join(" ")

      element = driver.find_element(:name => 'q')
      element.clear
      element.send_keys %{"#{words}"}

      element.submit

      wait = Selenium::WebDriver::Wait.new(:timeout => 15)
      wait.until { driver.find_element(:css => "li.g") }

      sleep 3

      puts words

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
      puts

      sleep 3 + rand(4) + rand(2)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
    end
  end
end


driver.quit