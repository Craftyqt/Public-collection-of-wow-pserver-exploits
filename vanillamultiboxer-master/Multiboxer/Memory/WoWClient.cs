using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using Jupiter;

namespace Multiboxer
{
    public class WoWClient // Currently, the architecture of this class does not reflect the architecture of the game. Not of huge importance for something like a multiboxer that only reads data, however if writing a bot you would need to structure this very differently (WoWObject -> WoWUnit -> LocalPlayer, etc.)
    {
        // Fields
        private MemoryModule _mem;

        // Properties
        public PlayerInfo Player { get; private set; }
        public Process GameProcess { get; private set; }
        public Encoding StringEncoding { get; private set; }
        public IntPtr BaseAddress { get; private set; }

        // Private methods

        private void InitializeClient()
        {
            if (GameProcess != null && BaseAddress != null)
            {
                Player = new PlayerInfo(this);
            }

            if (StringEncoding == null)
            {
                SetEncoding(Encoding.UTF8); // wow's encoding format
            }
        }

        // Constructors

        public WoWClient()
        {
            GameProcess = null;
            BaseAddress = IntPtr.Zero;
        }

        public WoWClient(int procId)
        {
            SetClient(procId);
        }

        public WoWClient(int procId, Encoding encoding)
        {
            SetClient(procId);
            SetEncoding(encoding);
        }

        // Mutators

        public void SetClient(int procId)
        {
            try
            {
                Process client = Process.GetProcessById(procId);

                _mem = new MemoryModule();

                GameProcess = client;
                BaseAddress = client.MainModule.BaseAddress;

                InitializeClient();
            }
            catch (Exception b)
            {
                //
            }
        }

        public void SetEncoding(Encoding encoding) => StringEncoding = encoding;

        /// <summary>
        /// Reads memory, returning a value of the specified type (cannot be used for strings)
        /// </summary>
        /// <typeparam name="T">The type to read as.</typeparam>
        /// <returns></returns>
        public T ReadAsType<T>(IntPtr address) where T : struct
        {
            return _mem.ReadMemory<T>(GameProcess.Id, address);
        }

        /// <summary>
        /// Reads memory from the base address, returning a value of specified type (cannot be used for strings)
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="address"></param>
        /// <returns></returns>
        public T ReadAsTypeBase<T>(IntPtr address) where T : struct
        {
            return _mem.ReadMemory<T>(GameProcess.Id, BaseAddress + (int)address);
        }

        /// <summary>
        /// Reads a string from the process memory
        /// </summary>
        /// <param name="address">The address of the string to read</param>
        /// <param name="maxSize">The maximum size of the string</param>
        /// <returns></returns>
        public string ReadString(IntPtr address, int maxSize = 512)
        {
            var memoryStringBytes = _mem.ReadMemory(GameProcess.Id, address, maxSize);

            var ret = StringEncoding.GetString(memoryStringBytes);

            if (ret.IndexOf('\0') != -1)
            {
                ret = ret.Remove(ret.IndexOf('\0'));
            }

            return ret;
        }

        /// <summary>
        /// Reads a string from the base address of the process memory (some values, such as player name, require this)
        /// </summary>
        /// <param name="address">The address of the string to read</param>
        /// <param name="maxSize">The maximum size of the string</param>
        /// <returns></returns>
        public string ReadStringBase(IntPtr address, int maxSize = 512)
        {
            var memoryStringBytes = _mem.ReadMemory(GameProcess.Id, BaseAddress + (int)address, maxSize); // This differs from the above here, in that you must add the offset to the base address in order to read it.

            var ret = StringEncoding.GetString(memoryStringBytes);

            if (ret.IndexOf('\0') != -1)
            {
                ret = ret.Remove(ret.IndexOf('\0'));
            }

            return ret;
        }

        /// <summary>
        /// Contains information about the Player for a WoWClient
        /// </summary>
        public class PlayerInfo
        {
            // fields
            private WoWClient _gameClient;

            // Constructor
            public PlayerInfo(WoWClient client)
            {
                _gameClient = client;
            }

            /* Properties */

            // Program

            public Enums.Multiboxer.PlayerClientType ClientType
            {
                get
                {
                    if (InputCallback.ProcManager.MasterClient.GameProcess.Id == _gameClient.GameProcess.Id)
                    {
                        return Enums.Multiboxer.PlayerClientType.Master;
                    }
                    else
                    {
                        return Enums.Multiboxer.PlayerClientType.Child;
                    }
                }
            }

            // World/Server/Misc
            public string GameVersion => _gameClient.ReadString(Offsets.Misc.GameVersion);
            public string RealmName => _gameClient.ReadString(Offsets.Misc.RealmName);

            // In-game
            public string Name
            {
                get
                {
                    if (IsInGame)
                    {
                        return _gameClient.ReadStringBase(Offsets.Player.Name);
                    }
                    else
                    {
                        return "Not connected";
                    }
                }
            }

            public bool IsLooting => _gameClient.ReadAsType<bool>(Offsets.Player.IsLooting);
            public bool IsInGame => _gameClient.ReadAsType<bool>(Offsets.Player.IsInGame);

            public byte ClassID => _gameClient.ReadAsType<byte>(Offsets.Player.Class);
            public string ClassName => ((Enums.Game.PlayerClass)ClassID).ToString();
            public Enums.Game.PlayerClass Class => (Enums.Game.PlayerClass)ClassID;

            public float PlayerX => _gameClient.ReadAsType<float>(Offsets.Player.XCoord);
            public float PlayerY => _gameClient.ReadAsType<float>(Offsets.Player.YCoord);
            public float PlayerZ => _gameClient.ReadAsType<float>(Offsets.Player.ZCoord);

            public Location PlayerLocation
            {
                get => new Location(PlayerX, PlayerY, PlayerZ);
            }
        }
    }
}
