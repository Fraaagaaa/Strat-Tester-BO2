# Replaced functions table

| Namespace | Function | Reason |
| :--- | :--- | :--- |
| `maps/mp/zm_alcatraz_distance_tracking`   | `delete_zombie_noone_looking`             | Tracking zombie respawns |
| `maps/mp/zm_buried_distance_tracking`     | `delete_zombie_noone_looking`             | Tracking zombie respawns |
| `maps/mp/zm_highrise_distance_tracking`   | `delete_zombie_noone_looking`             | Tracking zombie respawns |
| `maps/mp/zm_tomb_distance_tracking`       | `delete_zombie_noone_looking`             | Tracking zombie respawns |
| `maps/mp/zm_transit_distance_tracking`    | `delete_zombie_noone_looking`             | Tracking zombie respawns |
| `maps/mp/zm_highrise_elevators`           | `watch_for_elevator_during_faller_spawn`  | Tracking zombie deaths by elevators |
| `maps/mp/zm_nuked_perks`                  | `perks_from_the_sky`                      | Remove the wait between perks |
| `maps/mp/zm_tomb_capture_zones`           | `pack_a_punch_think`                      | Always enable Pack-A-Punch |
| `maps/mp/zm_tomb_capture_zones`           | `recapture_round_tracker`                 | Adjust templars when changing to a lower round |
| `maps/mp/zm_tomb_chamber`                 | `move_wall_down`                          | Toggle mooving walls |
| `maps/mp/zm_tomb_giant_robot`             | `zombie_stomp_death`                      | Tracking stomps |
| `maps/mp/zm_tomb_tank`                    | `flamethrower_damage_zombies`             | Tracking zombies dying to the tank |
| `maps/mp/zm_tomb_tank`                    | `tank_drop_powerups`                      | Enable tank powerups without manually collecting the electric staff parts |
| `maps/mp/zm_tomb_utility`                 | `watch_staff_usage`                       | Enable ammo refill on staffs without upgrading them manually |
| `maps/mp/zm_transit_bus`                  | `busschedule`                             | Change farm's station departure time |
| `maps/mp/zombies/_zm_ai_screecher`        | `screecher_spawning_logic`                | Disable denizens |
| `maps/mp/zombies/_zm_equip_subwoofer`     | `subwooferthink`                          | Track subwoofer kills |
| `maps/mp/zombies/_zm_magicbox`            | `treasure_chest_weapon_spawn`             | Track boxhits |
| `maps/mp/zombies/_zm_spawner`             | `zombie_can_drop_powerups`                | Enable/Disable Power-Ups |
| `maps/mp/zombies/_zm_weap_one_inch_punch` | `knockdown_zombie_animate_state`          | Track tumble animations |
| `maps/mp/zombies/_zm_weap_slipgun`        | `pool_of_goo`                             | Sliquifire timer |
| `maps/mp/zombies/_zm_weap_slipgun`        | `slip_bolt`                               | Sliquifire timer |
| `maps/mp/zombies/_zm_weap_staff_air`      | `staff_air_position_source`               | Wind staff timer |
| `maps/mp/zombies/_zm_weap_staff_water`    | `staff_water_position_source`             | Ice staff timer |
| `maps/mp/zombies/_zm`                     | `round_think`                             | Remove round 255 cap |