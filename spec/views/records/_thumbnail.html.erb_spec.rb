require 'spec_helper'

describe ( 'records/thumbnail' ) {
  subject { rendered }

  context ( 'normal work' ) {
    let ( :work ) { Work.first }

    before {
      assign( :work, work )
      render 'records/thumbnail', thumbnail: work
    }

    it {
      should have_css "a"
    }

    it {
      should have_css "a[href*='#{record_path work}']" 
    }

    it {
      should have_css "a[title='#{work.title}']"
    }
  }
}
