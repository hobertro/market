(function(){


    // get data item id


    /* Creating an listing function */

    $(".super-form").submit(function(e){
        console.log("begin");
        var userID = $(".user-data").attr("data-user-id");
        var itemsOfferedArray = $('.items-offered .item-div');
        var itemsWantedArray = $('.items-wanted .search-item-div');
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
        $(this).siblings().removeClass("highlighted");
        $(this).toggleClass("highlighted");
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

})();