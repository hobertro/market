(function(){

// For namespacing

window.Market = {
    Models: {},
    Collections: {},
    Views: {}
};

/*** Models ***/

Market.Models.Item = Backbone.Model.extend({

    initialize: function(){
        console.log("Item modle initialized");
    },

    defaults: {
        name: "",
        imgURL: "",
        itemID: "",
        equipped: "",
    }
});

/*** Collections ***/



/*** Views ***/

})();
