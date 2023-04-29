#include "../plugin_sdk/plugin_sdk.hpp"
#include "xayah.h"
#include "utilities.h"
#include "permashow.hpp"

namespace Xayah
{

    float colorq[] = { 1.0f, 1.0f, 0.0f, 1.0f };
    float colorw[] = { 1.0f, 1.0f, 0.0f, 1.0f };
    float colore[] = { 0.0f, 1.0f, 1.0f, 1.0f };
    float colorr[] = { 1.0f, 1.0f, 0.0f, 1.0f };
    float feathercolor[] = { 1.0f, 1.0f, 0.0f, 1.0f };
    float colorenemy[] = { 1.0f, 1.0f, 0.0f, 1.0f };
    float coloraa[] = { 1.0f, 1.0f, 0.0f, 1.0f };
    // To declare a spell, it is necessary to create an object and registering it in load function
    script_spell* q = nullptr;
    script_spell* w = nullptr;
    script_spell* e = nullptr;
    script_spell* r = nullptr;

    script_spell* flash = nullptr;

    // Declaration of menu objects
    TreeTab* main_tab = nullptr;

    namespace draw_settings
    {
        TreeEntry* draw_range_q = nullptr;
        TreeEntry* draw_range_q2 = nullptr;
        TreeEntry* draw_color_q = nullptr;
        TreeEntry* draw_range_w = nullptr;
        TreeEntry* draw_range_w2 = nullptr;
        TreeEntry* draw_color_w = nullptr;
        TreeEntry* draw_range_e = nullptr;
        TreeEntry* draw_range_e2 = nullptr;
        TreeEntry* draw_color_e = nullptr;
        TreeEntry* draw_range_r = nullptr;
        TreeEntry* draw_range_r2 = nullptr;
        TreeEntry* draw_color_r = nullptr;
        TreeEntry* q_color = nullptr;
        TreeEntry* w_color = nullptr;
        TreeEntry* e_color = nullptr;
        TreeEntry* r_color = nullptr;
        TreeEntry* draw_damage = nullptr;
        TreeEntry* aa_damage = nullptr;
        TreeEntry* e_damage = nullptr;
        TreeEntry* include_x_aa = nullptr;
        TreeEntry* drawecolor = nullptr;
        TreeEntry* drawaacolor = nullptr;
        TreeEntry* drawselector = nullptr;
        TreeEntry* drawfeathers = nullptr;
        TreeEntry* drawcolorfeather = nullptr;
        TreeEntry* feather_color = nullptr;
    }
    namespace combo
    {
        TreeEntry* Qseparator = nullptr;
        TreeEntry* Wseparator = nullptr;
        TreeEntry* Eseparator = nullptr;
        TreeEntry* Rseparator = nullptr;
        TreeEntry* use_q = nullptr;
        TreeEntry* use_w = nullptr;
        TreeEntry* use_e = nullptr;
        TreeEntry* use_r = nullptr;
    }
    namespace harass
    {
        TreeEntry* Qseparatorharas = nullptr;
        TreeEntry* Wseparatorharas = nullptr;
        TreeEntry* Eseparatorharas= nullptr;
        TreeEntry* use_qharas = nullptr;
        TreeEntry* use_wharas = nullptr;
        TreeEntry* manausage = nullptr;
        TreeEntry* use_eharas = nullptr;
    }
    namespace w_multihit
    {
        TreeEntry* w_setting = nullptr;
    }
    namespace e_multihitharass
    {
        TreeEntry* e_setting = nullptr;
    }
    namespace r_multihit
    {
        TreeEntry* r_setting = nullptr;
    }
    namespace e_multihit
    {
        TreeEntry* e_setting = nullptr;
    }
    namespace config_settings
    {
        TreeEntry* q_setting = nullptr;
        TreeEntry* w_setting = nullptr;
        TreeEntry* e_setting = nullptr;
        TreeEntry* r_setting = nullptr;
    }
    namespace config_settingsharass
    {
        TreeEntry* q_setting = nullptr;
        TreeEntry* w_setting = nullptr;
        TreeEntry* e_setting = nullptr;
        TreeEntry* r_setting = nullptr;
    }
    namespace laneclear1
    {
        TreeEntry* use_q = nullptr;
        TreeEntry* use_e = nullptr;
        TreeEntry* use_w = nullptr;
        TreeEntry* laneclear1 = nullptr;
        TreeEntry* timew = nullptr;
        TreeEntry* timee = nullptr;
        TreeEntry* qseparatorlaneclear = nullptr;
        TreeEntry* Eseparatorlaneclear = nullptr;
        TreeEntry* Wseparatorlaneclear = nullptr;
    }
    namespace hotkeys
    {
        TreeEntry* farmonoff = nullptr;
        TreeEntry* semir = nullptr;
        
    }

    namespace jungleclear
    {
        TreeEntry* use_q = nullptr;
        TreeEntry* use_e = nullptr;
        TreeEntry* use_w = nullptr;
        TreeEntry* jungleclear = nullptr;
        TreeEntry* timewjungle = nullptr;
        TreeEntry* timeejungle = nullptr;
        TreeEntry* qseparatorjglclear = nullptr;
        TreeEntry* Eseparatorjglclear = nullptr;
        TreeEntry* Wseparatorjglclear = nullptr;
    }

    namespace misc
    {
        TreeEntry* use_ekill = nullptr;
        TreeEntry* Qseparator = nullptr;
        TreeEntry* Wseparator = nullptr;
        TreeEntry* Eseparator = nullptr;
        TreeEntry* Rseparator = nullptr;
        TreeEntry* use_qks = nullptr;
        TreeEntry* use_wtower = nullptr;
        TreeEntry* use_revadee = nullptr;
        TreeEntry* auto_eroot = nullptr;
        
    }

