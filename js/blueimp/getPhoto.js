$(function () {
    'use strict';

    // Load images from flickr:
    // ID:hitit2014
    // PW:Wjstks113112
    
    $.ajax({
        url: (window.location.protocol === 'https:' ?
                'https://secure' : 'http://api') +
                '.flickr.com/services/rest/',
        data: {
            format: 'json',
//            method: 'flickr.interestingness.getList',
            method: 'flickr.photos.search',
            user_id: '124940484@N05',
            per_page:'100',
            page:'1',
            api_key: '7617adae70159d09ba78cfec73c13be3' // jshint ignore:line
        },
        dataType: 'jsonp',
        jsonp: 'jsoncallback'
    }).done(function (result) {
        var carouselLinks = [],
            linksContainer = $('#links'),
            baseUrl;
        // Add the demo images as links with thumbnails to the page:
        $.each(result.photos.photo, function (index, photo) {
            baseUrl = 'http://farm' + photo.farm + '.static.flickr.com/' +
                photo.server + '/' + photo.id + '_' + photo.secret;
            $('<a/>')
                .append($('<img>').prop('src', baseUrl + '_s.jpg'))
                .prop('href', baseUrl + '_b.jpg')
                .prop('title', photo.title)
                .attr('data-gallery', '')
                .appendTo(linksContainer);
            carouselLinks.push({
                href: baseUrl + '_c.jpg',
                title: photo.title
            });
        });
        // Initialize the Gallery as image carousel:
        blueimp.Gallery(carouselLinks, {
            container: '#blueimp-image-carousel',
            carousel: true
        });
    });

});
