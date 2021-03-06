require 'spec_helper'

describe ( 'works/show_xhr' ) {
  subject { rendered }

  let ( :work ) { Work.first }

  before {
    assign( :work, work )
    assign( :owner, User.first )
    assign( :trays, User.first.trays )
    assign( :popup_action, 'add' )
    assign( :popup_action_type, 'Image' )
    assign( :popup_action_item_id, work.images.first.id )

    assign( :current_metadata, work.parsed )
    
    render template: 'works/show_xhr', layout: false
  }

  it {
    should have_css 'h1', visible: false
  }

  it {
    should_not have_css '.GLOBAL_MENU'
  }

  it {
    should have_css '.parsed-info'
  }

  it {
    should have_css '.work-image'
  }

  it {
    should have_css %Q|.work-image[data-action-item-type="Image"]|
  }

  it {
    should have_css %Q|.work-image[data-action-item-id="#{work.images.first.id}"]|
  }

  it {
    should have_css '.work-image .work-commands'
    should_not have_css ".work-commands a.tray"
    should have_css ".work-commands a[href*='#{work_path work}'].show"
    should have_css '.work-commands a.close'
  }

  it {
    should have_css '.work-image img'
  }

  it {
    should have_css '.surrogates'
  }

  it {
    should have_css '.surrogates a'
  }

  it {
    should have_css '.surrogates a img'
  }

  context ( 'with signed in user' ) {
    let ( :user ) { User.first }

    before {
      session[ :browserid_email ] = user.email
      assign( :current_user, user )

      render template: 'works/show_xhr', layout: false
    }

    it {
      should have_css ".work-commands a.tray"
    }
  }
}
