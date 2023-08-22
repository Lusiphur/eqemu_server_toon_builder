#:: Zone: Plane of Knowledge(poknowlegde) >> Bob_The_Builder (20260)

sub EVENT_SPAWN {
    quest::say("I am Bob. I build toons for Omens of War!");
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::say("Hello $name, and welcome to the Death Metal Homeworld server!  I'm here to make your life easy, so let me know when you want me to [" . quest::saylink("buff you to readiness") . "] 
            or [" . quest::saylink("redo your skills") . "] or [" . quest::saylink("reload your spells") . "]  or [" . quest::saylink("max primary specialization skill") . "] 
            or [" . quest::saylink("you need some xp") . "] or [" . quest::saylink("update your gear") . "] or [" . quest::saylink("give you a mask") . "] or [" . quest::saylink("give you distillers") . "]
            or [" . quest::saylink("feed you") . "]");
    }
    #:: Match text for "buff you to readiness", case insensitive
    elsif ($text=~/buff you to readiness/i) {
        quest::say("Alright, $class let's get you up to speed!");
        quest::say("Binding you here");
        quest::selfcast(2049);
        # Level to 70
        quest::say("Making you level 70!");
        quest::level(70);
        quest::pause(5000);
        # Adding to Death Metal guild as a member
        $guild = $client->GuildID();
        if ( $guild != 1) {
            quest::setguild(1, 0);
            quest::say("You have been added to the guild Death Metal!");
        }    
        #:: Train all disciplines up to the user's level
        quest::say("Time for some discipline!");
        if ($class eq 'Berserker' || $class eq 'Monk' || $class eq 'Rogue' || $class eq 'Warrior' || $class eq 'Paladin' || $class eq 'Bard' || $class eq 'Shadowknight' || $class eq 'Ranger' || $class eq 'Beastlord') {
            quest::say("Training your disciplines");
            quest::traindiscs(70, 0);
        }
        else {
            quest::say("Your class does not use disciplines");
        }   
        #:: Set available (non-trade, non-casting specialization) skills to maximum for race/class at current level
        quest::say("Training your skills");
        foreach my $skill ( 0 .. 42, 48 .. 54, 70 .. 74 ) {
            next unless $client->CanHaveSkill($skill);
            #:: Create a scalar variable to store each skill's maximum skill level at the player's current level
            my $maxSkill = $client->MaxSkill($skill, $client->GetClass(), 70);
            #:: Check that the player's skill does not already exceed the maximum skill based on level
            next unless $maxSkill > $client->GetRawSkill($skill);
            #:: Set the skill to the maximum
            $client->SetSkill($skill, $maxSkill);
        }
        if ($class eq 'Enchanter') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }
        elsif ($class eq 'Magician') {
            my $maxSkill = $client->MaxSkill(45, $client->GetClass(), 70);
            $client->SetSkill(45, $maxSkill);
        }    
        elsif ($class eq 'Necromancer') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }
        elsif ($class eq 'Wizard') {
            my $maxSkill = $client->MaxSkill(47, $client->GetClass(), 70);
            $client->SetSkill(47, $maxSkill);
        }    
        elsif ($class eq 'Cleric') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }   
        elsif ($class eq 'Druid') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }                                       
        elsif ($class eq 'Shaman') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }        
        # Add 800 AA pts
        quest::say("Giving you 2000 AA points");
        $client->SetAAPoints(2000);
        # Give 5000pp
        if ($name ne "Binkapal") {
            quest::say("Here, have some cash");
            quest::givecash(0,0,0,5000);
        }    
        # Inventory work
        my @inventory_slots = (
            quest::getinventoryslotid("possessions.begin")..quest::getinventoryslotid("possessions.end")
            );
        foreach $slot_id (@inventory_slots) {
            $slotname = quest::getinventoryslotname($slot_id);
            if ($client->GetItemAt($slot_id)) {
                $itemname = quest::getitemname($client->GetItemIDAt($slot_id));
                $slotname = quest::getinventoryslotname($slot_id);
                quest::say("You have a $itemname at slot $slotname. This will be removed");
                quest::removeitem($client->GetItemIDAt($slot_id));
            }
        }
        # Spells
        if ($class eq 'Bard' || $class eq 'Beastlord' || $class eq 'Cleric' || $class eq 'Druid' || $class eq 'Enchanter' || $class eq 'Magician' || $class eq 'Necromancer' || $class eq 'Paladin' || $class eq 'Ranger' || $class eq 'Shadowknight' || $class eq 'Shaman' || $class eq 'Wizard') {
            #:: Clear out any existing spells
            quest::unscribespells();
            #:: Scribe all spells up to the user's level
            quest::scribespells(70, 0);
            #:: Send a message that only the client can see, in yellow (15) text
            $client->Message(15, "You look like a more powerful caster already! Go out and test your new spells!");
        }
        quest::say("Giving you some bags");
        my @a = (1..10);
        for $i (@a) {
                $slotname = "General".$i;
                $slotid = quest::getinventoryslotid($slotname);
                $client->SummonItem(17145, -1, 1, 0, 0, 0, 0, 0, $slotid);
        }
         # Dranik Loyalists
        quest::say("Sorting factions");
        $faction = $client->GetCharacterFactionLevel(1016);
        if ($faction < 2000) {
            quest::faction(1016, 2800);
        }
        $faction = $client->GetCharacterFactionLevel(1016);
        $facname = quest::getfactionname(1016);
        quest::say("$name your $facname faction is now $faction");
        #Cipher of Txevu
        quest::say("Cipher of Txevu for you");
        plugin::summon_into_inventory($client, 60254, 1);
        if ($name eq "Binkapal") {
            $client->Message(2,"You will need a Signet of Command"); 
            plugin::summon_into_inventory($client, 64034, 1); 
        }
        #flags
        quest::setglobal("pop_poi_behometh_flag", 1, 5, "F");
        quest::setglobal("pop_pon_hedge_jezith", 1, 5, "F");
        quest::setglobal("pop_pon_construct", 1, 5, "F");
        quest::setglobal("pop_ponb_terris", 1, 5, "F");
        quest::setglobal("pop_ponb_poxbourne", 1, 5, "F");
        quest::setglobal("pop_poi_dragon", 1, 5, "F");
        quest::setglobal("pop_poi_behometh_preflag", 1, 5, "F");
        quest::setglobal("pop_poi_behometh_flag", 1, 5, "F");
        quest::setglobal("pop_pod_alder_fuirstel", 1, 5, "F");
        quest::setglobal("pop_pod_grimmus_planar_projection", 1, 5, "F");
        quest::setglobal("pop_pod_elder_fuirstel", 1, 5, "F");
        quest::setglobal("pop_poj_mavuin", 1, 5, "F");
        quest::setglobal("pop_poj_tribunal", 1, 5, "F");
        quest::setglobal("pop_poj_valor_storms", 1, 5, "F");
        quest::setglobal("pop_poj_execution", 1, 5, "F");
        quest::setglobal("pop_poj_flame", 1, 5, "F");
        quest::setglobal("pop_poj_hanging", 1, 5, "F");
        quest::setglobal("pop_poj_lashing", 1, 5, "F");
        quest::setglobal("pop_poj_stoning", 1, 5, "F");
        quest::setglobal("pop_poj_torture", 1, 5, "F");
        quest::setglobal("pop_pov_aerin_dar", 1, 5, "F");
        quest::setglobal("pop_pos_askr_the_lost", 3, 5, "F");
        quest::setglobal("pop_pos_askr_the_lost_final", 1, 5, "F");
        quest::setglobal("pop_cod_preflag", 1, 5, "F");
        quest::setglobal("pop_cod_bertox", 1, 5, "F");
        quest::setglobal("pop_cod_final", 1, 5, "F");
        quest::setglobal("pop_pot_shadyglade", 1, 5, "F");
        quest::setglobal("pop_pot_newleaf", 1, 5, "F");
        quest::setglobal("pop_pot_saryrn", 1, 5, "F");
        quest::setglobal("pop_pot_saryrn_final", 1, 5, "F");
        quest::setglobal("pop_hoh_faye", 1, 5, "F");
        quest::setglobal("pop_hoh_trell", 1, 5, "F");
        quest::setglobal("pop_hoh_garn", 1, 5, "F");
        quest::setglobal("pop_hohb_marr", 1, 5, "F");
        quest::setglobal("pop_bot_agnarr", 1, 5, "F");
        quest::setglobal("pop_bot_karana", 1, 5, "F");
        quest::setglobal("pop_tactics_tallon", 1, 5, "F");
        quest::setglobal("pop_tactics_vallon", 1, 5, "F");
        quest::setglobal("pop_tactics_ralloz", 1, 5, "F");
        quest::setglobal("pop_elemental_grand_librarian", 1, 5, "F");
        quest::setglobal("pop_sol_ro_arlyxir", 1, 5, "F");
        quest::setglobal("pop_sol_ro_dresolik", 1, 5, "F");
        quest::setglobal("pop_sol_ro_jiva", 1, 5, "F");
        quest::setglobal("pop_sol_ro_rizlona", 1, 5, "F");
        quest::setglobal("pop_sol_ro_xuzl", 1, 5, "F");
        quest::setglobal("pop_sol_ro_solusk", 1, 5, "F");
        quest::setglobal("pop_fire_fennin_projection", 1, 5, "F");
        quest::setglobal("pop_wind_xegony_projection", 1, 5, "F");
        quest::setglobal("pop_water_coirnav_projection", 1, 5, "F");
        quest::setglobal("pop_eartha_arbitor_projection", 1, 5, "F");
        quest::setglobal("pop_earthb_rathe", 1, 5, "F");
        quest::setglobal("pop_time_maelin", 1, 5, "F");
        $client->Message(355,"You receive all Planes of Power character flags!");
        quest::setglobal("god_vxed_access", "1", 5, "F");
        quest::setglobal("god_tipt_access", "1", 5, "F");
        quest::setglobal("god_kodtaz_access", "1", 5, "F");
        quest::setglobal("god_qvic_access",1,5,"F");
        quest::set_zone_flag(295);
        quest::set_zone_flag(297);
        $client->Message(355,"You receive all Gates of Discord character flags!");
        quest::setglobal("oow_rss_taromani_insignias",1,5,"F");
        quest::setglobal("oow_mpg_raids_complete",1,5,"F");
        $client->Message(355,"You receive all Omens of War character flags!");
        # Gear
        # For mages Blazing Stone of Demise - 68723
        if ($name eq "Binkatest" || $name eq "Binkamag") {
            plugin::summon_into_inventory($client, 68723, 1);  
        } 
        if ($name eq "Binkatest") {
            # Pretend Binkatest is Binkamag for gearing purposes
            %inventory = plugin::read_inventory_file("Binkamag");
            foreach $key (keys %inventory) {
                    $slot_id = quest::getinventoryslotid($key);
                    next if ($inventory{$key}[0] eq "Empty");
                    $itemid = $inventory{$key}[0];
                    if ($inventory{$key}[1] ne "Empty") {
                        $aug1 = $inventory{$key}[1];
                    }
                    else {
                        $aug1 = 0;
                    }
                    if ($inventory{$key}[2] ne "Empty") {
                        $aug2 = $inventory{$key}[2];
                    }
                    else {
                        $aug2 = 0;
                    }
                    $client->SummonItem($itemid, -1, 0, $aug1, $aug2, 0, 0, 0, $slot_id);
            }        
        }
        else {
            # Read in the actual chars file
            %inventory = plugin::read_inventory_file($name);
            foreach $key (keys %inventory) {
                    $slot_id = quest::getinventoryslotid($key);
                    next if ($inventory{$key}[0] eq "Empty");
                    $itemid = $inventory{$key}[0];  
                    if ($inventory{$key}[1] ne "Empty") {
                        $aug1 = $inventory{$key}[1];
                    }
                    else {
                        $aug1 = 0;
                    }
                    if ($inventory{$key}[2] ne "Empty") {
                        $aug2 = $inventory{$key}[2];
                    }
                    else {
                        $aug2 = 0;
                    }
                    $client->SummonItem($itemid, -1, 0, $aug1, $aug2, 0, 0, 0, $slot_id);
            }
            #casters get Girdle of Efficiency - 70611
            if ($class eq 'Cleric' || $class eq 'Druid' || $class eq 'Enchanter' || $class eq 'Magician' || $class eq 'Necromancer' || $class eq 'Shaman' || $class eq 'Wizard') {
                plugin::summon_into_inventory($client, 70611, 1);
            } 
            if ($name eq "Binkask" || $name eq 'Binkaplink') {
                # Fuzzy Foothairs - 31859
                plugin::summon_into_inventory($client, 31859, 1);                
            }

        }            
    }
    elsif ($text=~/redo your skills/i) {
                #:: Set available (non-trade, non-casting specialization) skills to maximum for race/class at current level
        quest::say("Training your skills");
        foreach my $skill ( 0 .. 42, 48 .. 54, 70 .. 74 ) {
            next unless $client->CanHaveSkill($skill);
            #:: Create a scalar variable to store each skill's maximum skill level at the player's current level
            my $maxSkill = $client->MaxSkill($skill, $client->GetClass(), 70);
            #:: Check that the player's skill does not already exceed the maximum skill based on level
            next unless $maxSkill > $client->GetRawSkill($skill);
            #:: Set the skill to the maximum
            $client->SetSkill($skill, $maxSkill);
        }
    }
    elsif ($text=~/reload your spells/i) {
        # Spells
        if ($class eq 'Bard' || $class eq 'Beastlord' || $class eq 'Cleric' || $class eq 'Druid' || $class eq 'Enchanter' || $class eq 'Magician' || $class eq 'Necromancer' || $class eq 'Paladin' || $class eq 'Ranger' || $class eq 'Shadowknight' || $class eq 'Shaman' || $class eq 'Wizard') {
            #:: Clear out any existing spells
            quest::unscribespells();
            #:: Scribe all spells up to the user's level
            quest::scribespells(70, 0);
            #:: Send a message that only the client can see, in yellow (15) text
            $client->Message(15, "You look like a more powerful caster already! Go out and test your new spells!");
        }    
    }
    elsif ($text=~/max primary specialization skill/i) {
        # Skills
        if ($class eq 'Enchanter') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }
        elsif ($class eq 'Magician') {
            my $maxSkill = $client->MaxSkill(45, $client->GetClass(), 70);
            $client->SetSkill(45, $maxSkill);
        }    
        elsif ($class eq 'Necromancer') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }
        elsif ($class eq 'Wizard') {
            my $maxSkill = $client->MaxSkill(47, $client->GetClass(), 70);
            $client->SetSkill(47, $maxSkill);
        }    
        elsif ($class eq 'Cleric') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        } 
        elsif ($class eq 'Druid') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }                                        
        elsif ($class eq 'Shaman') {
            my $maxSkill = $client->MaxSkill(44, $client->GetClass(), 70);
            $client->SetSkill(44, $maxSkill);
        }
    }
    elsif ($text=~/I need some xp/i) {
        quest::say('Here is some xp');
        quest::exp(50000000);
        }
    elsif ($text=~/feed you/i) {
        quest::say('Here is some food');
        plugin::summon_into_inventory($client, 9662, 20);
        plugin::summon_into_inventory($client, 9758, 20);
        }        
    elsif ($text=~/mask/i) {
        quest::say('Here is a mask');
        plugin::summon_into_inventory($client, 56017, 1);  
        }
    elsif ($text=~/distillers/i) {
        quest::say('Here is a set of distillers');
        plugin::summon_into_inventory($client, 47015, 20);  
        plugin::summon_into_inventory($client, 47016, 20);
        plugin::summon_into_inventory($client, 47017, 20);
        plugin::summon_into_inventory($client, 47018, 20);
        }                  
    elsif ($text=~/update my gear/i) {
        quest::say('Updating your gear from PEQ');
          
        my @inventory_slots = (
            quest::getinventoryslotid("possessions.begin")..quest::getinventoryslotid("possessions.end")
            );
        foreach $slot_id (@inventory_slots) {
            $slotname = quest::getinventoryslotname($slot_id);
            next if (index($slotname,  "General") != -1);  
            if ($client->GetItemAt($slot_id)) {
                quest::removeitem($client->GetItemIDAt($slot_id));
            }
        }
        # Read in the actual chars file
        %inventory = plugin::read_inventory_file($name);
        foreach $key (keys %inventory) {
                $slot_id = quest::getinventoryslotid($key);
                next if ($inventory{$key}[0] eq "Empty");
                $itemid = $inventory{$key}[0];  
                if ($inventory{$key}[1] ne "Empty") {
                    $aug1 = $inventory{$key}[1];
                }
                else {
                    $aug1 = 0;
                }
                if ($inventory{$key}[2] ne "Empty") {
                    $aug2 = $inventory{$key}[2];
                }
                else {
                    $aug2 = 0;
                }
                $client->SummonItem($itemid, -1, 0, $aug1, $aug2, 0, 0, 0, $slot_id);
        }
    }    
}

#:: Zone: Plane of Knowledge(poknowlegde) >> Bob_The_Builder (20260)
