#require 'scraperwiki'
require 'mechanize'
require 'json'

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'
agent.log = Logger.new(STDOUT)
url = 'https://eplanning.stonnington.vic.gov.au/EPlanning/Services/EPlanningReferenceService.svc/GetList_Register'
req_body = File.read('req')
headers = {"Content-Type" => "application/json"}
 
viewurlbase = "https://eplanning.stonnington.vic.gov.au/EPlanning/Public/ViewActivity.aspx?refid="
 
response = agent.request_with_entity('POST', url, req_body, headers)
data = JSON.parse(response.body)

res = File.read('res')
data = JSON.parse(res)
d = JSON.parse(data['d'])
av = d['ActivityView']

av.each do |r|
  record = {
    'council_reference' => r['ApplicationReference'],
    'address' => r['SiteAddress'],
    'description' => r['ReasonForPermit'],
    'info_url' => (viewurlbase + URI.encode(r['ApplicationReference'])).to_s,
    'comment_url' => "mailto:council@stonnington.vic.gov.au",
    'date_scraped' => Date.today.to_s,
    'date_received' => Date.strptime(r['LodgedDate_STRING'], "%d-%b-%Y").to_s
  }

  if ScraperWiki.select("* from data where `council_reference`='#{record['council_reference']}'").empty? 
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end

end