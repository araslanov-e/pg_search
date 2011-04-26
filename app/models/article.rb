class Article < ActiveRecord::Base

  def self.tsearch(search_terms, limit = 30)
    words = sanitize(search_terms.scan(/\w+/) * "|")

    Article.select([:title, :body, :id]).
      from("articles, to_tsquery('pg_catalog.english', #{words}) as q").
        where("tsv @@ q").
          order("ts_rank_cd(tsv, q) DESC").limit(limit)
  end

  def self.highlighted_results
     select("ts_headline(body, q, 'StartSel = <strong>, StopSel = </strong>, HighlightAll=TRUE') as html_body").
       select("ts_headline(title, q, 'StartSel = <strong>, StopSel = </strong>, HighlightAll=TRUE') as html_title")
  end

  def self.highlighted_tsearch(search_terms)
    highlighted_results.tsearch(search_terms)
  end

end