    namespace aio_info
    {
        TreeEntry* aio_info_date = nullptr;
    }
    namespace loadmsg
    {
        TreeEntry* show_chatmsg = nullptr;
    }
    struct particleData {
        game_object_script particle = {};
        float creationTime = 0;
        float count = 0;
    };

    std::vector<particleData> particleList;

    // Event handler functions
    void on_update();
    void on_draw();
    void on_env_draw();
    void on_object_dead(game_object_script sender);

    // Declaring functions responsible for spell-logic
    //
    void on_create();
    void on_deletefeath();
    void q_logic();
    void q_logicharass();
    void r_logicsemi();
    void w_logic();
    void w_logicharass();
    void e_logic();
    void e_logicharass();
    void r_logic();

    int kills = 0;

    // Enum is used to define myhero region 
    enum Position
    {
        Line,
        Jungle
    };

    Position my_hero_region;

// xayah feather
void on_create(const game_object_script obj)
    {
        const auto& emitterHash = obj->get_emitter_resources_hash();

        switch (emitterHash)
        {
        case buff_hash("Xayah_Passive_Dagger_Mark8s"):
        {
            if (obj->get_emitter() && obj->get_emitter()->is_ally())
                particleList.push_back({ .particle = obj , .creationTime = gametime->get_time()});
            return;
        }
        }


}
void on_deletefeath(const game_object_script obj)
{
    switch (obj->get_emitter_resources_hash())
    {
    case buff_hash("Xayah_Passive_Dagger_Mark8s"):
    {
        if (obj->get_emitter() && obj->get_emitter()->is_ally()) 
        {
            for (auto it = particleList.begin(); it != particleList.end(); ) 
            {
                if (it->particle->get_handle() == obj->get_handle()) {
                    it = particleList.erase(it);
                }
                else 
                {
                    ++it;
                }
            }
        }
        return;
    }
    }
}
void load()
    {
        q = plugin_sdk->register_spell(spellslot::q, 1100);
        w = plugin_sdk->register_spell(spellslot::w, 950);
        w->set_skillshot(0.25f, 300.f, 1400.f, { collisionable_objects::yasuo_wall }, skillshot_type::skillshot_circle);
        e = plugin_sdk->register_spell(spellslot::e, 2000);
        r = plugin_sdk->register_spell(spellslot::r, 1100);

        if (myhero->get_spell(spellslot::summoner1)->get_spell_data()->get_name_hash() == spell_hash("SummonerFlash"))
            flash = plugin_sdk->register_spell(spellslot::summoner1, 400.f);
        else if (myhero->get_spell(spellslot::summoner2)->get_spell_data()->get_name_hash() == spell_hash("SummonerFlash"))
            flash = plugin_sdk->register_spell(spellslot::summoner2, 400.f);

        main_tab = menu->create_tab("Xayah", "relaxAIO - Xayah");
        main_tab->set_assigned_texture(myhero->get_square_icon_portrait());
        {
            auto combo = main_tab->add_tab(myhero->get_model() + ".combo", "Combo Settings");
            {  
                combo::Qseparator = combo->add_separator(".Qseparator", "--Q usage Settings--");
                combo::use_q = combo->add_checkbox(myhero->get_model() + ".comboUseQ", "Use Q", true);
                combo::use_q->set_texture(myhero->get_spell(spellslot::q)->get_icon_texture());
                config_settings::q_setting = combo->add_combobox(".Qusagesetting", "Q usage Settings", { {"Never",nullptr},{"Always",nullptr } }, 1);
                combo::Wseparator = combo->add_separator(".Wseparator", "--W usage Settings--");
                combo::use_w = combo->add_checkbox(myhero->get_model() + ".comboUseW", "Use W", true);
                combo::use_w->set_texture(myhero->get_spell(spellslot::w)->get_icon_texture());
                config_settings::w_setting = combo->add_combobox(".Wusagesetting", "W usage Settings", { {"Never",nullptr},{"Always",nullptr } }, 1);
                combo::Eseparator = combo->add_separator(".Eseparator", "--E usage Settings--");
                combo::use_e = combo->add_checkbox(myhero->get_model() + ".comboUseE", "Use E", true);
                combo::use_e->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
                config_settings::e_setting = combo->add_combobox(".Eusagesetting", "E usage Settings", { {"Never",nullptr},{"If Hit X feathers",nullptr }}, 1);
                e_multihit::e_setting = combo->add_slider(".Emultihitusage", "Cast if hit X feathers", 3, 1, 5);
                combo::Rseparator = combo->add_separator(".Rseparator", "--R usage Settings--");
                combo::use_r = combo->add_checkbox(myhero->get_model() + ".comboUseR", "Use R", true);
                combo::use_r->set_texture(myhero->get_spell(spellslot::r)->get_icon_texture());
                config_settings::r_setting = combo->add_combobox(".Rusagesetting", "R usage Settings", { {"Never",nullptr},{"If Hit X enemy",nullptr }}, 1);
                r_multihit::r_setting = combo->add_slider(".rmultihitusage", "Cast R if hit X enemy", 3, 0, 5);
            }
            auto harass = main_tab->add_tab(myhero->get_model() + ".harass", "Harass Settings");
            {
            harass::manausage = harass->add_slider(".Harassonlyifmana", "Use Harass only if % Mana is Above", 50, 0, 100);
            harass::Qseparatorharas = harass->add_separator(".Qseparatorharass", "--Q Harass usage Settings--");
            harass::use_qharas = harass->add_checkbox(myhero->get_model() + ".comboUseQharass", "Use Q", true);
            harass::use_qharas->set_texture(myhero->get_spell(spellslot::q)->get_icon_texture());
            config_settingsharass::q_setting = harass->add_combobox(".Qusagesettingharass", "Q usage Settings", { {"Never",nullptr},{"Always",nullptr } }, 0);
            harass::Wseparatorharas = harass->add_separator(".Wseparatorharass", "--W Harass usage Settings--");
            harass::use_wharas = harass->add_checkbox(myhero->get_model() + ".comboUseWharass", "Use W", true);
            harass::use_wharas->set_texture(myhero->get_spell(spellslot::w)->get_icon_texture());
            config_settingsharass::w_setting = harass->add_combobox(".Wusagesettingharass", "W usage Settings", { {"Never",nullptr},{"Always",nullptr } }, 1);
            harass::Eseparatorharas = harass->add_separator(".Eseparatorharass", "--E Harass usage Settings--");
            harass::use_eharas = harass->add_checkbox(myhero->get_model() + ".comboUseEharass", "Use E", true);
            harass::use_eharas->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
            config_settingsharass::e_setting = harass->add_combobox(".Eusagesettingharass", "E usage Settings", { {"Never",nullptr},{"If Hit X feathers",nullptr } }, 1);
            e_multihitharass::e_setting = harass->add_slider(".Emultihitusageharass2", "Cast if hit X feathers", 3, 1, 5);
            }
            auto clear = main_tab->add_tab(myhero->get_model() + ".clearsettings", "Clear Settings");
            {
                hotkeys::farmonoff = clear->add_hotkey("Clearonoff", "Turn Clear on/off", TreeHotkeyMode::Toggle, 'J', false);
                auto laneclear1 = clear->add_tab(".laneclearsettings", "Lane Clear Settings");
                {
                    laneclear1::qseparatorlaneclear = laneclear1->add_separator(".Qseparatorlaneclear", "--Q Laneclear usage Settings--");
                    laneclear1::use_q = laneclear1->add_checkbox(myhero->get_model() + ".laneclearUsQ", "Use Q", true);
                    laneclear1::use_q->set_texture(myhero->get_spell(spellslot::q)->get_icon_texture());
                    laneclear1::Wseparatorlaneclear = laneclear1->add_separator(".Wseparatorlaneclear", "--W Laneclear usage Settings--");
                    laneclear1::use_w = laneclear1->add_checkbox(myhero->get_model() + ".laneclearUseW", "Use W if no enemy in range", false);
                    laneclear1::use_w->set_texture(myhero->get_spell(spellslot::w)->get_icon_texture());
                }
                auto jungleclear = clear->add_tab(".jungleclearsettings", "Jungle Clear Settings");
                {
                    jungleclear::qseparatorjglclear = jungleclear->add_separator(".Qseparatorjglclear", "--Q Jungleclear usage Settings--");
                    jungleclear::use_q = jungleclear->add_checkbox(myhero->get_model() + ".jungleclearuseq", "Use Q", true);
                    jungleclear::use_q->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
                    jungleclear::Wseparatorjglclear = jungleclear->add_separator(".Wseparatorjungleclear", "--W Jungleclear usage Settings--");
                    jungleclear::use_w = jungleclear->add_checkbox(myhero->get_model() + ".jungleclearUseW", "Use W", true);
                    jungleclear::use_w->set_texture(myhero->get_spell(spellslot::w)->get_icon_texture());
                }
              
            }


            auto misc = main_tab->add_tab(myhero->get_model() + ".misc", "Misc Settings");
            {
                misc::Qseparator = misc->add_separator(".Qseparatormisc", "--Q Settings--");
                misc::use_qks = misc->add_checkbox(myhero->get_model() + ".misceKS", "Auto Q for KS", true);
                misc::use_qks->set_texture(myhero->get_spell(spellslot::q)->get_icon_texture());
                misc::Wseparator = misc->add_separator(".Wseparatormisc", "--W Settings--");
                misc::use_wtower = misc->add_checkbox(myhero->get_model() + ".miscWtower", "Auto W under enemy tower", true);
                misc::use_wtower->set_texture(myhero->get_spell(spellslot::w)->get_icon_texture());
                misc::Eseparator = misc->add_separator(".Eseparatormisc", "--E Settings--");
                misc::use_ekill = misc->add_checkbox(myhero->get_model() + ".miscEusekill", "Auto E for KS", true);
                misc::use_ekill->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
                misc::auto_eroot = misc->add_checkbox(myhero->get_model() + ".miscEroot", "Auto E if hits 3 feather (root)", false);
                misc::auto_eroot->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
                misc::Rseparator = misc->add_separator(".Rseparatormisc", "--R Settings--");
                misc::use_revadee = misc->add_checkbox(myhero->get_model() + ".miscRevadee", "Auto R to evadee hard dodgable spells", true);
                misc::use_revadee->set_texture(myhero->get_spell(spellslot::r)->get_icon_texture());
            }
            auto draw_settings = main_tab->add_tab(myhero->get_model() + ".drawings", "Drawings Settings");
            {
                draw_settings::drawselector = draw_settings->add_combobox(".Drawselector", "Draw Mode", { {"Draw ranges with specified colors",nullptr},{"Draw ranges with RGB colors",nullptr } }, 0);
                draw_settings::drawfeathers = draw_settings->add_checkbox(myhero->get_model() + ".drawfeathers", "Draw Xayah Feathers with Line", true);
                draw_settings::drawcolorfeather = draw_settings::feather_color = draw_settings->add_colorpick(myhero->get_model() + ".drawfeathercolor", "Feather line Color picker", feathercolor);
                draw_settings::drawfeathers->set_texture(myhero->get_passive_icon_texture());
                auto drawselector = draw_settings->add_tab(myhero->get_model() + ".drawselector2", "Custom color and ranges select");
                {
                    draw_settings::draw_range_q = drawselector->add_checkbox(myhero->get_model() + ".drawingQ", "Draw Q range", true);
                    draw_settings::draw_color_q = draw_settings::q_color = drawselector->add_colorpick(myhero->get_model() + ".drawQColor", "Q Range Color picker", colorq);
                    draw_settings::draw_range_w = drawselector->add_checkbox(myhero->get_model() + ".drawingW", "Draw W range", true);
                    draw_settings::draw_color_w = draw_settings::w_color = drawselector->add_colorpick(myhero->get_model() + ".drawWColor", "W Range Color picker", colorw);
                    draw_settings::draw_range_w->set_texture(myhero->get_spell(spellslot::w)->get_icon_texture());
                    draw_settings::draw_range_e = drawselector->add_checkbox(myhero->get_model() + ".drawingE", "Draw E range", true);
                    draw_settings::draw_color_e = draw_settings::e_color = drawselector->add_colorpick(myhero->get_model() + ".drawEColor", "E Range Color picker", colore);
                    draw_settings::draw_range_e->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
                    draw_settings::draw_range_r = drawselector->add_checkbox(myhero->get_model() + ".drawingR", "Draw R range", true);
                    draw_settings::draw_color_r = draw_settings::r_color = drawselector->add_colorpick(myhero->get_model() + ".drawRColor", "R Range Color picker", colorr);
                    draw_settings::draw_range_r->set_texture(myhero->get_spell(spellslot::r)->get_icon_texture());
                }
                auto drawselector2 = draw_settings->add_tab(myhero->get_model() + ".drawselector3", "RGB color range select");
                {
                    draw_settings::draw_range_q2 = drawselector2->add_checkbox(myhero->get_model() + ".drawingQRGB", "Draw Q range with RGB", true);
                    draw_settings::draw_range_q2->set_texture(myhero->get_spell(spellslot::q)->get_icon_texture());
                    draw_settings::draw_range_w2 = drawselector2->add_checkbox(myhero->get_model() + ".drawingWRGB", "Draw W range with RGB", true);
                    draw_settings::draw_range_w2->set_texture(myhero->get_spell(spellslot::w)->get_icon_texture());
                    draw_settings::draw_range_e2 = drawselector2->add_checkbox(myhero->get_model() + ".drawingERGB", "Draw E range with RGB", true);
                    draw_settings::draw_range_e2->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
                    draw_settings::draw_range_r2 = drawselector2->add_checkbox(myhero->get_model() + ".drawingRRGB", "Draw R range with RGB", true);
                    draw_settings::draw_range_r2->set_texture(myhero->get_spell(spellslot::r)->get_icon_texture());
                }
                
                auto draw_damage = draw_settings->add_tab(myhero->get_model() + ".draw.damage", "Draw Damage");
                {
                    draw_settings::draw_damage = draw_damage->add_checkbox(myhero->get_model() + ".draw.damage.enabled", "Draw Combo Damage", true);

                    draw_settings::aa_damage = draw_damage->add_checkbox(myhero->get_model() + ".draw.damage.aa", "Draw AA Damage on enemy bar", false);
                    draw_settings::include_x_aa = draw_damage->add_slider(myhero->get_model() + ".include.x.aa", "^Include X amount of AA", 2, 1, 4);
                    draw_settings::drawaacolor = draw_settings::drawaacolor = draw_damage->add_colorpick(myhero->get_model() + ".drawAADMGColor", "AA damage Color on enemy bar", coloraa);

                    draw_settings::e_damage = draw_damage->add_checkbox("draw_damage_E", "Draw E Damage", true);
                    draw_settings::e_damage->set_texture(myhero->get_spell(spellslot::e)->get_icon_texture());
                    draw_settings::drawecolor = draw_settings::drawecolor = draw_damage->add_colorpick(myhero->get_model() + ".drawEDMGColor", "E damage Color on enemy bar", colorenemy);

                }
            }
            hotkeys::semir = main_tab->add_hotkey("SemiR", "Semi R on in range target", TreeHotkeyMode::Hold, 'Z', true);
            aio_info::aio_info_date = main_tab->add_separator(".SeparatorAIO", "--------------------");
            aio_info::aio_info_date = main_tab->add_separator(".SeparatorVersion", "Version: 2.0");
            aio_info::aio_info_date = main_tab->add_separator(".SeparatorAuthor", "Author: feetmore");


}

        event_handler<events::on_update>::add_callback(on_update, event_prority::medium);
        event_handler<events::on_env_draw>::add_callback(on_env_draw, event_prority::medium);
        event_handler<events::on_draw>::add_callback(on_draw, event_prority::medium);
        event_handler<events::on_object_dead>::add_callback(on_object_dead, event_prority::medium);
        event_handler<events::on_create_object>::add_callback(on_create);
        event_handler<events::on_delete_object>::add_callback(on_deletefeath);




      

        Permashow::Instance.Init("relaxAIO", main_tab);
        Permashow::Instance.AddElement("Lane/Jungle clear", hotkeys::farmonoff);
        Permashow::Instance.AddElement("Semi R key", hotkeys::semir);
        Permashow::Instance.AddElement("Auto E if hits 3 feather (root)", misc::auto_eroot);
        Permashow::Instance.AddElement("Auto W under enemy tower", misc::use_wtower);
        Permashow::Instance.AddElement("Auto R to evadee hard dodgable spells", misc::use_revadee);
        loadmsg::show_chatmsg = main_tab->add_checkbox(myhero->get_model() + ".showchatmsgonload", "Show Chat Message On Load", true);


        if (loadmsg::show_chatmsg->get_bool())
        {
            myhero->print_chat(0x3, "<font color=\"#33FFF9\">[<b><font color=\"#33FFF9\">relaxAIO - Xayah</font></b>]:</font> <font color=\"#55FF00\">Loaded</font>");
        }

        kills = myhero->get_hero_stat(int_hero_stat::CHAMPIONS_KILLED);
    }

void unload()
    {
        plugin_sdk->remove_spell(q);
        plugin_sdk->remove_spell(w);
        plugin_sdk->remove_spell(e);
        plugin_sdk->remove_spell(r);

        if (flash) plugin_sdk->remove_spell(flash);

        event_handler<events::on_update>::remove_handler(on_update);
        event_handler<events::on_env_draw>::remove_handler(on_env_draw);
        event_handler<events::on_draw>::remove_handler(on_draw);
        event_handler<events::on_object_dead>::remove_handler(on_object_dead);

        Permashow::Instance.Destroy();
}


