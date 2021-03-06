$( function() {
  var objectmap = $( '.vis-objectmap' );
  var baseThumbSize = 128;
  var thumbRequestChunk = 6;

  if ( objectmap.length === 1 ) {
    var workIds = null; //objectmap.data( 'workIds' );
    var workDimension = null; // Math.ceil( Math.sqrt( workIds.length ) );

    var paintedIndexes = [];
    var timeoutMove = null;

    var queryType = objectmap.data( 'queryType' );
    var queryId = objectmap.data( 'queryId' );

    var bigCanvas = null;
    var bigContext = null;

    var haveBg = false;
    var haveIds = false;

    var map = null;

    var miniScale = null;
    var miniSize = null;
    var miniMap = null;


    // load the ids in the background
    $.ajax( {
      url: '/thumbnails/' + queryType + '/' + queryId + '/ids.json', 
      success: function( result ) {
        workIds = result;
        if ( $.isArray( workIds ) && workIds.length > 0 ) {
          workDimension = Math.ceil( Math.sqrt( workIds.length ) );
          loadMap();
        }
      },
      error: function( ) {
        alert( 'There was an error rendering the objectmap for these works' );
      }
    } );

  }

  function loadMap( ) {
    // load the background montage
    var imgBg = new Image();

    imgBg.onload = function( ) {
      bigContext.drawImage( this, 0, 0, this.width, this.height, 0, 0, bigCanvas[0].width, bigCanvas[0].height );
      miniContext.drawImage( this, 0, 0, this.width, this.height, 0, 0, miniCanvas[0].width, miniCanvas[0].height );
      miniMap.geomap( 'refresh' );
      haveBg = true;
      setTimeout( function() { $( '#thumbsvc' ).geomap( 'refresh' ); }, 30 );
    };

    imgBg.onerror = function( ) {
      haveBg = true;
      setTimeout( function() { $( '#thumbsvc' ).geomap( 'refresh' ); }, 30 );
    };

    imgBg.src = '/thumbnails/' + queryType + '/' + queryId + '/5.jpg';


    $.geo.proj = null;

    bigCanvas = $( '<canvas width="' + (baseThumbSize * workDimension) + '" height="' + (baseThumbSize * workDimension) + '" />' );
    bigContext = bigCanvas[0].getContext( '2d' );

    bigContext.imageSmoothingEnabled = false;
    bigContext.mozImageSmoothingEnabled = false;
    bigContext.msImageSmoothingEnabled = false;

    var viewCanvas = $( '<canvas width="128" height="128" />' );
    var viewContext = viewCanvas[0].getContext( '2d' );

    var maxZoomLevels = 9;

    var center = [ Math.floor( baseThumbSize * workDimension / 2 ), Math.floor( baseThumbSize * workDimension / 2 ) ];
    var mapWidth = $( '.vis-objectmap .geomap' ).width();

    map = $( '.vis-objectmap .geomap' ).geomap( {
      bbox: [ 0, center[ 1 ] - baseThumbSize, baseThumbSize * workDimension, center[ 1 ] + baseThumbSize ],

      mode: 'click',
      cursors: {
        click: 'pointer'
      },


      axisLayout: 'image',

      zoomMax: 8,
      zoomMin: 2,

      services: [
        {
          type: 'shingled',
          id: 'thumbsvc',
          style: {
            opacity: 0.99
          },
          src: function( view ) {
            if ( !haveBg ) {
              return "";
            }

            var zoom = $( '.geomap' ).geomap('option', 'zoom');
            var factor = Math.pow( 2, maxZoomLevels - zoom - 1 );
            var imageSize = baseThumbSize / factor;

            //console.log( 'view.bbox: ' + view.bbox );

            /*
            var thumbBox = [
              Math.max( ( Math.floor( view.bbox[0] / baseThumbSize ) - 1), 0),
              Math.max( ( Math.floor( view.bbox[1] / baseThumbSize ) - 1), 0),
              Math.min( ( Math.ceil( view.bbox[2] / baseThumbSize ) ) + 1, workDimension),
              Math.min( ( Math.ceil( view.bbox[3] / baseThumbSize ) ) + 1, workDimension)
            ];

            //console.log( 'thumbBox: ' + thumbBox );

            var tileDefer = new jQuery.Deferred();
            var imageDeferreds = [];
            var workIdIndex;

            for ( var y = thumbBox[1]; y < thumbBox[3] && imageDeferreds.length < thumbRequestChunk; y++ ) {
              for ( var x = thumbBox[0]; x < thumbBox[2] && imageDeferreds.length < thumbRequestChunk; x++ ) {
                workIdIndex = y * workDimension + x;

                if ( workIdIndex < workIds.length && paintedIndexes[ workIdIndex ] === undefined ) {
                  //console.log( 'REQUEST x: ' + x + ', y: ' + y + ', index: ' + workIdIndex + ', workId: ' + workIds[ workIdIndex ] );

                  var imageDefer = new jQuery.Deferred();
                  imageDeferreds.push( imageDefer );

                  var img = new Image();
                  $( img ).data( { x: x, y: y, defer: imageDefer, workIdIndex: workIdIndex } );

                  img.onload = imageLoad;

                  img.onerror = function( ) {
                    $( this ).data( 'defer' ).resolve();
                  };

                  img.src = '/thumbnails/works/' + workIds[ workIdIndex ] + '.jpg';
                }
              }
            }

            if ( imageDeferreds.length > 0 ) {
              $.when.apply($, imageDeferreds ).then( function( ) {
                //console.log( 'refresh thumbsvc' );
                setTimeout( function() { $( '#thumbsvc' ).geomap( 'refresh' ); }, 30 );
              } );
            }
            */

            viewContext.canvas.width = view.width;
            viewContext.canvas.height = view.height;

            var scale = baseThumbSize * workDimension / factor;

            var drawX = -view.bbox[ 0 ] / factor;
            var drawY = -view.bbox[ 1 ] / factor;

            //console.log( bigCanvas[0].toDataURL( 'image/png' ) );
            viewContext.drawImage( bigCanvas[0], 0, 0, baseThumbSize * workDimension, baseThumbSize * workDimension, drawX, drawY, scale, scale );

            return viewCanvas[0].toDataURL( 'image/png' );
            //return tileDefer;
          }
        //}, {
          //id: 'highlight',
          //type: 'shingled',
          //src: ''
        }
      ],

      tilingScheme: {
        tileWidth: 256,
        tileHeight: 256,
        levels: 9,
        basePixelSize: 256,
        origin: [ 0, 0 ]
      },

      bboxchange: function( e, geo ) {
        updateMiniBbox( geo.bbox );
      },

      /*
      move: function( e, geo ) {
        // disable for now, it slows down the map
        if ( timeoutMove ) {
          clearTimeout( timeoutMove );
          timeoutMove = null;
        }

        timeoutMove = setTimeout( geomapMove( geo ), 32 );

      },
      */

      click: function( e, geo ) {
        if ( geo.coordinates[ 0 ] >= 0 && geo.coordinates[ 1 ] >= 0 && geo.coordinates[ 0 ] < bigCanvas[0].width && geo.coordinates[ 1 ] < bigCanvas[0].height ) {
          var zoom = map.geomap( 'option', 'zoom' );
          var factor = Math.pow( 2, maxZoomLevels - zoom - 1 );
          var imageSize = baseThumbSize / factor;

          var tileXY = [ Math.floor( geo.coordinates[ 0 ] / baseThumbSize ), Math.floor( geo.coordinates[ 1 ] / baseThumbSize ) ];

          var index = tileXY[1] * workDimension + tileXY[0];

          if ( index < workIds.length ) {
            $.get( '/works/' + workIds[ index ], function( popupHtml ) {
              $.magnificPopup.open( {
                showCloseBtn: false,
                items: {
                  src: popupHtml,
                  type: 'inline'
                }
              } );
            } );
          }
        }
      }
    } );

    //var highlight = $( '#highlight' );


    function geomapMove( geo ) {
      if ( geo.coordinates[ 0 ] >= 0 && geo.coordinates[ 1 ] >= 0 && geo.coordinates[ 0 ] < bigCanvas[0].width && geo.coordinates[ 1 ] < bigCanvas[0].height ) {
        // TODO: cache factor somewhere, it only changes when zoom changes
        var zoom = map.geomap( 'option', 'zoom' );
        var factor = Math.pow( 2, maxZoomLevels - zoom - 1 );
        var imageSize = baseThumbSize / factor;

        var tileXY = [ Math.floor( geo.coordinates[ 0 ] / baseThumbSize ), Math.floor( geo.coordinates[ 1 ] / baseThumbSize ) ];

        highlight.geomap( 'empty', false );

        var pixelBbox = [ tileXY[ 0 ] * baseThumbSize, tileXY[ 1 ] * baseThumbSize, tileXY[ 0 ] * baseThumbSize + baseThumbSize, tileXY[ 1 ] * baseThumbSize + baseThumbSize ];

        highlight.geomap( 'append', $.geo.polygonize( pixelBbox ) );
      } else {
        highlight.geomap( 'empty' );
      }
    }

    var miniCanvas = $( '<canvas width="128" height="128" />' );
    var miniContext = miniCanvas[0].getContext( '2d' );

    miniContext.imageSmoothingEnabled = false;
    miniContext.mozImageSmoothingEnabled = false;
    miniContext.msImageSmoothingEnabled = false;

    miniScale = 1 / workDimension;
    miniSize = baseThumbSize * miniScale;

    //console.log( '[minimap], workDimension: ' + workDimension + ', miniScale: ' + miniScale + ', miniSize: ' + miniSize + ', baseThumbSize:' + baseThumbSize );

    miniMap = $( '.vis-objectmap .minimap' ).geomap( {
      bbox: [ 0, 0, baseThumbSize, baseThumbSize ],
      bboxMax: [ 0, 0, baseThumbSize, baseThumbSize ],

      mode: 'static',

      services: [
        {
          type: 'shingled',
          src: function( view ) {
            return miniContext.canvas.toDataURL( 'image/png' );
          },
          style: {
            opacity: .98
          }
        }
      ],

      tilingScheme: null,

      shapeStyle: {
        color: '#d2232a'
      }
    } );

    miniMap.click( function( e ) {
      map.geomap( 'option', 'center', [ e.offsetX / miniSize / 2 * baseThumbSize, e.offsetY / miniSize / 2 * baseThumbSize ] );
      updateMiniBbox();
    } );

    updateMiniBbox();

    $( '.commands .btn' ).click( function( ) {
      map.geomap( 'zoom', $( this ).data( 'zoom' ) );
      updateMiniBbox();
    } );

    function imageLoad( ) {
      var $this = $( this );
      bigContext.drawImage( this, 0, 0, this.width, this.height, $this.data( 'x' ) * baseThumbSize, $this.data( 'y' ) * baseThumbSize, baseThumbSize * (this.width/150), baseThumbSize * (this.height/150));

      paintedIndexes[ $this.data( 'workIdIndex' ) ] = true;

      //miniContext.drawImage( img, xMini, yMini, miniSize, miniSize );
      //miniMap.geomap( 'refresh' );

      thisDefer = $this.data( 'defer' );
      if ( thisDefer ) {
        thisDefer.resolve();
      }
    }

    function updateMiniBbox( bbox ) {
      bbox = bbox || map.geomap( 'option', 'bbox' );

      var miniBbox = [
        Math.min( Math.max( bbox[0] * miniScale, 0 ), baseThumbSize ),
        baseThumbSize - Math.min( Math.max( bbox[1] * miniScale, 0 ), baseThumbSize ),
        Math.min( Math.max( bbox[2] * miniScale, 0 ), baseThumbSize ),
        baseThumbSize - Math.min( Math.max( bbox[3] * miniScale, 0 ), baseThumbSize )
      ]; 
      miniMap.geomap( 'empty' ).geomap( 'append', $.geo.polygonize( miniBbox ) );
    }
  }
} );
