(function(){

// For namespacing

    window.Market = {
        Models: {},
        Collections: {},
        Views: {}
    };

    /****************** Models *********************/

    Market.Models.Item = Backbone.Model.extend({

        initialize: function(){
        
        }
    });

    Market.Models.ItemSlot = Backbone.Model.extend({

        initialize: function(){
            console.log("ItemSlot initialized");
            
        },

        defaults: {
            selectedValue: false
        },
        // change target model.selectedValue to true
        toggleSelect: function(){
            this.collection.allModelsFalse();
            this.set("selectedValue", !this.get("selectedValue"));
        },
        setToFalse: function(){
            this.set("selectedValue", false);
        }

    });

    /***************** Collections ******************/

    Market.Collections.Item = Backbone.Collection.extend({

        initialize: function(){
           
        },
        model: Market.Models.Item,

        url:  "new",
    });

    Market.Collections.ItemSlots = Backbone.Collection.extend({

        // create item slots on load

        initialize: function(){
           this.createItemSlots();
        },

        model: Market.Models.ItemSlot,

        createItemSlots: function(){

                // create 12 models

            for(i=0; i<6; i++){
                modelitemSlot = new Market.Models.ItemSlot();
                this.add(modelitemSlot);
            }
        },
        allModelsFalse: function(){
            this.models.forEach(function(model){
                model.setToFalse();
            });
        }
    });

    Market.Collections.SearchItems = Backbone.Collection.extend({

        model: Market.Models.Item,

        initialize: function(){
            this.listenTo(appView, "createSearchCollection", this.addToCollection);
        },
        addToCollection: function(data){
            this.reset([]);
            this.add(JSON.parse(data));
        }
    });



    /********************* Views ************************/

    Market.Views.Item = Backbone.View.extend({

        tagName: "li",
        className: "item-div",

        initialize: function(){
                
        },

        events: {
            "click": "addItemToSlot"
        },

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
        }
    });

    Market.Views.SearchItem = Backbone.View.extend({

        tagName: "li",
        className: "search-item-div",

        initialize: function(){

        },

        itemTemplate: _.template("<a href='/items/<%= id %>'><img class='item-img' src='<%= image_url %>''></a>"),

        render: function(){
            this.$el.html(this.itemTemplate(this.model.toJSON()));
            return this;
        },
        attributes: function(){
            return {
                'id': this.model.get("id"),
                'data-name': this.model.get("name"),
                'data-defindex': this.model.get("defindex")
            };
        }
    });



    Market.Views.ItemCollection = Backbone.View.extend({
        tagName: 'ul',
        initialize: function(){
            $(".backpack").html(this.render().el);
            this.listenTo(appView, "item-div:click", this.addItemtoSlot);
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
        },
        addItemtoSlot: function(itemId){
            // change itemId to a number
            var appendedItemModel = this.collection.findWhere({item_id: parseInt(itemId, 10)});
            var appendedItemView = new Market.Views.Item({model: appendedItemModel });
            $(".highlighted").html(appendedItemView.render().el);
        }
    });

    Market.Views.ItemSearchCollection = Backbone.View.extend({
        tagName: 'ul',
        initialize: function(){
            console.log("search collection initialized");
            $(".response").html(this.render().el);
            this.listenTo(appView, "search-item-div:click", this.addItemToSlot);
        },
        render: function(){
            // filter through all items in a collection
            // for each, create a new view
            // render and then append to the ul (unordered list)
            this.collection.each(function(person){
                var ItemView = new Market.Views.SearchItem({model: person});
                this.$el.append(ItemView.render().el);
            }, this);
            return this;
        },
        addItemToSlot: function(itemId){

            console.log(itemId);
            console.log(this.collection);
            var appendedItemModel = this.collection.findWhere({id: parseInt(itemId, 10)});
            console.log(appendedItemModel);
            var appendedItemView = new Market.Views.SearchItem({model: appendedItemModel });
            $(".highlighted").html(appendedItemView.render().el);
        }
    });

    Market.Views.ItemsWantedCollection = Backbone.View.extend({
        tagName: 'ul',
        initialize: function(){
           $(".items-offered").html(this.render().el);
        },
        render: function(){
            this.collection.each(function(itemslot){
                itemSlotView = new Market.Views.ItemSlot({model: itemslot});
                this.$el.append(itemSlotView.render().el);
            }, this);

            return this;
        }
    });

    Market.Views.ItemsOfferedCollection = Backbone.View.extend({
        tagName: 'ul',
        initialize: function(){
           $(".items-wanted").html(this.render().el);
        },
        render: function(){
            this.collection.each(function(itemslot){
                itemSlotView = new Market.Views.ItemSlot({model: itemslot});
                this.$el.append(itemSlotView.render().el);
            }, this);
            // filter through all items in a collection
            // for each, create a new view
            // render and then append to the ul (unordered list)
            return this;
        }
    });

    Market.Views.ItemSlot = Backbone.View.extend({

        tagName: "li",

        className: "item-slot",

        initialize: function(){

        },

        render: function(){

            return this;
        },
        events: {
            "click": "modelClick",
        },
        modelClick: function(e){
            e.preventDefault();
            this.model.toggleSelect();
        }
    });

    // global view

    Market.Views.App = Backbone.View.extend({

        el: "#market",

        initialize: function(){
            
        },

        events: {
            "click .item-div": "addItemToSlot",
            "click .search-item-div": "addSearchItemToSlot",
            "ajax:success": "createSearchCollection"
        },

        addItemToSlot: function(e){
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("item-div:click", itemId);
        },
        addSearchItemToSlot: function(e){
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("search-item-div:click", itemId);
        },
        createSearchCollection: function(e, data, status, xhr){
            this.trigger("createSearchCollection", data);
        }
    });
})();