 // RGB DRAWING
 unsigned long RainbowGradient(int alpha, float speed, float angle, float timeOffset)
 {
     auto r = (int)floor(sin((angle + timeOffset) / 180 * M_PI * speed) * 127 + 128);
     auto g = (int)floor(sin((angle + 120 + timeOffset) / 180 * M_PI * speed) * 127 + 128);
     auto b = (int)floor(sin((angle + 240 + timeOffset) / 180 * M_PI * speed) * 127 + 128);
     return MAKE_COLOR(r, g, b, alpha);
 }
 void drawCircle1(vector pos, int radius, int quality, int thickness = 1)
 {
     const auto points = geometry::geometry::circle_points(pos, radius, quality);

     for (int i = 0; i < points.size(); i++)
     {
         const int next_index = (i + 1) % points.size();
         const auto start = points[i];
         const auto end = points[next_index];

         vector screenPosStart;
         renderer->world_to_screen(start, screenPosStart);
         vector screenPosEnd;
         renderer->world_to_screen(end, screenPosEnd);
         if (!renderer->is_on_screen(screenPosStart, 50) && !renderer->is_on_screen(screenPosEnd, 50))
             continue;

         // Calculate the color for the current segment using the getColorByIndex function
         int alpha = 255;
         unsigned long color =RainbowGradient(alpha, 10, (i * (360.0f / quality)) + (gametime->get_prec_time() * 1000) / 5, 0);

         draw_manager->add_line(points[i].set_z(pos.z), points[next_index].set_z(pos.z), color, thickness);
     }
 }

