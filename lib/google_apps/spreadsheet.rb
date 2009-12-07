class GoogleSpreadsheet
  attr_accessor :document_id, :title, :link, :updated
  
  def initialize( response )
    doc = Crack::XML.parse(response)
    self.document_id = doc["entry"]["gd:resourceId"].split(":").last
    self.link = doc["entry"]["link"].detect{ |e| e["rel"] == "alternate" }["href"]
    self.title = doc["entry"]["title"]
    self.updated = doc["entry"]["updated"]
  end
end