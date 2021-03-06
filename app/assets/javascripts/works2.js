$( function() {
  $( '.works.index' ).on( 'click', '.show-xhr .work-commands .show,.show-xhr .surrogates a', function() {
    window.open( $( this ).attr( 'href' ) );
    return false;
  } );

  $( '.works.index' ).on( 'click', '.show-xhr .close', function() {
    $.magnificPopup.instance.close();
    return false;
  } );

  if ( $( '.works.show' ).length ) {
    $( '.works.show' ).on( 'click', '.nav-works a', function( ) {
      var panel = $( '#panel-' + $( this ).data( 'panel' ) );
      if ( panel.is( ':visible' ) ) {
        panel.hide();
      } else {
        $( '.panel-work' ).hide();
        panel.show();
      }
      return false;
    } );

    $( '.works.show' ).on( 'ajax:success', '.edit_work_set_cover', function( xhr, result ) {
      $( this ).replaceWith( result );
    } );

    $( window ).resize( function() {
      var xs = $(this).width() < 768;
      $( '.nav-works' ).toggleClass( 'nav-stacked', !xs );
      $( '.footer' ).toggleClass( 'hidden', xs );
    } ).trigger('resize');

    // geomap
    $.geo.proj = null;

    var haveImage = false;
    var showAnnotations = true;
    var timeoutMove = null;

    var img = new Image();
    img.onload = function( ) {
      haveImage = true;
      var bboxMax = [ 0, 0, img.width, img.height ];
      $( '.work-canvas' ).geomap( 'option', 'bboxMax', bboxMax );
      setTimeout( function( ) { $( '.work-canvas' ).geomap( 'option', 'bbox', bboxMax ); }, 30 );
    };
    img.crossOrigin = 'anonymous';
    img.src = $('.work-canvas').data( 'imageUrl' );

    var viewCanvas = $( '<canvas width="128" height="128" />' );
    var viewContext = viewCanvas[0].getContext( '2d' );

    var map = $( '.work-canvas' ).geomap( {
      bboxMax: [ 0, 0, 128, 128 ],
      axisLayout: 'image',
      tilingScheme: null,
      services: [ {
        type: 'shingled',
        src: function( view ) {
          if ( !haveImage ) {
            return '';
          }

          viewContext.canvas.width = view.width;
          viewContext.canvas.height = view.height; 
          viewContext.drawImage( img, view.bbox[0], view.bbox[1], $.geo.width( view.bbox ), $.geo.height( view.bbox ), 0, 0, view.width, view.height );

          return viewCanvas[0].toDataURL( 'image/png' );
        },
        style: {
          opacity: 0.99
        }
      }, {
        type: 'shingled',
        src: '',
        id: 'annotations-service'
      }, {
        type: 'shingled',
        src: '',
        id: 'annotations-popup'
      } ],

      move: function( e, geo ) {
        if ( timeoutMove ) {
          clearTimeout( timeoutMove );
          timeoutMove = null;
        }

        if ( showAnnotations ) {
          timeoutMove = setTimeout( function( ) {
            var annotations = annotationsService.geomap( 'find', geo, 1 );

            if ( annotations.length ) {
              var popupHtml = '<ul class="media-list media-list-annotations">';
              $.each( annotations, function( ) {
                popupHtml += $( '#' + this.properties.id ).html();
              } );
              popupHtml += '</ul>';

              //var position = map.geomap( 'toPixel', geo.coordinates );
              annotationsPopup.geomap( 'empty', false ).geomap( 'append', geo, popupHtml );
            } else {
              annotationsPopup.geomap( 'empty' );
            }
          }, 334 );
        }
      },

      shape: function( e, geo ) {
        map.geomap( 'option', 'mode', 'pan' );
        $( '.btn-drag-annotation' ).button( 'toggle' );

        $( '.crosshair-tool-info' ).remove();

        var annotationPreview = $( '#annotation_preview' );

        //
        // 1. scale thumbnail to 150 in longest dimension
        // 2. draw thumbnail onto canvas
        // 3. save canvas dataURL to thumbnailUrl
        //

        // a kludge until I fix bbox in image service events
        
        var dwidth = swidth = $.geo.width( geo.bbox );
        var dheight = sheight = - $.geo.height( geo.bbox );

        if (swidth > sheight) {
          dwidth = 150;
          dheight *= (150 / swidth );
        } else {
          dwidth *= ( 150 / sheight );
          dheight = 150;
        }

        // populate hidden form fields
        $( '#annotation_x' ).val( Math.floor( geo.bbox[0] ) );
        $( '#annotation_y' ).val( Math.floor( geo.bbox[1] - sheight ) );
        $( '#annotation_width' ).val( Math.ceil( swidth ) );
        $( '#annotation_height' ).val( Math.ceil( sheight ) );

        var annotationCanvas = annotationPreview.find( 'canvas' )[0];
        var annotationContext = annotationCanvas.getContext( '2d' );

        annotationContext.clearRect( 0, 0, 150, 150 );
        annotationContext.drawImage( img, geo.bbox[0], geo.bbox[1] - sheight, swidth, sheight, ( 150 - dwidth ) / 2, ( 150 - dheight ) / 2, dwidth, dheight );

        $( '#annotation_image_url' ).val( $('.work-canvas').data( 'workImageUrl' ) );
        $( '#annotation_thumbnail_url' ).val( annotationCanvas.toDataURL() );

        $( '.panel-work' ).hide();
        $( '#panel-annotations' ).show();
      }
    } );

    var annotationsService = $( '#annotations-service' );
    var annotationsPopup = $( '#annotations-popup' );

    $( '.media-list-annotations .media' ).each( function( ) {
      var $this = $( this );
      var bbox = $this.data( 'bbox' );
      annotationsService.geomap( 'append', {
        type: 'Feature',
        geometry: $.geo.polygonize( bbox ),
        properties: {
          id: $this.attr( 'id' )
        }
      } );
    } );

    $( '.btn-drag-annotation' ).click( function( ) {
      $( '.panel-work' ).hide();
      map.geomap( 'option', 'mode', 'dragBox' );
    } );

    $( '#annotations-show' ).click( function( ) {
      showAnnotations = $( this ).is( ':checked' );
      annotationsService.geomap( 'toggle', showAnnotations );
      annotationsPopup.geomap( 'empty' );
    } );
  }
} );
