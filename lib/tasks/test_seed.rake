require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      seed
    end
  end
end

namespace :curarium do
  task :seed => :environment do
    seed
  end

  task :seed_prod => :environment do
    seed_prod
  end
end

def crfj( col, r )
  col.create_work_from_json FactoryGirl.attributes_for( r )[ :original ]
end

def seed
  # user
  test_user = FactoryGirl.create :test_user
  user_two = FactoryGirl.create :user_two
  user_three = FactoryGirl.create :user_three

  # collections
  test_col = FactoryGirl.create :test_col
  test_col.admins << test_user
  test_col.save

  not_approved = FactoryGirl.create :not_approved
  not_approved.admins << test_user
  not_approved.save

  multi_image = FactoryGirl.create :multi_image
  multi_image.admins << test_user
  multi_image.save

  via = FactoryGirl.create :via
  via.admins << test_user
  via.save

  japanese = FactoryGirl.create :japanese
  japanese.admins << test_user
  japanese.save

  # collection_fields

  CollectionField.create name: 'unique_identifier', display_name: 'Unique Identifier', special: true
  CollectionField.create name: 'title', display_name: 'Title', special: true
  CollectionField.create name: 'image', display_name: 'Image', special: true
  CollectionField.create name: 'thumbnail', display_name: 'Thumbnail Image', special: true
  CollectionField.create name: 'date_start', display_name: 'Date Start', special: true
  CollectionField.create name: 'date_end', display_name: 'Date End', special: true
  CollectionField.create name: 'artist', display_name: 'Artist', special: false
  CollectionField.create name: 'topics', display_name: 'Topics', special: false

  # annotations
  jesus = FactoryGirl.create :jesus
  jesus.user = test_user
  jesus.save

  # works
  starry_night_attr = FactoryGirl.attributes_for( :starry_night )
  starry_night = crfj test_col, :starry_night
  starry_night.update_attributes( primary_color: starry_night_attr[ :primary_color ], top_colors: starry_night_attr[ :top_colors ] )
  crfj test_col, :mona_lisa

  # work with annotation
  supper = crfj test_col, :last_supper
  supper.images.first.annotations << jesus
  supper.images.first.save
  supper.save

  crfj test_col, :lucrezia
  crfj test_col, :empty_thumbnail

  crfj not_approved, :aphrodite

  crfj multi_image, :crucifixion

  # circles
  test_circle = FactoryGirl.create :test_circle
  test_circle.admin = test_user
  test_circle.users << user_two
  test_circle.collections << test_col
  test_circle.save

  circle_two = FactoryGirl.create :circle_two
  circle_two.admin = user_two
  circle_two.users << test_user
  circle_two.save

  circle_five = FactoryGirl.create :circle_five
  circle_five.admin = user_two
  circle_five.save

  circle_six = FactoryGirl.create :circle_six
  circle_six.admin = user_two
  circle_six.save

  circle_seven = FactoryGirl.create :circle_seven
  circle_seven.admin = user_three
  circle_seven.users << test_user
  circle_seven.users << user_two
  circle_seven.save

  # trays
  test_tray = FactoryGirl.create :test_tray
  test_tray.owner = test_user
  test_tray.images << Image.first
  test_tray.annotations << Annotation.first
  test_tray.save

  empty_tray = FactoryGirl.create :empty_tray
  empty_tray.owner = test_user
  empty_tray.save

  circle_tray = FactoryGirl.create :circle_tray
  circle_tray.owner = test_circle
  circle_tray.images << Work.find_by_title( 'Aphrodite Pudica' ).images.first
  circle_tray.save

  # spotlights
  test_spotlight = FactoryGirl.create :test_spotlight
  test_spotlight.user = test_user
  test_spotlight.save

  spotlight_one_priv = FactoryGirl.create :spotlight_one_priv
  spotlight_one_priv.user = test_user
  spotlight_one_priv.save

  spotlight_two_pub = FactoryGirl.create :spotlight_two_pub
  spotlight_two_pub.user = user_two
  spotlight_two_pub.save

  spotlight_two_priv = FactoryGirl.create :spotlight_two_priv
  spotlight_two_priv.user = user_two
  spotlight_two_priv.save

  spotlight_two_circle = FactoryGirl.create :spotlight_two_circle
  spotlight_two_circle.user = user_two
  spotlight_two_circle.circle = test_circle
  spotlight_two_circle.save
end

def seed_prod
  # collection_fields

  CollectionField.create name: 'unique_identifier', display_name: 'Unique Identifier', special: true
  CollectionField.create name: 'title', display_name: 'Title', special: true
  CollectionField.create name: 'image', display_name: 'Image', special: true
  CollectionField.create name: 'thumbnail', display_name: 'Thumbnail Image', special: true
  CollectionField.create name: 'date_start', display_name: 'Date Start', special: true
  CollectionField.create name: 'date_end', display_name: 'Date End', special: true
end