 //feather E DMG

 constexpr float physical_damage[] = { 50.f, 60.f, 70.f, 80.f, 90.f };
 float xayah_damage_initial(game_object_script target)
 {
     auto damage = 0.;
     damage_input input;

     std::vector<game_object_script> feathers_ground;

     for (const auto& feather_entry : particleList)
     {
         if (feather_entry.particle == nullptr && !feather_entry.particle->is_valid()) continue;

         feathers_ground.push_back(feather_entry.particle);
         break;
     }
         
     if (!feathers_ground.empty())
     {
         auto feather = feathers_ground.front();
         auto pred = e->get_prediction(target, feather->get_position(), myhero->get_position());
         int feather_count = particleList.size();
         float mydmg = (0.60f * myhero->get_additional_attack_damage());
         auto v1 = pred._cast_position;
         auto v2 = feather->get_position();
         auto v3 = myhero->get_position();
         auto res = v1.project_on(v2, v3);
         auto w = 75.f;
         if (res.is_on_segment && res.segment_point.distance(v1) <= w)
         {
             //    //myhero->print_chat(0x3, "%f", mydmg);
             //myhero->print_chat(0x3, "%d", feather_count);
                 input.raw_physical_damage = ((physical_damage[feather_count - 1] * feather_count) + mydmg);
                 damage = damagelib->calculate_damage_on_unit(myhero, target, &input);
            
         }
     }
     //myhero->print_chat(0x3, "E DMG: %f", damage);
     return damage;
    
 }


