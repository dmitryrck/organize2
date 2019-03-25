class Doc
  attr_reader :doc_id

  def initialize(doc_id)
    @doc_id = doc_id
  end

  def self.all
    list.keys.map { |doc_id| Doc.new(doc_id) }
  end

  def self.list
    if Rails.env.production?
      @list ||= Psych.load(File.read(Rails.root.join(BASE_DIR, "index.yml")))
    else
      Psych.load(File.read(Rails.root.join(BASE_DIR, "index.yml")))
    end
  end

  def title
    list.fetch(@doc_id) { { "title" => "Not found" } }["title"]
  end

  def description
    list.fetch(@doc_id) { { "description" => "" } }["description"]
  end

  def path
    return not_found if invalid?

    @path ||= Rails.root.join(BASE_DIR, @doc_id + ".html.erb")
  end

  def url
    "/#{BASE_DIR}/#{@doc_id}"
  end

  def invalid?
    !valid?
  end

  private

  BASE_DIR = "docs".freeze

  def not_found
    Rails.root.join(BASE_DIR, "not_found.html.erb")
  end

  def whitelist
    list.keys
  end

  def valid?
    whitelist.include?(@doc_id)
  end

  def list
    self.class.list
  end
end
