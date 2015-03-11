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
            });
            this.addStockItemURL();
        },
        addStockItemURL: function(){
            if(this.get("image_url") === "" || this.get("image_url" === null)){
                this.set("image_url", "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png");
            }
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

    Market.Collections.Item = Backbone.Collection.extend({ // Collection only

        initialize: function(){
           this.addStockItemURL();
        },
        model: Market.Models.Item,

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

            // this.listenTo(appView, "createSearchCollection", this.addToCollection);

        }/*,
        addToCollection: function(data){
            this.reset([]);
            console.log("in add to collection");
            console.log(data);
            console.log("in add data");
            this.add(JSON.parse(data));
        }*/
    });

    /********************* Views ************************/

    Market.Views.Item = Backbone.View.extend({

        tagName: "li",
        className: "item-li item thumbnail",

        initialize: function(){
            
        },

        events: {
            "click": "addItemToSlot"
        },

        itemTemplate: _.template("<a href='/items/<%= id %>'><img class='item-img' src='<%= image_url %>''></a>"),

        render: function(){
            this.$el.addClass(this.model.get("rarity")).html(this.itemTemplate(this.model.toJSON()));
            return this;
        },
        attributes: function(){
            return {
                'id': this.model.get("id"),
                'data-name': this.model.get("name"),
                'data-defindex': this.model.get("defindex"),
                'data-toggle': "tooltip",
                'data-placement': "bottom",
                'title': this.capitalize(this.model.get("rarity")) + " " + this.model.get("name"),
                'data-id': this.model.get("id")
                //'data-rarity': this.model.get("rarity") || "common",
            };
        },
        capitalize: function(string){
            if (string === null){
                return "Common";
            } else {
                return string.charAt(0).toUpperCase() + string.slice(1);
            }
        },
        addTrashCan: function(){

        }
    });

    Market.Views.SearchItem = Market.Views.Item.extend({
        className: "search-item-li item thumbnail",
        initialize: function(){
            console.log("search item created");
        }
    });

    Market.Views.BackpackItem = Market.Views.Item.extend({
        itemTemplate: _.template("<a href='/items/<%= item_id %>'><img class='item-img' src='<%= image_url %>''></a>"),
        attributes: function(){
            return {
                'id': this.model.get("item_id"),
                'data-name': this.model.get("name"),
                'data-defindex': this.model.get("defindex"),
                'data-toggle': "tooltip",
                'data-placement': "bottom",
                'title': this.capitalize(this.model.get("rarity")) + " " + this.model.get("name"),
                'data-id': this.model.get("item_id")
            };
        },
    });

    Market.Views.ItemCollection = Backbone.View.extend({ // Backpack items view
        tagName: 'ul',
        className: "clearfix",
        initialize: function(){
            $(".backpack").html(this.render().el);
            this.listenTo(appView, "item-li:click", this.addItemtoSlot);
        },
        render: function(){
            this.addStockItemURL();
            // filter through all items in a collection
            // for each, create a new view
            // render and then append to the ul (unordered list)
            // populate backpack
            this.collection.each(function(person){
                console.log("in item collection");
                var ItemView = new Market.Views.Item({model: person}); // Individual item view
                this.$el.append(ItemView.render().el);
            }, this);
            return this;
        },
        addItemtoSlot: function(itemId){
            // change itemId to a number
            var appendedItemModel = this.collection.findWhere({item_id: parseInt(itemId, 10)});
            var appendedItemView = new Market.Views.BackpackItem({model: appendedItemModel }); //Market.Views.Item line 113
                this.addHighlightToNextClass(appendedItemView);
        },
        addStockItemURL: function(){
        this.collection.models.forEach(function(model){
            if (model.get("image_url") === ""){
            model.set("image_url", "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png");
         }
        });
        },
        addHighlightToNextClass: function(appendedItemView){
            $(".highlighted").html(appendedItemView.render().el);
            var that = $(".highlighted").next();
            if ($(".highlighted").hasClass("last-slot")){
                $(".highlighted").removeClass("highlighted");
                $(".item-slot").siblings().first().addClass("highlighted");
            } else {
                $(".highlighted").removeClass("highlighted");
                that.addClass("highlighted");
            }
        }
    });

     Market.Views.BackpackItemCollection = Market.Views.ItemCollection.extend({
        render: function(){
            this.addStockItemURL();
            // filter through all items in a collection
            // for each, create a new view
            // render and then append to the ul (unordered list)
            // populate backpack
            this.collection.each(function(person){
                var ItemView = new Market.Views.BackpackItem({model: person}); // Individual item view
                this.$el.append(ItemView.render().el);
            }, this);
            return this;
        }
     });

    Market.Views.ItemSearchCollection = Market.Views.ItemCollection.extend({
        tagName: 'ul',
        initialize: function(){
            $that = this;
            this.collection.forEach(function(model){
              $that.addStockItemURL(model);
            });
            $(".response").html(this.render().el);
            this.listenTo(appView, "search-item-li:click", this.addItemToSlot); // From addItemSearchSlot line 373
            this.listenTo(appView, "removeView:click", this.removeView);
            console.log(this.collection);
        },
        render: function(){
            this.collection.each(function(item){
                this.addStockItemURL(item);
                var ItemView = new Market.Views.SearchItem({model: item});
                this.$el.append(ItemView.render().el); // append searched items
            }, this);
            return this;
        },
        addItemToSlot: function(itemId){
            var appendedItemModel = this.collection.findWhere({id: parseInt(itemId, 10)}); // find model that was clicked
            console.log(appendedItemModel);
            var appendedItemView = new Market.Views.SearchItem({model: appendedItemModel }); // Line 155 create new view
            this.addHighlightToNextClass(appendedItemView); // append this view to highlighted class
        },
        removeView: function(){
            this.remove(); // remove view
            this.unbind(); // unbind from model
        },
        addStockItemURL: function(model){
            console.log("addStockItemURL");
            console.log(model.get("image_url"));
            if(model.get("image_url") === null){
                console.log("in if state");
                model.set("image_url", "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png");
            }
        }
    });

    // Refactor here <-- 

    // Market.Views.ItemWantedCollection just creates the ItemsWantedCollection view
    // Basically, those six blank boxes
    Market.Views.ItemsWantedCollection = Backbone.View.extend({
        tagName: 'ul',
        initialize: function(){
           $(".items-wanted").html(this.render().el);
        },
        render: function(){
            this.collection.each(function(itemslot){
                itemSlotView = new Market.Views.ItemSlot({model: itemslot});
                this.$el.append(itemSlotView.render().el);
            }, this);

            return this;
        }
    });

     // Market.Views.ItemWantedCollection just creates the ItemsOfferedCollection view
    // Basically, those six blank boxes
    Market.Views.ItemsOfferedCollection = Market.Views.ItemsWantedCollection.extend({
        tagName: 'ul',
        initialize: function(){
           
           $(".items-offered").html(this.render().el);
           console.log("in items offerred collection view");
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
            "click .item-li": "addItemToSlot",
            "click .search-item-li": "addSearchItemToSlot",
            "click .search-btn": "removeView",
            "ajax:success": "createSearchCollection",
            "click #reload": "reloadItems"
        },

        addItemToSlot: function(e){
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("item-li:click", itemId); // Market.Views.ItemCollection
        },
        addSearchItemToSlot: function(e){ // line 239
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("search-item-li:click", itemId);
        },
        createSearchCollection: function(e, data, status, xhr){
            var searchItems = data;
            console.log(data);
            console.log("in createSearchCollection");
            // 1. new search collection being created with data
            var newSearchCollection = new Market.Collections.SearchItems(searchItems);
            // 2. new search collection view collection created with search collection
            // The problem is that it does not use a Backbone.model
            // Solution is to use a backbone model
            console.log(newSearchCollection);
            var newSearchCollectionView = new Market.Views.ItemSearchCollection({collection: newSearchCollection});
            $('li').tooltip("hide");
        },
        // global view remover
        removeView: function(){
            this.trigger("removeView:click");
        },
        reloadItems: function(){
            $("#reload").prop("disabled", true);
            $("#reload").html("Button disabled while reloading...");
            var request = $.ajax({
            type: "POST",
            url: "/reload"
            });
            request.done(function(response, textStatus, jqXHR){
                // Re-render the backpack
                var backpack  = new Market.Collections.Item();
                backpackView.unbind();
                backpackView.remove();
                backpack.set(response); // set() vs reset() ?
                backpackView = new Market.Views.ItemCollection({collection: backpack});
                $("#reload").prop("disabled", false);
                $("#reload").html("Reload backpack");
            });
            request.fail(function(){
                alert("Something has gone wrong");
                $("#reload").prop("disabled", false);
                $("#reload").html("Reload backpack");
             });
        }
    });
})();