 void on_object_dead(game_object_script sender)
 {
     if (sender == nullptr || sender->get_position().distance(myhero->get_position()) > 2000.f) return;


 }

    // Main update script function
void on_update()
    {

    e_multihit::e_setting->is_hidden() = config_settings::e_setting->get_int() <= 0;
    r_multihit::r_setting->is_hidden() = config_settings::r_setting->get_int() <= 0;
    e_multihitharass::e_setting->is_hidden() = config_settingsharass::e_setting->get_int() <= 0;
    draw_settings::drawcolorfeather->is_hidden() = draw_settings::drawfeathers->get_bool() == false;


        if (myhero->is_dead() == true) return;
        if (hotkeys::semir->get_bool())
        {
            r_logicsemi();
        }

        if (orbwalker->combo_mode())
        {
            if (combo::use_q->get_bool() == true)
            {
                q_logic();
            }
            if (combo::use_w->get_bool() == true)
            {
                w_logic();
            }
            if (combo::use_e->get_bool() == true)
            {
                e_logic();
            }
            if (combo::use_r->get_bool() == true)
            {
                r_logic();
            }
        }
        if (orbwalker->harass())
            if(myhero->get_mana_percent() >= harass::manausage->get_int())
            {
        {
            if (harass::use_qharas->get_bool() == true)
            {
                q_logicharass();
            }
            if (harass::use_wharas->get_bool() == true)
            {
                w_logicharass();
            }
            if (harass::use_eharas->get_bool() == true)
            {
                e_logicharass();
            }
        }
        }
        // Checking if the user has selected lane_clear_mode() (Default V)
        if (orbwalker->lane_clear_mode() && hotkeys::farmonoff->get_bool())
        {
            auto lane_minions = entitylist->get_enemy_minions();

            auto monsters = entitylist->get_jugnle_mobs_minions();

            lane_minions.erase(std::remove_if(lane_minions.begin(), lane_minions.end(), [](game_object_script x)
                {
                    return !x->is_valid_target(e->range());
                }), lane_minions.end());

            monsters.erase(std::remove_if(monsters.begin(), monsters.end(), [](game_object_script x)
                {
                    return !x->is_valid_target(e->range());
                }), monsters.end());

            std::sort(lane_minions.begin(), lane_minions.end(), [](game_object_script a, game_object_script b)
                {
                    return a->get_position().distance(myhero->get_position()) < b->get_position().distance(myhero->get_position());
                });

            std::sort(monsters.begin(), monsters.end(), [](game_object_script a, game_object_script b)
                {
                    return a->get_max_health() > b->get_max_health();
                });

            if (!lane_minions.empty())
            {

                //[q] Lane Farm usage
                if (q->is_ready() && laneclear1::use_q->get_bool())
                {
                    for (auto& minion : lane_minions)
                    {
                        auto pred = q->get_prediction(minion, true);
                        if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                        {
                            if (q->cast(pred.get_cast_position()))
                            {
                                return;
                            }

                        }
                    }
                }

                //[W] Lane Farm usage
                if (w->is_ready() && laneclear1::use_w->get_bool())
                {
                    for (auto& minion : lane_minions)
                    {
                         auto target = target_selector->get_target(w->range(), damage_type::magical);
                         if (target == nullptr && !target->is_valid_target(w->range()))
                         {
                             auto pred = w->get_prediction(minion, true);
                             if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                             {
                                 if (w->cast(pred.get_cast_position()))
                                 {
                                     return;
                                 }

                             }
                         }
                    }
                }

            }
            if (!monsters.empty())
            {
                //[Q] Jungle Farm usage
                if (q->is_ready() && jungleclear::use_q->get_bool())
                {
                    for (auto& jglminions : monsters)
                    {
                            auto pred = q->get_prediction(jglminions, true);
                            if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                            {
                                if (q->cast(pred.get_cast_position()))
                                {
                                    return;
                                }

                            }
                        }
                }
                //[W] Jungle Farm usage
                if (w->is_ready() && jungleclear::use_w->get_bool())
                {
                    for (auto& jungleminion : monsters)
                    {
                        auto pred = w->get_prediction(jungleminion, true);
                        if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                        {
                            if (w->cast(pred.get_cast_position()))
                            {
                                return;
                            }

                        }
                    }
                }



            }

}      
        // Auto E on killable
        if (misc::use_ekill->get_bool() == true)
        {
            if (!e->is_ready()) return;

            const auto enemy = target_selector->get_target(e->range(), damage_type::physical, false, false);

            if (enemy != nullptr && enemy->is_valid_target(e->range()))
            {
                if (xayah_damage_initial(enemy) >= enemy->get_real_health(true, true))
                {
                    e->cast();
                }
            }
        }
        // Auto E on root
        if (misc::auto_eroot->get_bool() == true && e->is_ready())
        {
            const auto& target = target_selector->get_target(e->range(), damage_type::physical, false, true);
            if (target != nullptr)
            {
                int countfeather = 0;
                if (!particleList.empty())
                {
                    for (auto&& feather : particleList)
                    {
                        auto pred = e->get_prediction(target, feather.particle->get_position(), myhero->get_position());
                        if (pred.get_cast_position().is_valid())
                        {
                            auto v1 = pred._cast_position;
                            auto v2 = feather.particle->get_position();
                            auto v3 = myhero->get_position();
                            auto res = v1.project_on(v2, v3);
                            auto w = 75.f;

                            if (res.is_on_segment && res.segment_point.distance(v1) <= w)
                            {
                                countfeather++;
                            }
                            if (countfeather >= 3)
                            {
                                e->cast();
                            }
                        }
                    }
                }
            }
        }
      
        // Auto W on tower
        if (misc::use_wtower->get_bool() == true && w->is_ready())
        {
            if (!w->is_ready()) return;

            if(myhero->is_under_enemy_turret())
            {
                w->cast();
            }
        }
        // Auto R to dodge hard spells
        if (misc::use_revadee->get_bool() == true && r->is_ready())
        {
            if (!r->is_ready()) return;
            const auto enemy = target_selector->get_target(r->range(), damage_type::physical, false, false);

            if (enemy != nullptr && enemy->is_valid_target(r->range()))
            {
                if(enemy->is_casting_interruptible_spell() == 2)
                {
                    auto pred = r->get_prediction(enemy, false);

                    if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                    {
                        r->cast(pred.get_cast_position());
                    }
                }
            }
        }
        // AA with Q on target position
        if (!q->is_ready() && orbwalker->combo_mode())
        {
            if (q->is_ready() || !orbwalker->combo_mode()) return;

            const auto enemy = target_selector->get_target(q->range(), damage_type::physical, false, false);
            if (enemy == nullptr || !enemy->is_valid_target()) return;

            if (enemy->get_distance(myhero) <= myhero->get_attack_range() + myhero->get_bounding_radius() + enemy->get_bounding_radius()) return;

            auto lane_minions = entitylist->get_enemy_minions();
            lane_minions.erase(std::remove_if(lane_minions.begin(), lane_minions.end(), [](game_object_script x)
                {
                    return !x->is_valid_target(myhero->get_attack_range() + myhero->get_bounding_radius() + x->get_bounding_radius());
                }), lane_minions.end());

            std::sort(lane_minions.begin(), lane_minions.end(), [](game_object_script a, game_object_script b)
                {
                    return a->get_position().distance(myhero->get_position()) < b->get_position().distance(myhero->get_position());
                });
            for (const auto& minion : lane_minions)
            {
                auto pred = q->get_prediction(enemy, minion->get_position(), myhero->get_position());
                if (pred.hitchance < hit_chance::high) continue;
                auto v1 = pred._cast_position;
                auto v2 = myhero->get_position().extend(minion->get_position(), q->range()); // probably Q range?
                auto v3 = myhero->get_position();
                auto res = v1.project_on(v2, v3);
                auto w = 75.f;
                if (res.is_on_segment && res.segment_point.distance(v1) < w)
                {
                    orbwalker->orbwalk(orbwalker->can_attack() ? minion : nullptr, v2);
                    return;
                }
            }
        }

        if (myhero->has_buff(buff_hash("XayahR")))
        {
            evade->disable_evade();
        }
        else
        {
            evade->enable_evade();
        }
}

#pragma region q_logic
    void q_logic()
    {
        // Get a target from a given range
        auto target = target_selector->get_target(q->range(), damage_type::physical);

        // Always check an object is not a nullptr!
        if (target != nullptr)
        {
            // if Never selected Q will not used
            if (config_settings::q_setting->get_int() == 0)
            {
                return;
            }
            // if After attack selected Q will be used after AA
            if (config_settings::q_setting->get_int() == 1)
            {   

                auto pred = q->get_prediction(target, false);

                if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                {
                    q->cast(pred.get_cast_position());
                }
            }
        }
    }
#pragma endregion
#pragma region q_logicharass
    void q_logicharass()
    {
        // Get a target from a given range
        auto target = target_selector->get_target(q->range(), damage_type::physical);

        // Always check an object is not a nullptr!
        if (target != nullptr)
        {
            // if Never selected Q will not used
            if (config_settingsharass::q_setting->get_int() == 0)
            {
                return;
            }
            // if After attack selected Q will be used after AA
            if (config_settingsharass::q_setting->get_int() == 1)
            {

                auto pred = q->get_prediction(target, false);

                if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                {
                    q->cast(pred.get_cast_position());
                }
            }
        }
    }
#pragma endregion

#pragma region w_logic
    void w_logic()
    {
        // Get a target from a given range
        auto target = target_selector->get_target(w->range(), damage_type::magical);

        // Always check an object is not a nullptr!
        if (target != nullptr)
        {
            // If Never is selected for W wont use
            if (config_settings::w_setting->get_int() == 0)
            {
                return;
            }
            // If Before attack is selected will cast W on enemy pos after AA
            if (config_settings::w_setting->get_int() == 1)
            {
                auto pred = w->get_prediction(target, false);

                if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high && target->is_valid_target(myhero->get_attack_range() + 200))
                {
                    w->cast(pred.get_cast_position());
                }
             }
         }
    }
