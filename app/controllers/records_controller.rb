require 'open-uri'

class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :thumb, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:show,:thumb]

  # GET /records
  # GET /records.json
  def index
    where_clause = ''

    if params[ :collection_id ].present?
      where_clause = where_clause + ActiveRecord::Base.send( :sanitize_sql_array, [ ' collection_id = %s', params[:collection_id] ] )
    end

    if params[:include].present?
      # break out values to avoid SQL injection
      where_values = ['']

      params[:include].each_with_index { |p, i|
        values = p.split ':'

        if i > 0
          where_values[0] = where_values[0] + ' AND '
        end

        where_values[0] = where_values[0] + "lower(parsed->'#{values[0]}') like '%s'"
        where_values << "%#{values[1].downcase}%"
      }

      where_clause = where_clause + " AND ( #{ActiveRecord::Base.send( :sanitize_sql_array, where_values )} )"
    end

    if params[:exclude].present?
      # break out values to avoid SQL injection
      where_values = ['']

      params[:exclude].each_with_index { |p, i|
        values = p.split ':'

        if i > 0
          where_values[0] = where_values[0] + ' OR '
        end

        where_values[0] = where_values[0] + "lower(parsed->'#{values[0]}') like '%s'"
        where_values << "%#{values[1].downcase}%"
      }

      where_clause = where_clause + " AND NOT ( #{ActiveRecord::Base.send( :sanitize_sql_array, where_values )} )"
    end

    if params[ :property ].present? && params[ :vis ] == 'treemap'
      # ["a", "b, b", "c"]
      # ["a%SPLIT%b, b%SPLIT%c"]
      # a%SPLIT%b, b%SPLIT%c
      # a -- b, b -- c
      sql = %[select values as parsed, count(values) as id from (
        SELECT  trim(
          both from unnest(
            string_to_array(
              regexp_replace(
                regexp_replace(
                  lower(parsed->'#{params[ :property ]}'), '", "', '%SPLIT%', 'g'
                ), '[\\[\\]"]', '', 'g'
              ), '%SPLIT%'
            )
          )
        ) as values
        FROM "records"
        WHERE #{where_clause}
      ) as subquery
      group by values]

      @records = ActiveRecord::Base.connection.execute(sql)
    else
      @records = Record.where(where_clause)
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
     if @record.amendments.length > 0
       @current_metadata = @record.amendments.last.amended
     else
       @current_metadata = @record.parsed
     end
     eval_parsed = {}
     @current_metadata.each do |key, value|
       eval_parsed[key] = eval(value) unless value.to_s.empty?
     end
     respond_to do |format|
       format.html { }
       format.json { @record.parsed = eval_parsed }
       format.js { render action: "show" }
     end
  end

  def image_type( local_file_path )
    png = Regexp.new("\x89PNG".force_encoding("binary"))
    jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))

    case IO.read(local_file_path, 10)
    when /^GIF8/
      'gif'
    when /^#{png}/
      'png'
    when /^#{jpg}/
      'jpeg'
    else
      '*'
    end
  end
    
  # GET /records/1/thumb
  def thumb
    thumb_url = JSON.parse( @record.parsed[ 'thumbnail' ] )[0]
    if thumb_url.nil?
      send_data File.open( "#{Rails.public_path}/missing_thumb.png", 'rb' ).read, type: 'image/png', disposition: 'inline'
    else
      thumb_connection = open( thumb_url + ( thumb_url.include?( '?' ) ? '&' : '?' ) + 'width=256&height=256', 'rb' )

      if thumb_connection.is_a? Tempfile
        send_data thumb_connection.read, type: "image/#{image_type thumb_connection.path}", disposition: 'inline'
      else
        thumb_hash = thumb_url.hash
        cache_date = Rails.cache.fetch( "#{thumb_hash}-date" ) { Date.today }
        cache_image = Rails.cache.fetch( "#{thumb_hash}-image" ) { thumb_connection.read }

        if stale?( etag: thumb_hash, last_modified: cache_date )
          send_data cache_image, type: thumb_connection.meta[ 'content-type' ], disposition: 'inline'
        end
      end
    end
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @record }
      else
        format.html { render action: 'new' }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    amended = params[:record][:parsed]
    #@record.update(parsed: amended)
    if @record.amendments.length > 0
      last_amendment = @record.amendments.last.amended
    else
      last_amendment = @record.parsed
    end
    
    @amendment = @record.amendments.new
    @amendment.user_id = session[:user_id].to_i
    @amendment.previous = last_amendment
    @amendment.amended = amended
    @amendment.save
    
    respond_to do |format|
      format.html { redirect_to @record }
      format.json { render json: @amendment }
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:original, :parsed, :belongs_to)
    end
end
