FactoryGirl.define do
  factory :user do
    factory :test_user do
      name 'Test User'
      email 'test@example.com'
      bio 'I am a test user. I admin the collections. I own test_tray and admin test_circle.'
      password 'testuser'
      password_confirmation 'testuser'
    end

    factory :user_two do
      name 'User Two'
      email 'two@example.com'
      bio 'I am another test user. I do not own trays. I admin a bunch of circles and participate in test_circle.'
      password 'usertwo'
      password_confirmation 'usertwo'
    end

    factory :user_three do
      name 'User Three'
      email 'three@example.com'
      bio 'I am yet another test user. I do not own trays. I admin private circle_seven and have added test_user & user_two to it.'
      password 'userthree'
      password_confirmation 'userthree'
    end
  end

  factory :collection do
    factory :test_col do
      name 'test_col'
      description 'a generic, valid collection with a valid configuration & some works'
      approved true
      #admin test_user
      configuration '{"title":["title"],"image":["imageInfo","url"],"thumbnail":["imageInfo","thumbnail_url"],"artist":["artist"],"topics":["subject","*","topic",0]}'
      source 'test_col source'
    end

    factory :not_approved do
      name 'not_approved'
      description 'collection not yet approved'
      approved false
      #admin test_user
      configuration '{"title":["title"],"image":["imageInfo","url"],"thumbnail":["imageInfo","thumbnail_url"]}'
      source 'not_approved source'
    end

    factory :multi_image do
      name 'multi_image'
      description 'collection with more than one image per work'
      approved true
      #admin test_user
      configuration '{"unique_identifier": ["recordIdentifier", 0, "content"], "title": ["titleInfo", 0, "title", 0], "image": ["relatedItem", "*", "content", "location", 0, "url", 0, "content"], "thumbnail": ["relatedItem", "*", "content", "location", 0, "url", 1, "content"]}'
      source 'multi_image source'
    end

    factory :via do
      name 'Homeless Paintings of the Italian Renaissance'
      description 'In his photo archive at the Villa I Tatti, Bernard Berenson included images of works whose current locations were unknown to him—a collection of photographs of paintings he famously classified as “homeless.” Between 1929 and 1932, Berenson published some of his photographs of artworks “without homes” with hope that their owners, public or private, might make themselves known. In the same spirit, and with support from the Mellon and Kress Foundations, the Villa I Tatti developed a project to catalog, digitize and make available online the Fototeca’s images of "homeless" paintings. In collaboration with the Villa I Tatti, and with additional support from the Kress Foundation and the De Bosis Endowment for Italian Studies at Harvard, metaLAB Is developing Curarium as a platform for discovering, annotating, and telling stories about Berenson’s Homeless Paintings, and to bring this rich collection into dialogue not only with students, scholars, and lovers of art, but other collections around the world. In Curarium, you can search Berenson’s collection of homeless paintings, visualizing relationships of time, place, and subject matter among the works; combine subsets of the collection into trays, annotate individual works, weaving them into arguments and narratives using the Spotlight feature; and share trays and spotlights with colleagues and students. Curarium is in a soft launch phase, and we eagerly users to experiment with the platform. If Berenson’s collection intersects with your teaching, research, or general interests, or if you have another collection in mind that might benefit from activation using Curarium’s emerging toolkit, get in touch with us. Use Curarium in bringing new stories of these paintings to light. Let us know what you find. And pass the word. info@metalab.harvard.edu'
      approved true
      #admin test_user
      configuration '{"unique_identifier": ["recordIdentifier", 0, "content"], "title": ["titleInfo", 0, "title", 0], "image": ["relatedItem", "*", "content", "location", 0, "url", 0, "content"], "thumbnail": ["relatedItem", "*", "content", "location", 0, "url", 1, "content"], "date": ["originInfo", 0, "dateOther", 0, "content"], "names": ["name", "*", "namePart", 0], "creator": ["name", 0, "namePart", 0], "genre" :["genre", "*"], "topics": ["subject", "*", "topic", 0]}'
      source 'Villa I Tatti'
    end

    factory :japanese do
      name 'Harvard Art Museums: Japanese Culture'
      description 'A subset of the Harvard Art Museums collection, including only works identified as Japanese.'
      approved true
      #admin test_user
      configuration '{"unique_identifier": ["id"], "title": ["title"], "image": ["primaryimageurl"], "thumbnail": ["primaryimageurl"], "creator": ["people", 0, "displayname"], "names": ["people", "*", "displayname"]}'
      source 'Harvard Art Museums'
    end

    factory :heinz do
      name 'Heinz Mack'
      description 'Heinz'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"classification":["classification"],"medium":["medium"],"people":["people","*","name"],"places":["places","*","displayname"],"technique":["technique"]}'
      source 'Harvard Art Museums'
    end

    factory :lighting do
      name 'Lighting Devices'
      description 'Lighting Devices'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"places":["places","*","displayname"],"people":["people","*","displayname"],"technique":["technique"],"medium":["medium"],"classification":["classification"],"culture":["culture"]}'
      source 'Harvard Art Museums'
    end

    factory :aquatint do
      name 'Aquatint'
      description 'Aquatint'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"places":["places","*","displayname"],"people":["people","*","displayname"],"technique":["technique"],"medium":["medium"],"classification":["classification"],"culture":["culture"]}'
      source 'Harvard Art Museums'
    end


    factory :colorado_river do
      name 'colorado_river'
      description 'colorado_river'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"places":["places","*","displayname"],"people":["people","*","displayname"],"technique":["technique"],"medium":["medium"],"classification":["classification"],"culture":["culture"]}'
      source 'Harvard Art Museums'
    end


    factory :map do
      name 'map'
      description 'map'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"places":["places","*","displayname"],"people":["people","*","displayname"],"technique":["technique"],"medium":["medium"],"classification":["classification"],"culture":["culture"]}'
      source 'Harvard Art Museums'
    end


    factory :russian do
      name 'russian'
      description 'russian'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"places":["places","*","displayname"],"people":["people","*","displayname"],"technique":["technique"],"medium":["medium"],"classification":["classification"],"culture":["culture"]}'
      source 'Harvard Art Museums'
    end

    factory :tate_collections_1 do
      name 'tate_collections_1'
      description 'tate_collections_1'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"places":["places","*","displayname"],"people":["people","*","displayname"],"technique":["technique"],"medium":["medium"],"classification":["classification"],"culture":["culture"]}'
      source 'Harvard Art Museums'
    end


    factory :textile do
      name 'textile'
      description 'textile'
      approved true
      configuration '{"unique_identifier":["id"],"title":["title"],"image":["images","*","baseimageurl"],"thumbnail":["images","*","baseimageurl"],"places":["places","*","displayname"],"people":["people","*","displayname"],"technique":["technique"],"medium":["medium"],"classification":["classification"],"culture":["culture"]}'
      source 'Harvard Art Museums'
    end

  end

  factory :work do
    factory :starry_night do
      # collection test_col
      original '{"title":"Starry Night","imageInfo":{"url":"/test/starry_night.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/116px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg"},"artist":"Van Gogh","subject":[{"topic":["stars"]},{"topic":["night"]},{"topic":["churches"]}]}'
      primary_color '#dedede'
      top_colors {{ '#dedede' => 0.95, '#9f2211' => 0.05 }}
    end

    factory :mona_lisa do
      # collection test_col
      original '{"title":"Mona Lisa","imageInfo":{"url":"/test/mona_lisa.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/80px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg"},"artist":"da Vinci","subject":[{"topic":["Lisa"]},{"topic":["women"]},{"topic":["portraits"]}]}'
    end

    factory :last_supper do
      # collection test_col
      original '{"title":"Last Supper","imageInfo":{"url":"/test/last_supper.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/62/%C3%9Altima_CenaII.jpg/120px-%C3%9Altima_CenaII.jpg"},"artist":"da Vinci","subject":[{"topic":["Jesus"]},{"topic":["Mary"]},{"topic":["men"]},{"topic":["supper"]},{"topic":["women"]},{"topic":["Joseph, Saint"]}]}'
    end

    factory :lucrezia do
      # collection test_col
      original '{"title":"Lucrezia","imageInfo":{"url":"/test/lucrezia.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Parmigianino%2C_lucrezia_romana%2C_1540.jpg/89px-Parmigianino%2C_lucrezia_romana%2C_1540.jpg"},"artist":"Parmigianino","subject":[{"topic":["death"]},{"topic":["portraits"]},{"topic":["women"]},{"topic":["breast"]}]}'
    end

    factory :empty_thumbnail do
      #collection test_col
      original '{"title":"empty_thumbnail","imageInfo":{"url":"/test/mona_lisa.jpg"},"artist":"da Vinci","subject":[{"topic":["Mona"]},{"topic":["women"]},{"topic":["portraits"]}]}'
    end

    factory :aphrodite do
      # collection not_approved
      original '{"title":"Aphrodite Pudica","imageInfo":{"url":"/test/aphrodite.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/0/02/NAMA_Aphrodite_Syracuse.jpg/110px-NAMA_Aphrodite_Syracuse.jpg"},"artist":"Copie de Praxitèle"}'
    end

    factory :crucifixion do
      #collection multi_image
      original '{"titleInfo":[{"title":["Crucifixion"]}],"relatedItem":[{"content":{"location":[{"url":[{"displayLabel":"Full Image","note":"unrestricted","content":"/test/crucifixion_1.jpg"},{"displayLabel":"Thumbnail","content":"http:\/\/nrs.harvard.edu\/urn-3:VIT.BB:4627197"}]}]}},{"content":{"location":[{"url":[{"displayLabel":"Text","note":"unrestricted","content":"/test/crucifixion_2.jpg"},{"displayLabel":"Thumbnail","content":"http://ts3.mm.bing.net/th?id=HN.607998929429597709&w=116&h=176&c=7&rs=1&pid=1.7"}]}]}}],"recordIdentifier":[{"source":"VIA","content":"olvwork384182"}]}'
    end

  end

  factory :annotation do
    factory :jesus do
      # user test_user
      # image last_supper.images.first
      title 'jesus'
      body 'hey!'
      #tags 'Jesus' # removed for now
      x 2592
      y 1408.5127272727272
      width 249
      height 308
      image_url '/works/3/images/0'
      thumbnail_url '/test/annotation_thumbnails/1.png'
    end

    # used as attributes for creating new annotations in tests
    factory :star do
      # user test_user
      # image starry_night.images.first
      title 'star'
      body 'One of the many stars.'
      tags 'stars'
      x 343.47368421052635
      y 447
      width 209
      height 179
      image_url '/test/starry_night.jpg'
    end
  end

  factory :circle do
    factory :test_circle do
      title 'test_circle'
      description 'A private circle whose admin is test_user. user_two added.'
      privacy 'private'
      #admin test_user
      #users [user_two]
      #trays [circle_tray]
      #collections [test_col]
    end

    factory :circle_two do
      title 'circle_two'
      description 'A private circle whose admin is user_two. test_user added.'
      privacy 'private'
      #admin user_two
      #users [test_user]
    end

    # used as attributes for creating new circles in tests
    factory :circle_three do
      title 'circle_three'
      description 'Circle data to test creating new cirlces'
      privacy 'private'
      #admin test_user
    end

    factory :circle_four do
      title 'circle_four'
      description 'A private circle whose admin is user_two. no users.'
      privacy 'private'
      #admin user_two
      #users []
    end

    factory :circle_five do
      title 'circle_five'
      description 'A community circle whose admin is user_two. no users.'
      privacy 'community'
      #admin user_two
      #users []
    end

    factory :circle_six do
      title 'circle_six'
      description 'A public circle whose admin is user_two. no users.'
      privacy 'public'
      #admin user_two
      #users []
    end

    factory :circle_seven do
      title 'circle_seven'
      description 'A private circle whose admin is user_three & users 1 & 2 participate.'
      privacy 'private'
      #admin user_three
      #users [test_user, user_two]
    end
  end

  factory :tray do
    factory :test_tray do
      name 'test_tray'
      #owner test_user
      #images starry_night
      #annotations jesus
    end

    factory :empty_tray do
      name 'empty_tray'
      #owner test_user
      #images 
    end

    factory :circle_tray do
      name 'circle_tray'
      #owner test_circle
      #images aphrodite
    end
  end

  factory :spotlight do
    factory :test_spotlight do
      #user test_user
      #circle nil
      title 'test_spotlight'
      privacy 'public'
      body 'This is a test public spotlight'
      waku_id '31337'
      waku_url 'http://wacurarium.herokuapp.com/#proj/31337'
    end

    factory :spotlight_one_priv do
      #user test_user
      #circle nil
      title 'spotlight_one_priv'
      privacy 'private'
      body 'This is a test private spotlight for test_user'
      waku_id '31338'
      waku_url 'http://wacurarium.herokuapp.com/#proj/31338'
    end

    factory :spotlight_two do
      title 'spotlight_two'
      privacy 'public'
      body 'Used as attributes for testing spotlight creation'
      waku_id '31339'
      waku_url 'http://wacurarium.herokuapp.com/#proj/31339'
    end

    factory :spotlight_two_pub do
      #user user_two
      #circle nil
      privacy 'public'
      title 'spotlight_two_pub'
      body 'This is a test public spotlight for user 2'
      waku_id '31340'
      waku_url 'http://wacurarium.herokuapp.com/#proj/31340'
    end

    factory :spotlight_two_priv do
      #user user_two
      #circle nil
      privacy 'private'
      title 'spotlight_two_priv'
      body 'This is a test private spotlight'
      waku_id '31341'
      waku_url 'http://wacurarium.herokuapp.com/#proj/31341'
    end

    factory :spotlight_two_circle do
      #user user_two
      #circle test_circle
      privacy 'private'
      title 'spotlight_two_circle'
      body 'This is a test circle spotlight'
      waku_id '31342'
      waku_url 'http://wacurarium.herokuapp.com/#proj/31342'
    end
  end
end


