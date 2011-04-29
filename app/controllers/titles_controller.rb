class TitlesController < ApplicationController
  def index
    newSearch = Sunspot.new_search(Title) do
      paginate(:page => params[:page], :per_page => 4)
      facet(:category_id, :publisher_id, :author_id)
    end
    
    search = Sunspot.new_search(Title) do
      paginate(:page => params[:page], :per_page => 6)
    end


    if !params[:queryTitleId].blank?
      if Title.exists?(params[:queryTitleId])
        @title = Title.find(params[:queryTitleId])
        if params[:query].blank?
          params[:query] = @title.title
        else
          params[:queryTitleId] = ""
        end
      end
    end
    
#    newSearch = Sunspot.new_search(Title) do
#      keywords params[:query] do
#        highlight :title, :publisher, :author
#      end
#      paginate(:page => params[:page], :per_page => 15)
#      facet(:category_id, :publisher_id, :author_id)
#    end
 
    newSearch.build do
      keywords params[:query] do
        highlight :title, :publisher, :author
      end
    end
    
    search.build do
      keywords(params[:query] )
    end
    
    search.build do
      order_by(:no_of_rented, :desc)
    end
    
    newSearch.build do 
      with(:category_id, params[:facetCategory]) 
    end if params[:facetCategory].to_i > 0

    newSearch.build do 
      with(:publisher_id, params[:facetPublisher]) 
    end if params[:facetPublisher].to_i > 0

    newSearch.build do 
      with(:author_id, params[:facetAuthor]) 
    end if params[:facetAuthor].to_i > 0
  
    @searchResults = newSearch.execute
    @shelfMR = search.execute
    i = 0
    shelf0= @searchResults.facet(:category_id).rows
    @shelf_name = []
    @shelf_name << ""
    @shelf_name << ""
    @shelf_name << ""
    @shelf_name << ""
    
    #facetCategory
    @shelf  =[]
    @shelf << []
    @shelf << []
    @shelf << []
    @shelf << []
    @cat_id  =[]
    @cat_id <<  1
    @cat_id <<  2
    @cat_id <<  3
    @cat_id <<  4
    
    per_page = 1
    @shelf0= @searchResults.facet(:category_id).rows
    @shelf1 = @searchResults.facet(:author_id).rows.paginate(:page=> params[:page], :per_page=>2)
    @shelf3 = @searchResults.facet(:publisher_id).rows.paginate(:page=> params[:page], :per_page=>2)
    @shelf4 = @searchResults.results
    
    @shelf0.each do |row|  
      if i<4
        case i
          when 0 then per_page = 3
          when 1 then per_page = 1
          when 2 then per_page = 2
          when 3 then per_page = 1
        end
        @shelf_name[i] = row.instance.name
        @cat_id[i] = row.value
        cat_search = Sunspot.new_search(Title) do
          paginate(:page => params[:page], :per_page => per_page)
          facet(:category_id)
        end
        cat_search.build do 
          with(:category_id, row.value) 
        end 
        
        cat_search.build do
          keywords(params[:query] )
        end
        @shelf[i] = cat_search.execute  
        
      end
      i+=1
    end
    
    
    #@shelfMR = sr.results.paginate(:page=>1, :per_page=>5)
  end
  def refine
    
    search = Sunspot.new_search(Title) do
      paginate(:page => params[:page], :per_page => params[:per_page])
    end
    search.build do
      keywords(params[:query] )
    end
    
    search.build do 
      with(:category_id, params[:facetCategory]) 
    end if params[:facetCategory].to_i > 0

    search.build do
      order_by(:no_of_rented, :desc)
    end if params[:shelf].eql?('MOST READ')
    shelfMR = search.execute
    
    @shelf0 = shelfMR.results
    
    @shelf_name=params[:shelf]
    render 'show'  
  end
  
# not using more like this- not sure how this is working as of now
  def show
    title = Title.find(params[:id])
    params[:query] = title.title
    
    
    params[:query] = title.title
    shelf0 = []
    shelf0 << title
    @shelf_name=  title.title
    
    newSearch = Sunspot.new_more_like_this(title, Title) do
      facet(:category_id, :publisher_id, :author_id)
    end
    
    newSearch.build do 
      with(:category_id, params[:cat_id]) 
    end if params[:cat_id].to_i > 0

    newSearch.build do 
      with(:publisher_id, params[:facetPublisher]) 
    end if params[:facetPublisher].to_i > 0

    newSearch.build do 
      with(:author_id, params[:facetAuthor]) 
    end if params[:facetAuthor].to_i > 0
  
    searchResults = newSearch.execute
    searchResults.results.each do |sr|
      shelf0 << sr
    end
    @shelf0  = shelf0.paginate(:page => params[:page], :per_page => 9)
#    @searchResults = Sunspot.more_like_this(@title, Title) do
#      fields :title, :publisher, :author
#      paginate(:page => params[:page], :per_page => 15)
#      facet(:category_id, :publisher_id, :author_id)
#    end
  end
end
