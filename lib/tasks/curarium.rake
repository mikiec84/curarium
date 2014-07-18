require 'net/http'
require 'uri'
require 'json'

namespace :curarium do
  desc 'Mass import JSON data based on configuration key'
  task :ingest, [:input_dir, :collection_key] => [:environment] do |task, args|
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts "Started at #{Time.now}"

    curarium_ingest args[:input_dir], args[:collection_key]

    puts "Ended at #{Time.now}"

    ActiveRecord::Base.logger = old_logger
  end

  def curarium_ingest( input_dir, collection_key )
    usage = "usage: rake curarium:ingest['path/to/input_dir,collection_key']"

    if input_dir.nil? || collection_key.nil?
      puts usage
      return
    end

    if !Dir.exists? input_dir
      puts "#{input_dir} does not exist"
      return
    end

    if Collection.where( { key: collection_key } ).count == 0
      puts "Cannot find collection with key #{collection_key}"
      return
    end

    ent = Dir.entries input_dir
    puts "Ingesting #{ent.count - 2} records from #{input_dir}"
    puts "Ingesting into collection with key: #{collection_key}"

    j_count = 0
    ent.each { |f| 
      collection = Collection.find_by_key( collection_key )
      configuration = collection.configuration
      t = Thread.new { read_record( input_dir, f, configuration ) }
      t.join

      if t[ :unique_identifier ] != '' && Record.exists?( unique_identifier: t[ :unique_identifier ].to_s, collection_id: collection.id )
        r = Record.find_by( unique_identifier: t[ :unique_identifier ].to_s, collection_id: collection.id )
        r.update( original: t[:original], parsed: t[:parsed] )
        ok = true
      else

        ok = Collection.create_record_from_parsed collection_key, t[ :original ], t[ :parsed ], t[ :unique_identifier ] unless t[ :original ].nil?
        # sleep to avoid rate limiting
        sleep 0.125
      end

      if ok
        j_count += 1
      end

      if j_count > 0 && j_count % 100 == 0
        puts j_count

        GC.start
        puts "heap: #{GC.stat[ :heap_live_num ]}"
      end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count - 2} total files in directory)"
  end

  def read_record( input_dir, f, configuration )
    # thread to wait for file IO, return json
    if f.present? && !File.directory?(f) && File.extname(f) == '.json'
      filename = "./#{input_dir}/#{File.basename(f)}"
      rec_json = IO.read filename

      pr = {}
      unique_identifier = ''

      configuration.each do |field|
        if field[0] == 'unique_identifier'
          unique_identifier_obj = Collection.follow_json(rec_json, field[1])
          unique_identifier = unique_identifier_obj[ 0 ] unless unique_identifier_obj.nil?
        else
          pr[field[0]] = Collection.follow_json(rec_json, field[1])
        end
      end

      Thread.current[ :original ] = rec_json
      Thread.current[ :parsed ] = pr
      Thread.current[ :unique_identifier ] = unique_identifier
    end
  end
end
