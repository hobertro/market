(function(){

    // get data item id
    
    $('[data-toggle="tooltip"]').tooltip({'placement': 'bottom'});

    var checkButtonStatus = function(){
        var itemsOffered = $(".items-offered .item-slot");
        var itemsWanted = $(".items-wanted .item-slot");
            if (itemsOffered.children().size() > 0 && itemsWanted.children().size() > 0 ) {
                $(".submit-button").removeClass("disabled");
            } else {
                $(".submit-button").addClass("disabled");
            }
    };

    $(".response").hover(function(){
        checkButtonStatus();
    });

    /* Creating an listing function */
    $(".super-form").submit(function(e){
        var userID = $(".user-data").attr("data-user-id");
        var itemsOfferedArray = $('.items-offered .item-li');
        var itemsWantedArray = $('.items-wanted .search-item-li');
        var notes = $(".notes-input").val();
        var itemsOffered = [];
        var itemsWanted = [];

        itemsOfferedArray.each(function(x){
            // validation
            itemsOffered.push($(this).attr("id"));
        });

        itemsWantedArray.each(function(x){
            // validation
        itemsWanted.push($(this).attr("id"));

        });

        var offer = JSON.stringify(itemsOffered);
        var wanted = JSON.stringify(itemsWanted);

        $("#offer").val(offer);
        $("#wanted").val(wanted);
        $("#listnote").val(notes);
    });

    $(".item-slot").click(function(){
        $(".item-slot").removeClass("highlighted");
        $(this).toggleClass("highlighted");
    });

// User Listings 

    $(".items-offered .item-slot").click(function(){
        if ($(this).hasClass("items-searched")){
            return;
        } else {
            $(".search-main").fadeOut();
            $(".backpack-section").fadeIn();
        }
    });

    $(".selection-menu").hover(function(){
        checkButtonStatus();
    });


    $(".items-wanted .item-slot").click(function(){
        if ($(this).hasClass("items-searched")){
            return;
        } else {
            $(".search-main").fadeIn();
            $(".backpack-section").fadeOut();
        }
    });



    // Redo Javascript below in backbone file

    $(".listing-button").click(function(){
        $(this)
            .parent()
                .parent()
                    .find(".listing-notes")
                        .toggle();
    });


    $(".comment-button").click(function(){
        $(this)
            .parent()
                .parent()
                    .parent()
                    .find(".listing-comments")
                        .toggle();
    });

    $(".comment-btn").click(function(e){
        console.log("clicked!");

        var request = $.ajax({
            type: "POST",
            url: "/comments",
            data: {comment: $(".comment-box").val()}
        });

        request.done(function(response, textStatus, jqXHR){
        });
       e.preventDefault();
    });
/*
    $(".mark-btn").click(function(e){
        var messageID = $(this).parent().parent().parent().parent().data("message-id");
        console.log("clicked!");
        var request = $.ajax({
            type: "POST",
            url: "/message_marked_as_read",
            data: {message_id: messageID}
        });

        request.done(function(response, textStatus, jqXHR){
                
        });
        e.preventDefault();
    });
*/
    $(".note-btn").click(function(e){
        $(this).parent().parent().parent().find(".note-section").toggle();
        e.preventDefault();
    });

    $(".main-note-btn").click(function(e){
        $(this).parent().parent().parent().parent().find(".note-section").toggle();
        e.preventDefault();
    });

    $("li").tooltip('hide');

    $('[data-toggle="tooltip"]').tooltip({'placement': 'bottom'});
    
    $(".search-btn").submit(function(){
        alert("submitted!");
    });

    $('body').tooltip({
     selector: '[rel=tooltip]'
    });

    $(".goodbye").fadeOut(7500);

    $(".user-listings-btn").click(function(){
        $(".user-backpack-items").fadeOut();
        $(".user-backpack-listings").fadeIn();
        $(".user-items-btn").removeClass("active");
        $(".user-listings-btn").addClass("active");
    });

    $(".user-items-btn").click(function(){
        $(".user-backpack-listings").fadeOut();
        $(".user-backpack-items").fadeIn();
        $(".user-listings-btn").removeClass("active");
        $(".user-items-btn").addClass("active");
    });


    // Users Edit Section

    $(".blocked-user-btn").click(function(e){
        e.preventDefault();
        $(".trade-url-section").fadeOut();
        $(".block-user-section").fadeIn();
    });
    $(".trade-url-btn").click(function(e){
        e.preventDefault();
        $(".block-user-section").fadeOut();
        $(".trade-url-section").fadeIn();
    });
})();