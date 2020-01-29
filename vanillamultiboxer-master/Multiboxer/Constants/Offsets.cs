using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Multiboxer
{
    internal static class Offsets
    {
        internal static class Player
        {
            internal static IntPtr Name = (IntPtr) 0x827D88;
            internal static IntPtr Class = (IntPtr) 0xC27E81;

            internal static IntPtr XCoord = (IntPtr) 0x00C7B548;
            internal static IntPtr YCoord = (IntPtr) 0x00C7B54C;
            internal static IntPtr ZCoord = (IntPtr) 0x00C7B544;

            internal static IntPtr IsLooting = (IntPtr) 0xB71B48;
            internal static IntPtr IsInGame = (IntPtr) 0x00B4B424;

            internal static int RealZoneText = 0xB4B404;
            internal static IntPtr ContinentText = (IntPtr) 0x00C961A0;
            internal static IntPtr MinimapZoneText = (IntPtr) 0xB4DA28;
        }

        internal static class Misc
        {
            internal static IntPtr GameVersion = (IntPtr) 0x00837C04;
            internal static IntPtr RealmName = (IntPtr) 0x00C27FC1;
        }

        internal static class ObjectManager
        {
            internal static IntPtr CurObjGuid = (IntPtr) 0x30;
            internal static IntPtr ManagerBase = (IntPtr) 0x00B41414;
            internal static IntPtr PlayerGuid = (IntPtr) 0xc0;
            internal static IntPtr FirstObj = (IntPtr) 0xac;
            internal static IntPtr NextObj = (IntPtr) 0x3c;
            internal static IntPtr ObjType = (IntPtr) 0x14;
            internal static int DescriptorOffset = 0x8;
        }

        internal static class Descriptors
        {
            internal static int Health = 0x58;
            internal static int MaxHealth = 0x70;
        }
    }
}
