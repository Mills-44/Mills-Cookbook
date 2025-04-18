return {
    key = 'jalapeno', -- Level 3 of the pepper joker 
    loc_txt = {
        name = 'Jalapeno',
        text = {
           "When a {C:attention}Flush{} or {C:attention}Full House{} is played",
            "this Joker gains {C:mult}+#1#{} Mult",
            "Every {C:attention}3rd{} activation levels up Spicyness!",
            "{C:inactive}Total Mult: {C:mult}+#2#{}",
             "{X:gold,C:blue} Art By gfsg "
        }
    },
    config = {
        extra = {
        gain = 7,    
        mult = 0
        }, 
        levels = 0
    }, 
    atlas = 'pepper_jokers',
    pos = {
        x = 2,
        y = 0 
    },
    soul_pos = {
        x = 2, 
        y = 1 
    },
    rarity = 1,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return { 
            vars = { 
                card.ability.extra.gain or 7,
                card.ability.extra.mult or 0
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.before then
        return {
            mult = card.ability.extra.mult,
        }
        end
        local in_pool = function(self, args)
            return false
        end        
        if context.before and context.scoring_name and (context.scoring_name == "Flush" or context.scoring_name == "Full House") then
            card.ability.extra.mult = card.ability.extra.mult + 7
            card.ability.levels = (card.ability.levels or 0) + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('mills_spicy')
                    return true
                end
            }))
            local result = {
                message = 'Spicy!',
                colour = G.C.MULT,
                card = card
            }
            if card.ability.levels >= 3 then
                card.ability.levels = 0       
                card.ability.evolve_to = "j_mills_cayenne"
            end
            return result
        end
            if context.after and card.ability.evolve_to then
                local evolve_key = card.ability.evolve_to
                card.ability.evolve_to = nil
                SMODS.add_card({key = evolve_key})
                local cards= G.jokers.cards
                local new_card = cards[#cards]
            if new_card then  
                new_card.ability.extra.mult = card.ability.extra.mult or 0
                new_card.ability.levels = 0
            end 
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:remove()
                    card = nil
                    return true; 
                end
                })) 
            return true
        end
        })) 
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('mills_adios')
                return true
            end
        }))
        return {
            message = "Adios!",
            colour = G.C.CHIPS
            }     
        end
    end
}
