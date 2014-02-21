(function(){


    // get data item id


    /* Creating an listing function */

    $("#test").click(function(e){
        var userID = $(".user-data").attr("data-user-id");
        var itemsOfferedArray = $('.items-offered .item-div');
        var itemsWantedArray = $('.items-wanted .item-div');
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

    // ajax request to the server

        /* Have to figure out how to make the URLs dynamic */

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
    });

    /* End of creating a listing function */

    //Function to add classes to the item-slots

    $(".item-slot").click(function(){
        if ($(this).hasClass("highlighted")){
            alert("works");
        }
        $(this).toggleClass("highlighted");
    });

    // For .highlighted class


    // Function to add clicked item to the item-slot
    $(".item-div").click(function(e){
       e.preventDefault();
       var clone = $(this).clone();
       $(".highlighted").html(clone).toggleClass("highlighted");
    });

    

    // Backbone

})();