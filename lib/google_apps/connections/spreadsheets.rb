class GoogleApps
class SpreadsheetsConnection < GoogleApps
  attr_reader :token

  def initialize
    @token = auth(:documents).merge( "GData-Version" => "2.0", "Content-Type" => "application/atom+xml" )
  end
  
  def create!( opts = {} )
    # sub document for spreadsheet if you want to create a document
    headers = @token
    body = String.new
    builder = Builder::XmlMarkup.new(:indent => 2, :target => body)
    builder.instruct!
    builder.tag! "atom:entry", "xmlns:atom" => "http://www.w3.org/2005/Atom", "xmlns:docs" => "http://schemas.google.com/docs/2007" do |atom_entry|
      atom_entry.tag! "atom:category", :label => "spreadsheet", :term => "http://schemas.google.com/docs/2007#spreadsheet", :scheme => "http://schemas.google.com/g/2005#kind"
      atom_entry.tag! "atom:title", opts[:title] || "new spreadsheet"
      atom_entry.tag! "docs:writersCanInvite", :value => false
    end
  
    response = self.class.post "http://docs.google.com/feeds/documents/private/full", :headers => headers, :body => body, :query => {}
  
    if response.code / 100 == 2
      GoogleSpreadsheet.new response
    else
      raise GoogleAppsError, response
    end
  end

  def add_user(doc, emails, role)
    headers = @token
  
    Array(emails).each do |email|
      body = String.new
      builder = Builder::XmlMarkup.new(:indent => 2, :target => body)
      builder.entry(:xmlns => "http://www.w3.org/2005/Atom", "xmlns:gAcl" => "http://schemas.google.com/acl/2007") do |entry|
        entry.category :scheme => "http://schemas.google.com/g/2005#kind", :term => "http://schemas.google.com/acl/2007#accessRule"
        entry.tag! "gAcl:role", :value => role.to_s
        entry.tag! "gAcl:scope", :type => "user", :value => email
      end
    
      response = self.class.post "http://docs.google.com/feeds/acl/private/full/document%3A#{ doc.document_id }", :headers => headers, :body => body, :query => {}
    end
  end
  
  # def spreadsheets( refresh = false )
  # need to authenticate against wise
  #   return @spreadsheets if !refresh && @spreadsheets
  #   default_headers = { "GData-Version" => "3.0" }
  #   default_headers.merge!("If-None-Match" => @spreadsheets_etag) if @spreadsheets_etag
  #   resp = self.class.get "http://spreadsheets.google.com/feeds/spreadsheets/private/full", :headers => default_headers.merge(@auth)
  #   
  #   if resp.code == 200
  #     doc = Hpricot.XML(resp)
  #     @spreadsheets_etag = resp.headers["etag"].first
  # 
  #     @spreadsheets = []
  #     (doc/"entry").each do |d|
  #       g = GoogleApps::GoogleSpreadsheet.new :id => (d/"id").inner_html, :updated => (d/"updated").inner_html, :title => (d/"title").inner_html
  #       @spreadsheets << g
  #     end
  #   
  #     @spreadsheets
  #   else
  #     raise GoogleAppsError, resp.inspect
  #   end
  # end
end
end