using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Multiboxer
{
    class MacroGenerator
    {
        public static Dictionary<string, string> GenerateMasterMacros(string[] childNames)
        {
            // master dictionary
            Dictionary<string, string> masterClientMacros = new Dictionary<string, string>();

            // INVITE MACRO

            string inviteMacroContent = "// Bind this and AcceptGroupMacro to same key\n";

            int i = 0;

            foreach (string s in childNames)
            {
                inviteMacroContent += $"/invite {childNames[i]}\n";
                i++;
            }

            masterClientMacros.Add("InviteMacro", inviteMacroContent);

            // LEAVE MACRO

            string leaveMacroContent = "/script LeaveParty()";

            masterClientMacros.Add("LeavePartyMacro", leaveMacroContent);

            return masterClientMacros;
        }

        public static Dictionary<string, string> GenerateChildMacros(string masterName, Enums.Game.PlayerClass playerClass)
        {
            Dictionary<string, string> childClientMacros = new Dictionary<string, string>();

            // ACCEPTGROUP MACRO

            string acceptGroupMacroContent = "// Bind this and InviteMacro to same key\n" +
                                             "/script AcceptGroup()";

            childClientMacros.Add("AcceptGroupMacro", acceptGroupMacroContent);

            // ASSIST MACRO

            string assistMacroContent = $"/assist {masterName}\n" +
                                        $"/run AttackTarget()\n" +
                                        $"/follow {masterName}";

            childClientMacros.Add("AssistMacro", assistMacroContent);

            // FOLLOW MACRO

            string followMacroContent = $"/follow {masterName}";

            childClientMacros.Add("FollowMacro", followMacroContent);

            // Generate class macros
            ClassMacros(childClientMacros, masterName, playerClass);

            return childClientMacros;
        }

        public static void ClassMacros(Dictionary<string, string> macros, string masterName, Enums.Game.PlayerClass playerClass)
        {
            switch (playerClass) /* TODO: FINISH CLASS MACROS */
            {
                case Enums.Game.PlayerClass.Warrior: /* WARRIOR MACROS */

                    // HEROIC STRIKE MACRO

                    string warriorHeroicStrikeContent = $"/assist {masterName}\n" +
                                                        $"/cast Heroic Strike";

                    macros.Add("[WARRIOR]HeroicStrike", warriorHeroicStrikeContent);

                    // CHARGE MACRO

                    string warriorChargeContent = $"/assist {masterName}\n" +
                                                  $"/cast Charge";

                    macros.Add("[WARRIOR]Charge", warriorChargeContent);

                    break;

                case Enums.Game.PlayerClass.Paladin: /* PALADIN MACROS */

                    // HOLY LIGHT MACRO

                    string paladinHolyLightContent = $"/target {masterName}\n" +
                                                     $"/cast Holy Light\n";

                    macros.Add("[PALADIN]HolyLight", paladinHolyLightContent);

                    // BLESSING OF MIGHT MACRO

                    string paladinBoMContent = $"/target {masterName}\n" +
                                               $"/cast Blessing of Might";

                    macros.Add("[PALADIN]BOfMight", paladinBoMContent);

                    break;

                case Enums.Game.PlayerClass.Hunter: /* HUNTER MACROS */

                    // ARCANE SHOT MACRO

                    string hunterArcaneShotContent = $"/assist {masterName}\n" +
                                                     $"/cast Arcane Shot";

                    macros.Add("[HUNTER]ArcaneShot", hunterArcaneShotContent);

                    // CONCUSSIVE SHOT MACRO

                    string hunterConcussiveShotContent = $"/assist {masterName}\n" +
                                                         $"/cast Concussive Shot";

                    macros.Add("[HUNTER]ConcShot", hunterConcussiveShotContent);

                    break;

                case Enums.Game.PlayerClass.Rogue: /* ROGUE MACROS */
                    
                    // SINISTER STRIKE MACRO

                    string rogueSinisterStrikeContent = $"/assist {masterName}\n" +
                                                        $"/cast Sinister Strike";

                    macros.Add("[ROGUE]SinisterStrike", rogueSinisterStrikeContent);

                    // EVISCERATE MACRO

                    string rogueEviscerateContent = $"/assist {masterName}\n" +
                                                    $"/cast Eviscerate";

                    macros.Add("[ROGUE]Eviscerate", rogueEviscerateContent);

                    break;

                case Enums.Game.PlayerClass.Priest: /* PRIEST MACROS */

                    // LESSER HEAL MACRO

                    string priestLesserHealContent = $"/target {masterName}\n" +
                                                     $"/cast Lesser Heal";

                    macros.Add("[PRIEST]LesserHeal", priestLesserHealContent);

                    // SMITE MACRO

                    string priestSmiteContent = $"/assist {masterName}\n" +
                                                $"/cast Smite";

                    macros.Add("[PRIEST]Smite", priestSmiteContent);

                    // POWER WORD: FORTITUDE MACRO

                    string priestPwFortitudeContent = $"/target {masterName}\n" +
                                                      $"/cast Power Word: Fortitude";

                    macros.Add("[PRIEST]PWordFortitude", priestPwFortitudeContent);

                    break;
                case Enums.Game.PlayerClass.Shaman:
                    break;
                case Enums.Game.PlayerClass.Mage:

                    // FROSTBOLT MACRO

                    string mageFrostboltContent = $"/assist {masterName}\n" +
                                                  $"/cast Frostbolt";

                    macros.Add("[MAGE]Frostbolt", mageFrostboltContent);

                    // FIREBALL MACRO

                    string mageFireballContent = $"/assist {masterName}\n" +
                                                 $"/cast Fireball";

                    macros.Add("[MAGE]Fireball", mageFireballContent);

                    // ARCANE INTELLECT MACRO

                    string mageArcaneIntellectContent = $"/target {masterName}\n" +
                                                        $"/cast Arcane Intellect";

                    macros.Add("[MAGE]ArcaneIntellect", mageArcaneIntellectContent);

                    break;
                case Enums.Game.PlayerClass.Warlock:

                    // SHADOW BOLT MACRO

                    string warlockShadowBoltContent = $"/assist {masterName}\n" +
                                                      $"/cast Shadow Bolt";

                    macros.Add("[WARLOCK]ShadowBolt", warlockShadowBoltContent);

                    // IMMOLATE MACRO

                    string warlockImmolateContent = $"/assist {masterName}\n" +
                                                    $"/cast Immolate";

                    macros.Add("[WARLOCK]Immolate", warlockImmolateContent);

                    // CORRUPTION MACRO

                    string warlockCorruptionContent = $"/assist {masterName}\n" +
                                                      $"/cast Corruption";

                    macros.Add("[WARLOCK]Corruption", warlockCorruptionContent);

                    break;
                case Enums.Game.PlayerClass.Druid:
                    break;
            }
        }
    }
}
