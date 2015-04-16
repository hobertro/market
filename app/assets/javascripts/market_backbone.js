(function(){

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

    /***************** Collections ******************/

    Market.Collections.Item = Backbone.Collection.extend({ // Collection only
        model: Market.Models.Item,
    });

    Market.Collections.BackpackItems = Market.Collections.Item.extend({
       // empty
    });

    Market.Collections.SearchItems = Market.Collections.Item.extend({
        // empty
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
        attributes: function(){
            return {
                'id': this.model.get("item_id"),
            };
        },
        events: {
            "click": "addModelToItemSlot"
        },
        addModelToItemSlot: function(e){
            e.preventDefault();
            var itemsOfferedSlotModel = itemsOffered.collection.findWhere({selected: true});
            itemsOfferedSlotModel.addModelToItemSlot(this.model);
        }
    });

    Market.Views.SearchItem = Market.Views.Item.extend({
        className: "search-item-li item thumbnail",
        events: {
            "click": "addModelToItemSlot"
        },
        addModelToItemSlot: function(e){
            e.preventDefault();
            // implicit call to a model that is not explicitly known
            var itemsWantedSlotModel = itemsWanted.collection.findWhere({selected: true});
            itemsWantedSlotModel.addModelToItemSlot(this.model);
        }
    });

    /*** Collection Views ***/

    Market.Views.ItemCollection = Backbone.View.extend({ // Backpack items view
        tagName: 'ul',
        className: "clearfix",
        initialize: function(){
            $(".backpack").html(this.render().el);
            this.listenTo(appView, "item-li:click", this.addItemtoSlot);
        },
        render: function(){
            this.collection.forEach(function(item){
                var ItemView = new Market.Views.Item({model: item});
                this.$el.append(ItemView.render().el);
            }, this);
            return this;
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
                this.$el.append(ItemView.render().el);
            }, this);
            return this;
        },
        addItemToSlot: function(itemId){
            var appendedItemModel = this.collection.findWhere({id: parseInt(itemId, 10)});
            var appendedItemView = new Market.Views.SearchItem({model: appendedItemModel });
                this.addHighlightToNextClass(appendedItemView);
        },
        removeView: function(){
            this.remove();
            this.unbind();
        }
    });

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

    Market.Views.ItemsWantedSlots = Backbone.View.extend({
        el: "#items-wanted",
        events: {
            "click": "addItemToSlot"
        },

    });

    /*** Item Slots ***/

    Market.Models.ItemSlot = Backbone.Model.extend({
        initialize: function(){
            this.container = [];
           
        },
        defaults: {
            "selected": false
        },
        addModelToItemSlot: function(model){
            this.container = [];
            this.container.push(model);
            this.trigger("addedModel");
        },
    });

    Market.Views.ItemSlot = Backbone.View.extend({
        model: Market.Models.ItemSlot,
        tagName: "li",
        className: "item-slot",
        events: {
            "click": "toggleSelectedValue"
        },
        initialize: function(){
            this.listenTo(this.model, "addedModel", this.appendView);
        },
        render: function(){
            return this;
        },
        appendView: function(){
            var modelView = new Market.Views.Item({model: this.model.container[0]});
            this.$el.html(modelView.render().el);
            var trashView = new Market.Views.Trash();
                trashView.parentView = this;
                this.$el.append(trashView.render().el);
        },
        toggleSelectedValue: function(){
            this.parentView.toggleSelectAllFalse();
            this.model.set("selected", true);
        }
    });

    Market.Collections.ItemSlots = Backbone.Collection.extend({
        initialize: function(){
            this.createItemSlots();
            this.at(0).set("selected", true);
        },
        createItemSlots: function(){
            for(i=0; i<6; i++){
                model_item_Slot = new Market.Models.ItemSlot();
                model_item_Slot.parentView = this;
                this.add(model_item_Slot);
            }
        }
    });

    Market.Collections.OfferedSlots = Market.Collections.ItemSlots.extend({
        // empty
    });

    Market.Collections.WantedSlots = Market.Collections.ItemSlots.extend({
        // empty
    });

    Market.Views.ItemSlots = Backbone.View.extend({
        initialize: function(){
        var $that = this;
        this.collection.each(function(slot){
            ItemSlotView = new Market.Views.ItemSlot({model: slot});
            ItemSlotView.parentView = $that;
            $that.$el.append(ItemSlotView.render().el);
          });
        },
        toggleSelectAllFalse: function(){
            this.collection.forEach(function(itemSlot){
                itemSlot.set("selected", false);
            });
        }
    });

    Market.Views.OfferedSlots = Market.Views.ItemSlots.extend({
        el: "#itemsOffered"
    });

    Market.Views.WantedSlots = Market.Views.ItemSlots.extend({
        el: "#itemsWanted"
    });

    Market.Views.Trash = Backbone.View.extend({
        className: "trash-view",
        trashTpl: _.template("<a><i class='glyphicon glyphicon-trash'></i></a>"),
        events: {
            "click": "deleteView"
        },
        render: function(){
            this.$el.html(this.trashTpl());
            return this;
        },
        deleteView: function(){
            this.parentView.model.container = [];
            this.parentView.$el.html("");
        }
    });

    /* Test ends here */

    // global view

    Market.Views.App = Backbone.View.extend({

        el: "#market",

        events: {
            "click .item-li": "addItemToSlot",
            //"click .search-item-li": "addSearchItemToSlot",
            "click .search-btn": "removeView",
            "ajax:success": "createSearchCollection",
            "click #reload": "reloadItems",
           // "click .super-form": "submitListing"
           "click .submit-button": "submitListing"
        },

        submitListing: function(e){
            $(".super-form").submit(function(e){
                var itemsWantedSubmitted = [];
                var itemsOfferedSubmitted = [];
                var notes = $(".notes-input").val();

                itemsWanted.collection.forEach(function(slot){
                    if(slot.container.length){
                        itemsWantedSubmitted.push(slot.container[0].get("defindex"));
                    }
                });

                itemsOffered.collection.forEach(function(slot){
                    if(slot.container.length){
                        itemsOfferedSubmitted.push(slot.container[0].get("defindex"));
                    }
                });

                var offer = JSON.stringify(itemsOfferedSubmitted);
                var wanted = JSON.stringify(itemsWantedSubmitted);
                $("#offer").val(offer);
                $("#wanted").val(wanted);
                $("#listnote").val(notes);
            });
        },

        addItemToSlot: function(e){
            e.preventDefault();
            var itemId = e.currentTarget.id;
            this.trigger("item-li:click", itemId);
        },
        addSearchItemToSlot: function(e){
            e.preventDefault();
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
                var backpack = new Market.Collections.Item();
                backpackView.unbind();
                backpackView.remove();
                backpack.set(response);
                backpackView = new Market.Views.BackpackItemCollection({collection: backpack});
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