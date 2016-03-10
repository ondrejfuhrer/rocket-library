namespace :rocket_library do
  desc 'Regenerates all cover versions for all books'
  task regenerate_book_covers: :environment do
    Book.find_each do |book|
      begin
        if not book.cover.file.nil? and book.cover.file.exists?
          book.cover.cache_stored_file!
          book.cover.retrieve_from_cache!(book.cover.cache_name)
          book.cover.recreate_versions!
          book.save!

          puts "SUCCESS: Book #{book.id} successfully regenerated"
        else
          puts "SKIP: Book #{book.id} skipped, file does not exists"
        end
      rescue => e
        puts "ERROR: Book: #{book.id} -> #{e.to_s} #{book.cover}"
      end
    end
  end

end
