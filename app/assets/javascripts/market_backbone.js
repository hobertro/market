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
            this.on("change", function(){
                console.log("model changed");
                console.log(this);
            });
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
           this.addStockItemURL();
        },
        model: Market.Models.Item,

        url:  "new",

       addStockItemURL: function(){
        this.models.forEach(function(model){
            if (model.image_url === ""){
            model.image_url = "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png";
         }
        });
       }
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
            console.log("created from search items");
        },
        addToCollection: function(data){
            this.reset([]);
            this.add(JSON.parse(data));
        },
        addStockItemURL: function(){
        this.models.forEach(function(model){
            if (model.image_url === ""){
            model.image_url = "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png";
         }
        });
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
            this.addStockItemURL();
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
            console.log(appendedItemModel);
            var appendedItemView = new Market.Views.Item({model: appendedItemModel });
            $(".highlighted").html(appendedItemView.render().el);
        },
        addStockItemURL: function(){
        this.collection.models.forEach(function(model){
            if (model.get("image_url")=== ""){
            model.set("image_url", "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png");
         }
        });
       }
    });

    Market.Views.ItemSearchCollection = Backbone.View.extend({
        tagName: 'ul',
        initialize: function(){
            $(".response").html(this.render().el);
            this.listenTo(appView, "search-item-div:click", this.addItemToSlot);
            this.listenTo(appView, "removeView:click", this.removeView);
        },
        render: function(){
            // filter through all items in a collection
            // for each, create a new view
            // render and then append to the ul (unordered list)
            this.collection.each(function(item){
                this.addStockItemURL(item);
                var ItemView = new Market.Views.SearchItem({model: item});
                this.$el.append(ItemView.render().el);
            }, this);
            console.log(this);
            return this;
        },
        addItemToSlot: function(itemId){
            var appendedItemModel = this.collection.findWhere({id: parseInt(itemId, 10)});
            var appendedItemView = new Market.Views.SearchItem({model: appendedItemModel });
            $(".highlighted").html(appendedItemView.render().el);
        },
        removeView: function(){
            this.remove();
            this.unbind();
        },
        // this method addresses the problem of the items without image urls
        addStockItemURL: function(item){
            if (item.get("image_url") === ""){
            item.set("image_url", "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png");
       }
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
            "click .search-btn": "removeView",
            "ajax:success": "createSearchCollection",
            "click #reload": "reloadItems"
        },

        addItemToSlot: function(e){
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("item-div:click", itemId); // Market.Views.ItemCollection
        },
        addSearchItemToSlot: function(e){
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("search-item-div:click", itemId);
        },
        createSearchCollection: function(e, data, status, xhr){
            var searchItems = data;
            console.log(data);
            var newSearchCollection = new Market.Collections.SearchItems(searchItems);
            var newSearchCollectionView = new Market.Views.ItemSearchCollection({collection: newSearchCollection});
        },
        // global view remover
        removeView: function(){
            this.trigger("removeView:click");
        },
        reloadItems: function(){
            var request = $.ajax({
            type: "POST",
            url: "/reload"
        });
            request.done(function(response, textStatus, jqXHR){
                // Re-render the backpack
                backpackView.unbind();
                backpackView.remove();
                backpack.reset(response) ;
                backpackView = new Market.Views.ItemCollection({collection: backpack});
            });
            request.fail(function(){
            console.log("Fail");
             });
        }
    });
})();