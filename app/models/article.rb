class Article < ActiveRecord::Base
  validates :title, :body, :presence => true

  # Note that ActiveRecord ARel from() doesn't appear to accommodate "?"
  # param placeholder, hence the need for manual parameter sanitization
  def self.tsearch_query(search_terms, limit = 25)
    words = sanitize(search_terms.scan(/\w+/) * "|")

    Article.from("articles, to_tsquery('pg_catalog.english', #{words}) as q").
      where("tsv @@ q").order("ts_rank_cd(tsv, q) DESC").limit(limit)
  end

  # Selects search results with plain text title & body columns.
  # Select columns are explicitly listed to avoid returning the long redundant tsv strings
  def self.plain_tsearch(search_terms, limit)
    select([:title, :body, :id]).tsearch_query(search_terms, limit)
  end

  # Select search results with HTML highlighted title & body columns
  def self.highlight_tsearch(search_terms, limit)
    body = "ts_headline(body, q, 'StartSel=<strong>, StopSel=</strong>, HighlightAll=TRUE') as body"
    title = "ts_headline(title, q, 'StartSel=<strong>, StopSel=</strong>, HighlightAll=TRUE') as title"
    Article.select([body, title, :id]).tsearch_query(search_terms, limit)
  end
end