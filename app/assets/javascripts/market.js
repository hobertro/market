(function(){
    $('.item').click(function(e){
        // get item model
    var test = $('.items-offered').append($(this));
        // add to .items-wanted class
        e.preventDefault();
        // create ajax function to send data from .items-wanted class to server
    });

    // get data item id

    $("#test").click(function(e){
        var userID = $(".user-data").attr("data-user-id");
        var data = $('.items-offered > .item');
        var itemsOffered = [];

        var special = data.each(function(x){
            itemsOffered.push($(this).attr("data-item-id"));
        });

        var request = $.ajax({
            type: "POST",
            url: "/users/13/user_listings/",
            data: {"offer": JSON.stringify(itemsOffered), "user_current_id": userID}
        });

        request.done(function(response, textStatus, jqXHR){
            console.log("It worked!");
            $('.response').append(response);
        });
       e.preventDefault();
    });

    function jsonStringify(argument){
        if (argument.class === "Object"){
            alert("object");
        }
        else if (argument.class == "Array"){
            alert("array");
        } else {
            alert("every thing else");
        }
    }
})();

// After user clicks on the item, it recreates the item in the items-wanted box

