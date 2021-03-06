require 'spec_helper'

describe ( TraysController ) {
  let ( :user ) { User.first }

  context ( 'with anonymous' ) {
    describe ( 'GET users/:id/trays.json') {
      it ( 'should request authentication' ) {
        pending 'auth currently disabled until realm is fixed'
        get :index, user_id: user.id, format: :json
        response.code.should eq( '401' )
        response.header[ 'WWW-Authenticate' ].should eq( 'Negotiate' )
      }
    }
  }

  context ( 'with user' ) {
    before {
      controller.login_browserid user.email 
    }

    describe ( 'GET users/:id/trays' ) {
      it ( 'should return ok' ) {
        get :index, user_id: user.id
        response.code.should eq( '200' )
      }

      it ( 'should return ok' ) {
        get :index, user_id: user.id
        assigns( :trays ).count.should == 3 # two owned, one from circle
      }
    }

    describe ( 'GET users/:id/trays.json' ) {
      it ( 'should return ok' ) {
        get :index, user_id: user.id, format: :json
        response.code.should eq( '200' )
      }
    }

    describe ( "GET another users' trays.json" ) {
      let ( :user_two ) { User.last }

      it  {
        get :index, user_id: user_two.id, format: :json
        pending "response.code.should eq( '403' )"
      }
    }

    after {
      controller.logout_browserid
    }
  }
}

