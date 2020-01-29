using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Multiboxer
{
    public static class Enums
    {
        public static class Multiboxer
        {
            public enum PlayerClientType
            {
                Master,
                Child
            }
        }

        public static class Game
        {
            public enum PlayerClass : byte
            {
                None = 0,
                Warrior = 1,
                Paladin = 2,
                Hunter = 3,
                Rogue = 4,
                Priest = 5,
                Deathknight = 6,
                Shaman = 7,
                Mage = 8,
                Warlock = 9,
                Druid = 11
            }
        }
    }
}
