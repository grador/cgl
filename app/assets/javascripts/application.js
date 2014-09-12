// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui/effect-blind
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on('page:change', function ()
{   var stick = $('#sticker');
    var mot = $('#chword');
    var help = $('#help');
    var menu = $('.menu');

    help.css('left', '10px');
    menu.css('left', '-220px');
    stick.css('left','-1px');

    stick.bind('click', function(){
        if(mot.text() == 'ОТКРЫТЬ'){
            help.animate({left: '-220px'}, 400);
            menu.animate({left: '-46px'}, 400);
            mot.text('ЗАКРЫТЬ');
        }
        else{
            help.animate({left: '10px'}, 400);
            menu.animate({left: '-220px'}, 400);
            mot.text('ОТКРЫТЬ');
        }
    });
    stick.bind('mouseover', function(){
        stick.css('color','#876edb').css('left','1px');
    });
    stick.bind('mouseout', function(){
        stick.css('color','#660c24').css('left','-1px');
    });
});
