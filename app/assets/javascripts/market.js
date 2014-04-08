(function(){

    // get data item id

    /* Creating an listing function */
    $(".super-form").submit(function(e){
        console.log("begin");
        var userID = $(".user-data").attr("data-user-id");
        var itemsOfferedArray = $('.items-offered .item-li');
        var itemsWantedArray = $('.items-wanted .search-item-li');
        var notes = $(".notes-input").val();
        var itemsOffered = [];
        var itemsWanted = [];

        itemsOfferedArray.each(function(x){
            // validation
            itemsOffered.push($(this).attr("id"));
            console.log(itemsOfferedArray);
            console.log("pushed from offered array");
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

                /*
        var request = $.ajax({
            type: "POST",
            url: "../user_listings",
            data: {"offer": JSON.stringify(itemsOffered),
                   "wanted": JSON.stringify(itemsWanted)}
        });

        request.done(function(response, textStatus, jqXHR){
            console.log("It worked!");
            $('.response').append(response);
        });
       e.preventDefault();
       */
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

    $(".items-offered .item-slot").hover(function(){
        checkButtonStatus();
    });

    $(".items-wanted .item-slot").hover(function(){
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
            console.log("It worked!");
        });
       e.preventDefault();
    });

    $(".note-btn").click(function(e){
        console.log("in note btn");
        console.log($(this).parent().parent().parent());
        $(this).parent().parent().parent().find(".note-section").toggle();
        e.preventDefault();
    });

    $(".main-note-btn").click(function(e){
        $(this).parent().parent().parent().parent().find(".note-section").toggle();
        e.preventDefault();
    });

    $("li").tooltip('hide');

    var checkButtonStatus = function(){
        var itemsOffered = $(".items-offered .item-slot");
        var itemsWanted = $(".items-wanted .item-slot");
            if (itemsOffered.children().size() > 0 && itemsWanted.children().size() > 0 ) {
                $(".submit-button").removeClass("disabled");
            } else {
                $(".submit-button").addClass("disabled");
            }
    };

})();