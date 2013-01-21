//= require jquery_ujs
//= require jquery
//= require_tree .
//= require twitter/bootstrap
//= require bootstrap-wysihtml5

$(document).ready(function(){
    $('#comment-textarea').wysihtml5({
        "font-styles": true, //Font styling, e.g. h1, h2, etc. Default true
        "emphasis": true, //Italics, bold, etc. Default true
        "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
        "html": true, //Button which allows you to edit the generated HTML. Default false
        "link": true, //Button to insert a link. Default true
        "image": false, //Button to insert an image. Default true,
        "color": true //Button to change color of font
    });
})

$(document).ready(function(){
    $('.dropdown-toggle').dropdown();
})

$(document).ready(function(){
    $("#NewEventModal").modal()
})

$(document).ready(function(){
    $("#NewAttachmentModal").modal()
})

$(document).ready(function(){
    $("#NewTaskModal").modal()
})

$(document).ready(function(){
    $("#NewCalendarModal").modal()
})


$(document).ready(function(){
    $(".collapse").collapse()
})

