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
       
    },

});

/*** Collections ***/

Market.Collections.Item = Backbone.Collection.extend({
    initialize: function(){
        
    },
    model: Market.Models.Item,
    url:  "new",
});



/*** Views ***/

Market.Views.Item = Backbone.View.extend({

    tagName: "li",
    className: "item-div",

    itemTemplate: _.template("<a href='/items/<%= item_id %>'><img class='item-img' src='<%= image_url %>''></a>"),

    render: function(){
        this.$el.html(this.itemTemplate(this.model.toJSON()));
        return this;
    },
    attributes: function(){
        return {
            'id': this.model.get("item_id"),
            'data-name': this.model.get("name"),
            'data-defindex': this.model.get("defindex")
        };
    },
});

Market.Views.ItemCollection = Backbone.View.extend({
    tagName: 'ul',
    initialize: function(){
        $(".backpack").html(this.render().el);
    },
    render: function(){
        // filter through all items in a collection
        // for each, create a new view
        // render and then append to the ul (unordered list)
        this.collection.each(function(person){
            var ItemView = new Market.Views.Item({model: person});
            this.$el.append(ItemView.render().el);
        }, this);
        return this;
    }
});

})();