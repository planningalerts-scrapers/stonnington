# frozen_string_literal: true

require "scraperwiki"
require "mechanize"
require "json"
require "date"

class Scraper
  BASE_URL = "https://eplanning.stonnington.vic.gov.au"
  API_URL = "#{BASE_URL}/planning-api/api/PublicRegister/GetRecords"
  PAGE_SIZE = 100
  MAX_PAGES = 100

  def self.run
    agent = Mechanize.new
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

    date_from = Date.today - 30
    page_number = 0
    total_saved = 0
    last_date_received = Date.today

    while page_number < MAX_PAGES && last_date_received >= date_from
      body = {
        applicationNumber: "",
        dateLodged: "",
        decisionDate: nil,
        addressDetail: "",
        statuses: "",
        ward: "",
        reasonForPermit: "",
        pageNumber: page_number,
        pageSize: PAGE_SIZE,
        sortBy: "dateLodged",
        sortDirection: "desc",
        parentSearch: nil,
        dateFormat: "d-MMM-yyyy",
      }.to_json
      page_number += 1

      response = agent.request_with_entity("POST", API_URL, body, "Content-Type" => "application/json")
      data = JSON.parse(response.body)
      records = data["registers"]
      if records.nil? || records.empty?
        puts "WARNING: Aborted - API did not return list of records in registers key"
        break
      end

      records.each do |r|
        date_lodged = r["dateLodged"]&.slice(0, 10)
        unless date_lodged
          puts "NOTE: Skipped record missing dateLodged: #{r.inspect}"
          next
        end

        last_date_received = Date.parse(date_lodged)
        record = {
          "council_reference" => r["applicationNumberDisplay"],
          "address" => r["addressDetail"],
          "description" => r["reasonForPermit"],
          "info_url" => "#{BASE_URL}/public/details/#{r['correlationId']}",
          "date_scraped" => Date.today.to_s,
          "date_received" => last_date_received,
        }
        puts "Saving record #{record['council_reference']} - #{record['address']}#{ENV['DEBUG'] ? " #{record['info_url']}" : ''}"
        ScraperWiki.save_sqlite(["council_reference"], record)
        total_saved += 1
      end
      continuing = last_date_received >= date_from ? "continuing on next page" : "far enough into past"
      puts "Page #{page_number}: #{records.size} records received from #{last_date_received} (#{continuing})"
      if records.size < PAGE_SIZE
        puts "End of list - page is not full"
        break
      end
    end

    puts "Done. Total saved: #{total_saved}"
  end
end

Scraper.run if __FILE__ == $PROGRAM_NAME