#pragma endregion
#pragma region w_logicharass
    void w_logicharass()
    {
        // Get a target from a given range
        auto target = target_selector->get_target(w->range(), damage_type::magical);

        // Always check an object is not a nullptr!
        if (target != nullptr)
        {
            // If Never is selected for W wont use
            if (config_settingsharass::w_setting->get_int() == 0)
            {
                return;
            }
            // If Before attack is selected will cast W on enemy pos after AA
            if (config_settingsharass::w_setting->get_int() == 1)
            {
                auto pred = w->get_prediction(target, false);

                if (pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                {
                    w->cast(pred.get_cast_position());
                }

            }
            }
        }
#pragma endregion



#pragma region e_logic
void e_logic()
{
          const auto& target = target_selector->get_target(e->range(), damage_type::physical, false, true);
    if (target != nullptr)
          {
            //if set to None wont cast feathers
        if (config_settings::e_setting->get_int() == 0)
              {
                  return;

              }

              //if set to alyaws will cast feathers as slider
        if (config_settings::e_setting->get_int() == 1)
        {  
            int countfeather = 0;
            if (!particleList.empty())
            {
                for (auto&& feather : particleList)
                {
                auto pred = e->get_prediction(target, feather.particle->get_position(), myhero->get_position());
                if (pred.get_cast_position().is_valid())
                {
                auto v1 = pred._cast_position;
                auto v2 = feather.particle->get_position();
                auto v3 = myhero->get_position();
                auto res = v1.project_on(v2, v3);
                auto w = 75.f;

                if (res.is_on_segment && res.segment_point.distance(v1) <= w)
                {
                    countfeather++;
                }
                if (countfeather >= e_multihit::e_setting->get_int())
                {
                    e->cast();
                }
            }
                }
            }
           }

        }
}
#pragma endregion
#pragma region e_logicharass
    void e_logicharass()
    {
        auto target = target_selector->get_target(e->range(), damage_type::physical);

        // Always check an object is not a nullptr!
        if (target != nullptr)
        {
            // If Never is selected for E wont use
            if (config_settingsharass::e_setting->get_int() == 0)
            {
                return;
            }
            // If After attack is selected will cast W on enemy pos after AA - where is E logic 
            if (config_settingsharass::e_setting->get_int() == 1)
            {
                int countfeatherharass = 0;
                if (!particleList.empty())
                {
                    for (auto&& feather : particleList)
                    {
                        auto pred = e->get_prediction(target, feather.particle->get_position(), myhero->get_position());
                        if (pred.get_cast_position().is_valid())
                        {
                            auto v1 = pred._cast_position;
                            auto v2 = feather.particle->get_position();
                            auto v3 = myhero->get_position();
                            auto res = v1.project_on(v2, v3);
                            auto w = 75.f;

                            if (res.is_on_segment && res.segment_point.distance(v1) <= w)
                            {
                                countfeatherharass++;
                            }
                            if (countfeatherharass >= e_multihitharass::e_setting->get_int())
                            {
                                e->cast();
                            }
                        }
                    }
                }
            }
        }

    }
#pragma endregion

#pragma region r_logic
    void r_logic()
    {
        // Get a target from a given range
        auto target = target_selector->get_target(r->range(), damage_type::true_dmg);

        // Always check an object is not a nullptr!
        if (target != nullptr)
        {
            // If Never is selected for R it wont use
            if (config_settings::r_setting->get_int() == 0)
            {
                return;
            }
            // If Multi hit is selected will cast R on enemy pos
            if (config_settings::r_setting->get_int() == 1)
            {
                auto pred = r->get_prediction(target, false);

                if (r_multihit::r_setting->get_int() == myhero->count_enemies_in_range(r->range()) && pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
                {

                    r->cast(pred.get_cast_position());
                }

            }

        }

    }
#pragma endregion

void r_logicsemi()
{
    // Get a target from a given range
    auto target = target_selector->get_target(r->range(), damage_type::true_dmg);

    // Always check an object is not a nullptr!
    if (target != nullptr)
    {
        // If Multi hit is selected will cast R on enemy pos
            auto pred = r->get_prediction(target, false);

            if ( pred.hitchance > hit_chance::out_of_range && pred.get_cast_position().is_valid() && pred.hitchance >= hit_chance::high)
            {
                r->cast(pred.get_cast_position());
            }


    }

}
void on_env_draw()
{
        if (myhero->is_dead()) return;

        if (draw_settings::drawselector->get_int() == 0)
        {
        // Draw Q range Static color
        if (q->is_ready() && draw_settings::draw_range_q->get_bool())
                draw_manager->add_circle(myhero->get_position(), q->range(), draw_settings::draw_color_q->get_color());
        // Draw W range Static color
        if (w->is_ready() && draw_settings::draw_range_w->get_bool())
        draw_manager->add_circle(myhero->get_position(), w->range(), draw_settings::draw_color_w->get_color());
        // Draw E range Static color
        if (e->is_ready() && draw_settings::draw_range_e->get_bool())
        draw_manager->add_circle(myhero->get_position(), e->range(), draw_settings::draw_color_e->get_color());
        // Draw R range Static color
        if (r->is_ready() && draw_settings::draw_range_r->get_bool())
        draw_manager->add_circle(myhero->get_position(), r->range(), draw_settings::draw_color_r->get_color());
        }
        if (draw_settings::drawselector->get_int() == 1)
        {
            // Draw Q range RGB
            if (q->is_ready() && draw_settings::draw_range_q2->get_bool())
                drawCircle1(myhero->get_position(), q->range(), 100, 1);
            // Draw W range RGB
            if (w->is_ready() && draw_settings::draw_range_w2->get_bool())
                drawCircle1(myhero->get_position(), w->range(), 100, 1);

            // Draw E range RGB
            if (e->is_ready() && draw_settings::draw_range_e2->get_bool() )
            drawCircle1(myhero->get_position(), e->range(), 100, 1);

            // Draw R range RGB
            if (r->is_ready() && draw_settings::draw_range_r2->get_bool())
            drawCircle1(myhero->get_position(), r->range(), 100, 1);

        }
        if(draw_settings::drawfeathers->get_bool()) {
        for (const auto& particle : particleList)
        {
            draw_manager->add_line(particle.particle->get_position(), myhero->get_position(), draw_settings::drawcolorfeather->get_color(), 1);
        }
        }
}
void on_draw()
{
    if (draw_settings::draw_damage->get_bool())
    {


        for (auto& enemyaa : entitylist->get_enemy_heroes())
        {
            if (enemyaa->is_valid() && !enemyaa->is_dead() && enemyaa->is_hpbar_recently_rendered())
            {
                float damageaa = 0.0f;


                if (draw_settings::aa_damage->get_bool())
                    damageaa += myhero->get_auto_attack_damage(enemyaa) * draw_settings::include_x_aa->get_int();

                utilities::draw_dmg_rl(enemyaa, damageaa, draw_settings::drawaacolor->get_color());

            }
        }
        for (auto& enemy : entitylist->get_enemy_heroes())
        {
            if (enemy->is_valid() && !enemy->is_dead() && enemy->is_hpbar_recently_rendered())
            {
                float damage = 0.0f;

                if (e->is_ready() && draw_settings::e_damage->get_bool())
                {
                    damage += xayah_damage_initial(enemy);
                }

                utilities::draw_dmg_rl(enemy, damage, draw_settings::drawecolor->get_color());

            }
        }

    }
}
};