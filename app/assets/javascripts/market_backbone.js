(function(){

/*** THINGS TO DO ***/

/* 
-Refactor Backbone code 
-Split items wanted and items offered section into two different classes
-Do not allow items offered section to use searched items 
-Integrate market.js code into this file
-Migrate to requireJS
-Switch to using defindexes for items instead of IDs
*/

/* 
1. When you click on an backpack item, add that item to the offered collection
    a. Add that model to the offered items collection
    b. Append the view to one of the offered collections slots
2. When you click on an search item, add that item to the wanted collection.
    a. add that model to the wanted items collection
    b. Append the view to onf of the wanted items collections. 


*/

/*** END ***/

// For namespacing

    window.Market = {
        Models: {},
        Collections: {},
        Views: {}
    };

    /****************** Models *********************/

    Market.Models.Item = Backbone.Model.extend({
        initialize: function(){
            this.addStockItemURL();
        },
        addStockItemURL: function(){
            if(this.get("image_url") === "" || this.get("image_url") === null){
                this.set("image_url", "http://cdn.dota2.com/apps/570/icons/econ/testitem_slot_empty.71716dc7a6b7f7303b96ddd15bbe904a772aa151.png");
            }
        }
    });



    Market.Models.ItemSlot = Backbone.Model.extend({

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

    Market.Models.ItemsWanted = Market.Models.ItemSlot.extend({
        defaults: {
            type: "wanted",
          }
    });

    Market.Models.ItemsOffered = Market.Models.ItemSlot.extend({
        defaults: {
            type: "offered",
          }
    });

    /***************** Collections ******************/

    Market.Collections.Item = Backbone.Collection.extend({ // Collection only
        model: Market.Models.Item,
    });

    Market.Collections.BackpackItems = Market.Collections.Item.extend({
       // empty 
    });

    Market.Collections.SearchItems = Backbone.Collection.extend({
      // empty 
    });

    Market.Collections.ItemSlots = Backbone.Collection.extend({

        model: Market.Models.ItemSlot,
        
        initialize: function(){
           this.createItemSlots();
        },
        createItemSlots: function(){
            for(i=0; i<6; i++){
                model_item_Slot = new Market.Models.ItemSlot();
                this.add(model_item_Slot);
            }
        }
    });

    /********************* Views ************************/

    Market.Views.Item = Backbone.View.extend({

        tagName: "li",
        className: "item-li item thumbnail",

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
            };
        },
        capitalize: function(string){
            if (string === null){
                return "Common";
            } else {
                return string.charAt(0).toUpperCase() + string.slice(1);
            }
        }
    });

    Market.Views.BackpackItem = Market.Views.Item.extend({
        itemTemplate: _.template("<a href='/items/<%= item_id %>'><img class='item-img' src='<%= image_url %>''></a>"),
        initialize: function(){
            this.$el.click(this.addToWantedCollection);
        },
        attributes: function(){
            return {
                'id': this.model.get("item_id"),
            };
        },
        addToWantedCollection: function(){
            console.log(this.model);
        }
    });

    Market.Views.SearchItem = Market.Views.Item.extend({
        className: "search-item-li item thumbnail",
        initialize: function(){
            console.log("search item click");
        }
    });

    Market.Views.ItemCollection = Backbone.View.extend({ // Backpack items view
        tagName: 'ul',
        className: "clearfix",
        initialize: function(){
            $(".backpack").html(this.render().el);
            this.listenTo(appView, "item-li:click", this.addItemtoSlot);
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
        initialize: function(){
            this.render();
        },
        render: function(){
            console.log("in here");
            // filter through all items in a collection
            // for each, create a new view
            // render and then append to the ul (unordered list)
            // populate backpack
            this.collection.each(function(item){
                var ItemView = new Market.Views.BackpackItem({model: item}); // Individual item view
                this.$el.append(ItemView.render().el);
            }, this);
            return this;
        }
     });

    Market.Views.ItemSearchCollection = Market.Views.ItemCollection.extend({ // Inherits from Market.Views.ItemCollection
        tagName: 'ul',
        initialize: function(){
            $that = this;
            $(".response").html(this.render().el);
                this.listenTo(appView, "search-item-li:click", this.addItemToSlot); // From addItemSearchSlot line 373
                this.listenTo(appView, "removeView:click", this.removeView);
            
        },
        render: function(){
            this.collection.each(function(item){
                var ItemView = new Market.Views.SearchItem({model: item});
                this.$el.append(ItemView.render().el); // append searched items
            }, this);
            return this;
        },
        addItemToSlot: function(itemId){
            var appendedItemModel = this.collection.findWhere({id: parseInt(itemId, 10)}); // find model that was clicked
            var appendedItemView = new Market.Views.SearchItem({model: appendedItemModel }); // Line 155 create new view
                this.addHighlightToNextClass(appendedItemView); // append this view to highlighted class
        },
        removeView: function(){
            this.remove(); // remove view
            this.unbind(); // unbind from model
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

        events: {
            "click .item-li": "addItemToSlot",
            "click .search-item-li": "addSearchItemToSlot",
            "click .search-btn": "removeView",
            "ajax:success": "createSearchCollection",
            "click #reload": "reloadItems",
           // "click .super-form": "submitListing"
        },

        submitListing: function(){
            console.log("hihi");
        },

        addItemToSlot: function(e){
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("item-li:click", itemId); // Market.Views.ItemCollection
        },
        addSearchItemToSlot: function(e){ // line 239
            e.preventDefault();
            console.log(e.currentTarget);
            var itemId = e.currentTarget.id;
            this.trigger("search-item-li:click", itemId);
        },
        createSearchCollection: function(e, data, status, xhr){
            var searchItems = data;
            // 1. new search collection being created with data
            var newSearchCollection = new Market.Collections.SearchItems(searchItems);
            // 2. new search collection view collection created with search collection
            // The problem is that it does not use a Backbone.model
            // Solution is to use a backbone model
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