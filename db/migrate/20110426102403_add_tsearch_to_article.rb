class AddTsearchToArticle < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      ALTER TABLE articles ADD COLUMN tsv tsvector;
    eosql

    execute(<<-'eosql'.strip)
      CREATE FUNCTION articles_trigger() RETURNS trigger AS $$
        begin
          new.tsv :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.body,'')), 'B');
          return new;
        end
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER tsvector_articles_upsert_trigger BEFORE INSERT OR UPDATE
        ON articles
        FOR EACH ROW EXECUTE PROCEDURE articles_trigger();
    eosql

    execute(<<-'eosql'.strip)
      UPDATE articles SET tsv =
        setweight(to_tsvector('pg_catalog.english', coalesce(title,'')), 'A') ||
        setweight(to_tsvector('pg_catalog.english', coalesce(body,'')), 'B');

      CREATE INDEX articles_tsv_idx ON articles USING gin(tsv);
    eosql

  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP INDEX IF EXISTS articles_tsv_idx;
      DROP TRIGGER IF EXISTS tsvector_articles_upsert_trigger ON articles;
      DROP FUNCTION IF EXISTS articles_trigger();
      ALTER TABLE articles DROP COLUMN tsv;
    eosql
  end
end
