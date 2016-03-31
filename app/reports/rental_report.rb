class RentalReport < Dossier::Report
  def sql
    "
    SELECT
      b.name,
      b.author,
      (SELECT COUNT(b2.id) FROM books b2 WHERE (b2.author || b2.name) = (b.author || b.name) ) as count_books,
      COUNT(r.id) as count_rentals,
      AVG(rental_times.time) as avg_rental_time,
      MAX(rental_times.time) as max_rental_time,
      MIN(rental_times.time) as min_rental_time,
      COUNT(w.id) as count_watch_list
    FROM
      rentals r
    LEFT JOIN books b ON r.book_id = b.id
    LEFT JOIN
      (
        SELECT
          r2.book_id,
          (strftime('%s', COALESCE(r2.returned_at, DATETIME('now'))) - strftime('%s', r2.created_at)) as time
        FROM rentals r2
      ) as rental_times ON rental_times.book_id = b.id
    LEFT JOIN watch_lists w on w.rental_id = r.id
    WHERE
          r.created_at > :date_from AND
          r.created_at < :date_to
    GROUP BY (b.name || b.author)
    ORDER BY b.name
    "
  end

  def format_avg_rental_time(word)
    TimeDifference.calculate(word).in_general.humanize
  end

  def format_max_rental_time(word)
    TimeDifference.calculate(word).in_general.humanize
  end

  def format_min_rental_time(word)
    TimeDifference.calculate(word).in_general.humanize
  end

  # We override the Dossier::Reports#raw_results function to provide the results from Dossier::Reports#results
  # That causes that we got the formatting also for XLS and CSV files
  def raw_results
    results
  end

  def date_to
    if options[:date_to].respond_to?(:to_time)
      options[:date_to].to_time + 1.day
    end
  end

  def date_from
    options[:date_from].try(:to_time)
  end

  def xls
    false
  end

  def csv
    false
  end
end
